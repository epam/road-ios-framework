//
//  SFWebServiceClient+DynamicMethod.m
//  SparkWebService
//
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
// list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
// may be used to endorse or promote products derived from this software without
// specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.


#import <objc/runtime.h>
#import "SFWebServiceCall.h"
#import "SFWebServiceClient+DynamicMethod.h"
#import <Spark/SparkSerialization.h>
#import <Spark/SparkServices.h>
#import "SFWebServiceCancellable.h"
#import "SFSerializationDelegate.h"
#import "SFWebServiceCallParameterEncoder.h"
#import "SFWebServiceHeader.h"
#import "SFDownloader.h"
#import "SFWebServiceLogger.h"
#import "SFWebServiceURLBuilder.h"
#import "SFWebServiceSerializationHandler.h"
#import "SFWebServiceClientStatusCodes.h"
#import "SFBasicAuthenticationProvider.h"
#import "SFAuthenticating.h"
#import "SFWebServiceBasicURLBuilder.h"

@implementation SFWebServiceClient (DynamicMethod)

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    
    // retrieves the attribute for the selector
    SFWebServiceCall *attribute = [self SF_attributeForMethod:NSStringFromSelector(sel) withAttributeType:[SFWebServiceCall class]];
    BOOL result;
    
    // if the attribute is found, attempt to add a dynamic implementation
    if (attribute) {
        [self addDynamicWebserviceCallForSelector:sel];
        result = YES;
    }
    else {
        result = [super resolveInstanceMethod:sel];
    }
    
    return result;
}

+ (void)addDynamicWebserviceCallForSelector:(const SEL)selector {
    const char *encoding;
    IMP implementation;
    
    implementation = [self instanceMethodForSelector:@selector(dynamicWebServiceCall:)];
    encoding = "@@:@";
    
    // adding the implementation to the class
    class_replaceMethod([self class], selector, implementation, encoding);
}

- (id<SFWebServiceCancellable>)dynamicWebServiceCall:(id)firstParameter, ... {
    
    int parameterCount = [[NSStringFromSelector(_cmd) componentsSeparatedByString:@":"] count] - 1;
    NSMutableArray *parameterList = [NSMutableArray array];
    
    va_list arguments;
    va_start(arguments, firstParameter);
    
    for (int i = 0; i < parameterCount; i++) {
        
        // add the argument to the parameter list
        id parameter = (i == 0) ? firstParameter : va_arg(arguments, id);
        
        if (!parameter) {
            parameter = [NSNull null];
        }
        
        [parameterList addObject:parameter];
    }
    va_end(arguments);
    
    id successBlock;
    id failureBlock;
    
    id lastParameter;
    id parameterBeforeLastParameter;

    // Check whether one or two last parameters are blocks
    lastParameter = [parameterList lastObject];
    if ([self isBlockObject:lastParameter]) {
        [parameterList removeLastObject];
        parameterBeforeLastParameter = [parameterList lastObject];
        if ([self isBlockObject:parameterBeforeLastParameter]) {
            [parameterList removeLastObject];
        }
        else {
            parameterBeforeLastParameter = nil;
        }
    }
    
    // Two blocks : success and failure blocks
    if (parameterBeforeLastParameter) {
        successBlock = parameterBeforeLastParameter;
        failureBlock = lastParameter;
    }
    // One block : only success block
    else if (lastParameter) {
        successBlock = lastParameter;
    }
    
    id prepareToLoadBlock;
    // if there are parameters, the last one can be the prepareToLoad block
    if (parameterList.count > 0) {
        prepareToLoadBlock = [parameterList lastObject];
        if ([self isBlockObject:prepareToLoadBlock]) {
            [parameterList removeLastObject];
        } else {
            prepareToLoadBlock = nil;
        }
    }
    
    // finally pass the parameters to the dynamic method
    return [self executeDynamicInstanceMethodForSelector:_cmd parameters:parameterList prepareToLoadBlock:prepareToLoadBlock success:successBlock failure:failureBlock];
}

- (id<SFWebServiceCancellable>)executeDynamicInstanceMethodForSelector:(SEL)selector parameters:(NSArray *)parameterList prepareToLoadBlock:(SFWebServiceClientPrepareForSendRequestBlock)prepareToLoadBlock success:(id)successBlock failure:(id)failureBlock {
    NSString *methodName = NSStringFromSelector(selector);
    __block NSData *bodyData;
    __block NSDictionary *parametersDictionary;
    __block SFDownloader *downloader = [[SFDownloader alloc] initWithClient:self methodName:methodName authenticationProvider:self.authenticationProvider];
    downloader.successBlock = successBlock;
    downloader.failureBlock = failureBlock;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(queue, ^{
        
        [SFWebServiceCallParameterEncoder encodeParameters:parameterList forClient:self methodName:methodName withSerializator:self.serializationDelegate callbackBlock:^(NSDictionary *parameters, NSData *postData, BOOL isMultipartData) {
            parametersDictionary = parameters;
            bodyData = postData;
            downloader.multipartData = isMultipartData;
        }];
        
        [self performCall:selector values:parametersDictionary body:bodyData request:downloader processingQueue:queue prepareForSendRequestBlock:prepareToLoadBlock];
    });
    
    return downloader;
}


- (void)performCall:(SEL)selector
             values:(NSDictionary *const)values
               body:(NSData *const)httpBody
            request:(SFDownloader *)downloader
    processingQueue:(dispatch_queue_t)processingQueue
prepareForSendRequestBlock:(SFWebServiceClientPrepareForSendRequestBlock)prepareForSendRequestBlock {
    dispatch_async(processingQueue, ^{
        NSString *methodName = NSStringFromSelector(selector);
        
        SFWebServiceCall *callAttribute = [[self class] SF_attributeForMethod:methodName withAttributeType:[SFWebServiceCall class]];
        
        // Getting url parser from attribute or using default one
        SFWebServiceURLBuilder *urlParserAttribute = [[self class] SF_attributeForMethod:methodName withAttributeType:[SFWebServiceURLBuilder class]];
        Class urlParserClass = urlParserAttribute.builderClass;
        if (urlParserClass == nil) {
            urlParserClass = [SFWebServiceBasicURLBuilder class];
        }
        
        NSURL *apiUrl = nil;
        if ([urlParserClass conformsToProtocol:@protocol(SFWebServiceURLBuilding)]) {
            apiUrl = [urlParserClass urlFromTemplate:callAttribute.relativePath withServiceRoot:self.serviceRoot values:values];
        }
        
        // Creating request and configuring it with provided parameters
        [downloader configureRequestForUrl:apiUrl body:httpBody sharedHeaders:self.sharedHeaders values:values];
        
        if (prepareForSendRequestBlock != nil) {
            prepareForSendRequestBlock(downloader.request);
        }
        
        [downloader start];
    });
}

- (BOOL)isBlockObject:(id)aBlock {
    return [[aBlock class] isSubclassOfClass:NSClassFromString(@"NSBlock")];
}

@end
