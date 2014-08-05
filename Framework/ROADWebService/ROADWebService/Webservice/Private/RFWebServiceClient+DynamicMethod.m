//
//  RFWebServiceClient+DynamicMethod.m
//  ROADWebService
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


#import <objc/runtime.h>
#import "RFWebServiceCall.h"
#import "RFWebServiceClient+DynamicMethod.h"
#import <ROAD/ROADSerialization.h>
#import <ROAD/ROADServices.h>
#import "RFWebServiceCancellable.h"
#import "RFSerializationDelegate.h"
#import "RFWebServiceCallParameterEncoder.h"
#import "RFWebServiceHeader.h"
#import "RFDownloader.h"
#import "RFWebServiceURLBuilder.h"
#import "RFWebServiceSerializationHandler.h"
#import "RFWebServiceClientStatusCodes.h"
#import "RFBasicAuthenticationProvider.h"
#import "RFAuthenticating.h"
#import "RFWebServiceBasicURLBuilder.h"
#import "RFWebServiceSerializer.h"
#import "RFWebServiceRequestProcessing.h"

@implementation RFWebServiceClient (DynamicMethod)

/**
 * Handles the invocation for the web service client instance
 *
 * @param inv NSInvocation the invocation which encapsulates the dynamic method
 */
- (void)forwardInvocation:(NSInvocation *)inv {
    NSUInteger n = [[inv methodSignature] numberOfArguments];

    NSMutableArray *parameterList = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < n - 2; i++) {
        id __unsafe_unretained arg;
        [inv getArgument:&arg atIndex:(int)(i + 2)];
        if (!arg) {
            arg = [NSNull null];
        }
        [parameterList addObject:arg];
    }
    [self dynamicWebServiceCallWithArguments:parameterList forInvocation:inv];
}

/**
 * Retrieves the method signature for the provided selector
 *
 * @param aSelector SEL
 *
 * @return NSMethodSignature the methodsignature for the selector
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSUInteger numArgs = [[NSStringFromSelector(aSelector) componentsSeparatedByString:@":"] count] - 1;
    return [NSMethodSignature signatureWithObjCTypes:[[@"@@:@" stringByPaddingToLength:numArgs + 3 withString:@"@" startingAtIndex:0] UTF8String]];
}

/**
 * Prepares and checks the parameterlist for the webservice methods 
 * and executes the instance dynamic method from the invocation
 *
 * @param parameterList NSMutableArray teh parameterlist
 * @param invocation    the incovation for the dynamic method
 */
- (void)dynamicWebServiceCallWithArguments:(NSMutableArray *)parameterList forInvocation:(NSInvocation *)invocation {

    NSAssert([parameterList count] >= 2, @"Method signature must have at least two parameters - completion blocks. Example: - (id)sendRequestWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;");
    // Check whether one or two last parameters are blocks
    id lastParameter = [self lastBlockObject:parameterList];
    id parameterBeforeLastParameter = [self lastBlockObject:parameterList];

    // Two blocks : success and failure blocks
    id successBlock;
    id failureBlock;
    if (parameterBeforeLastParameter) {
        successBlock = parameterBeforeLastParameter;
        failureBlock = lastParameter;
    }
    // One block : only success block
    else if (lastParameter) {
        successBlock = lastParameter;
    }

    // if there are parameters, the last one can be the prepareToLoad block
    id prepareToLoadBlock = [self lastObjectIfBlock:parameterList];

    // finally pass the parameters to the dynamic method
    id result = [self executeDynamicInstanceMethodForSelector:invocation.selector parameters:parameterList prepareToLoadBlock:prepareToLoadBlock success:successBlock failure:failureBlock];
    [invocation setReturnValue:&result];
}

- (id<RFWebServiceCancellable>)executeDynamicInstanceMethodForSelector:(SEL)selector
                                                            parameters:(NSArray *)parameterList
                                                    prepareToLoadBlock:(RFWebServiceClientPrepareForSendRequestBlock)prepareToLoadBlock
                                                               success:(id)successBlock
                                                               failure:(id)failureBlock {
    NSString *methodName = NSStringFromSelector(selector);

    __block RFDownloader *downloader = [[RFDownloader alloc] initWithClient:self methodName:methodName authenticationProvider:self.authenticationProvider];
    downloader.successBlock = successBlock;
    downloader.failureBlock = failureBlock;

    __block NSData *bodyData;
    __block NSDictionary *parametersDictionary;

    RFWebServiceSerializer *serializerAttribute = [[self class] RF_attributeForMethod:methodName withAttributeType:[RFWebServiceSerializer class]];
    id<RFSerializationDelegate> serializationDelegate;
    if (serializerAttribute.serializerClass) {
        serializationDelegate = [[serializerAttribute.serializerClass alloc] init];
    }
    else {
        serializationDelegate = self.serializationDelegate;
    }

    [RFWebServiceCallParameterEncoder encodeParameters:parameterList forClient:self methodName:methodName withSerializator:serializationDelegate callbackBlock:^(NSDictionary *parameters, NSData *postData, BOOL isMultipartData) {
        parametersDictionary = parameters;
        bodyData = postData;
        downloader.multipartData = isMultipartData;
    }];

    RFWebServiceCall  *callAttribute = [[self class] RF_attributeForMethod:methodName withAttributeType:[RFWebServiceCall class]];

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);

    if (callAttribute.syncCall) {
        dispatch_sync(queue, ^{
            [self performCall:selector values:parametersDictionary body:bodyData request:downloader processingQueue:queue prepareForSendRequestBlock:prepareToLoadBlock];
        });
    }
    else {
        dispatch_async(queue, ^{
            [self performCall:selector values:parametersDictionary body:bodyData request:downloader processingQueue:queue prepareForSendRequestBlock:prepareToLoadBlock];
        });
    }

    return downloader;
}

- (void)performCall:(SEL)selector
             values:(NSDictionary *const)values
               body:(NSData *const)httpBody
            request:(RFDownloader *)downloader
    processingQueue:(dispatch_queue_t)processingQueue
prepareForSendRequestBlock:(RFWebServiceClientPrepareForSendRequestBlock)prepareForSendRequestBlock {

    NSString *methodName = NSStringFromSelector(selector);

    RFWebServiceCall *callAttribute = [[self class] RF_attributeForMethod:methodName withAttributeType:[RFWebServiceCall class]];

    // Getting url parser from attribute or using default one
    RFWebServiceURLBuilder *urlParserAttribute = [[self class] RF_attributeForMethod:methodName withAttributeType:[RFWebServiceURLBuilder class]];
    Class urlParserClass = urlParserAttribute.builderClass;
    if (urlParserClass == nil) {
        urlParserClass = [RFWebServiceBasicURLBuilder class];
    }

    NSURL *apiUrl = nil;
    if ([urlParserClass conformsToProtocol:@protocol(RFWebServiceURLBuilding)]) {
        apiUrl = [urlParserClass urlFromTemplate:callAttribute.relativePath withServiceRoot:self.serviceRoot values:values urlBuilderAttribute:urlParserAttribute];
    }

    // Creating request and configuring it with provided parameters
    [downloader configureRequestForUrl:apiUrl body:httpBody sharedHeaders:self.sharedHeaders values:values];

    // Pass the request and any attribute on the method to a request processor.
    [self.requestProcessor processRequest:downloader.request attributesOnMethod:[[self class] RF_attributesForMethod:methodName]];

    if (prepareForSendRequestBlock != nil) {
        prepareForSendRequestBlock(downloader.request);
    }
    
    [downloader checkCacheAndStart];
}

- (id)lastObjectIfBlock:(NSMutableArray *)parameterList {
    id lastObject = [parameterList lastObject];
    if ([[lastObject class] isSubclassOfClass:NSClassFromString(@"NSBlock")]) {
        [parameterList removeLastObject];
    } else if (lastObject == [NSNull null]) {
        [parameterList removeLastObject];
        lastObject = nil;
    }
    else {
        lastObject = nil;
    }
    
    return lastObject;
}

- (id)lastBlockObject:(NSMutableArray *)parameterList {
    id lastObject = [parameterList lastObject];
    if ([[lastObject class] isSubclassOfClass:NSClassFromString(@"NSBlock")]) {
        [parameterList removeLastObject];
    } else if (lastObject == [NSNull null]) {
        [parameterList removeLastObject];
        lastObject = nil;
    }
    else {
        NSAssert([[lastObject class] isSubclassOfClass:NSClassFromString(@"NSBlock")] || lastObject == [NSNull null], @"Last two parameters must be completion blocks (or nil - to ignore completion handling). Example: - (id)sendRequestWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;");
    }
    
    return lastObject;
}

@end
