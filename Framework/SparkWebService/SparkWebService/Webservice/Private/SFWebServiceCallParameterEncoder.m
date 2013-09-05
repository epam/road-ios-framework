//
//  SFWebServiceCallParameterEncoder.m
//  SparkWebservice
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

#import "SFWebServiceCallParameterEncoder.h"
#import "SFSerializationDelegate.h"
#import "SFWebServiceURLBuilderParameter.h"
#import "SFAttachment.h"
#import "SFMultipartData.h"
#import "SFWebServiceClient.h"

@implementation SFWebServiceCallParameterEncoder

+ (void)encodeParameters:(NSArray *)parameterList forClient:(SFWebServiceClient *)webClient methodName:(NSString *)methodName withSerializator:(id<SFSerializationDelegate>)serializator callbackBlock:(void(^)(NSDictionary *parameters, NSData *postData, BOOL isMultipartData))callbackBlock {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:[parameterList count]];
    NSMutableData *bodyData;
    NSString *boundary;
    BOOL isMultipartData = NO;
    
    for (id object in parameterList) {
        
        NSString *key = [NSString stringWithFormat:@"%d", [result count]];
        id encodedObject;
        
        if ([object isKindOfClass:[NSString class]]) {
            encodedObject = object;
        }
        else if ([object respondsToSelector:@selector(stringValue)]) {
            encodedObject = [object stringValue];
        }
        else if([object isKindOfClass:[NSData class]]) {
            
            encodedObject = @"";
            NSAssert(bodyData == nil,@"The body data can not been setted more than once");
            bodyData = object;
        }
        else if([object isKindOfClass:[SFAttachment class]]) {
            
            encodedObject = @"";
            if (!bodyData) {
                bodyData = [[NSMutableData alloc] init];
            }
            
            boundary = [self boundaryFromWebServiceClient:webClient withMethodName:methodName];
            isMultipartData = YES;
            [self addAttachment:object toBodyData:bodyData boundary:boundary];
        }
        else if ([object isKindOfClass:[NSArray class]]
                 && [object count] > 0
                 && [object[0] isKindOfClass:[SFAttachment class]]) {
            
            encodedObject = @"";
            if (!bodyData) {
                bodyData = [[NSMutableData alloc] init];
            }
            
            boundary = [self boundaryFromWebServiceClient:webClient withMethodName:methodName];
            isMultipartData = YES;
            [self addAttachments:object toBodyData:bodyData boundary:boundary];
        }
        else if ([[object class] hasAttributesForClassWithAttributeType:[SFWebServiceURLBuilderParameter class]]) {
            encodedObject = object;
        }
        else {
            if ([serializator respondsToSelector:@selector(serializeObject:)]) {
                encodedObject = [serializator serializeObject:object];
            }
            NSAssert(encodedObject != nil, @"Encoded object must be a valid object not nil");
        }
        
        // store encoded objects
        [result setObject:encodedObject forKey:key];
    }
    
    callbackBlock(result, bodyData, isMultipartData);
}

+ (void)addAttachments:(NSArray *)attachments toBodyData:(NSMutableData *)bodyData boundary:(NSString *)boundary {
    for (SFAttachment *attachment in attachments) {
        [self addAttachment:attachment toBodyData:bodyData boundary:boundary];
    }
}

+ (void)addAttachment:(SFAttachment *)attachment toBodyData:(NSMutableData *)bodyData boundary:(NSString *)boundary {
    NSMutableData * nextAttachment = [[NSMutableData alloc] init];
    if (!bodyData.length) {
        [nextAttachment appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    [nextAttachment appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", attachment.name, attachment.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [nextAttachment appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", attachment.contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    [nextAttachment appendData:[NSData dataWithData:attachment.data]];
    [nextAttachment appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:nextAttachment];
}

+ (NSString *)boundaryFromWebServiceClient:(id)webServiceClient withMethodName:(NSString *)methodName {
    SFMultipartData *multipartDataAttribute = [[webServiceClient class] attributeForMethod:methodName withAttributeType:[SFMultipartData class]];
    if (!multipartDataAttribute.boundary) {
        // Some random default boundary
        multipartDataAttribute.boundary = @"AaB03x";
    }
    return multipartDataAttribute.boundary;
}

@end
