//
//  RFWebServiceCallParameterEncoder.m
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


#import "RFWebServiceCallParameterEncoder.h"
#import <ROAD/ROADCore.h>

#import "RFSerializationDelegate.h"
#import "RFWebServiceURLBuilderParameter.h"
#import "RFWebServiceCall.h"
#import "RFWebServiceSerializationHandler.h"
#import "RFFormData.h"
#import "RFMultipartData.h"
#import "RFWebServiceClient.h"


static NSString * const kRFBoundaryDefaultString = @"AaB03x";


@implementation RFWebServiceCallParameterEncoder

+ (void)encodeParameters:(NSArray *)parameterList attributes:(NSArray *)attributes withSerializer:(id<RFSerializationDelegate>)serializer callbackBlock:(void (^)(NSDictionary *, NSData *, BOOL))callbackBlock {
    
    NSMutableDictionary *result = [[NSMutableDictionary alloc] initWithCapacity:[parameterList count]];
    NSMutableData *bodyData;
    NSString *boundary;
    BOOL isMultipartData = NO;
    
    for (id object in parameterList) {
        
        NSString *key = [NSString stringWithFormat:@"%lu", (long unsigned)[result count]];
        __block id encodedObject;
        
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
        else if([object isKindOfClass:[RFFormData class]]) {
            
            encodedObject = @"";
            if (!bodyData) {
                bodyData = [[NSMutableData alloc] init];
            }
            
            boundary = [self boundaryFromAttributes:attributes];
            isMultipartData = YES;
            [self addAttachment:object toBodyData:bodyData boundary:boundary];
        }
        else if ([object isKindOfClass:[NSArray class]]
                 && [object count] > 0
                 && [object[0] isKindOfClass:[RFFormData class]]) {
            
            encodedObject = @"";
            if (!bodyData) {
                bodyData = [[NSMutableData alloc] init];
            }
            
            boundary = [self boundaryFromAttributes:attributes];
            isMultipartData = YES;
            [self addAttachments:object toBodyData:bodyData boundary:boundary];
        }
        else if ([[object class] RF_attributeForClassWithAttributeType:[RFWebServiceURLBuilderParameter class]]
                 || object == [NSNull null]) {
            encodedObject = object;
        }
        else if ([[object class] isSubclassOfClass:NSClassFromString(@"NSBlock")]) {
            encodedObject = [object copy];
        }
        else {
            if ([serializer respondsToSelector:@selector(serializeObject:)]) {
                [RFWebServiceSerializationHandler serializeObject:object withSerialzer:serializer withCompletitionBlock:^(NSString *serializedString, NSError *error)
                 {
                     // TODO: error handling
                     encodedObject = serializedString;
                 }];
            }
            NSAssert(encodedObject != nil, @"Encoded object must be a valid object not nil");
        }
        
        // store encoded objects
        result[key] = encodedObject;
    }
    
    callbackBlock(result, bodyData, isMultipartData);
}

+ (void)addAttachments:(NSArray *)attachments toBodyData:(NSMutableData *)bodyData boundary:(NSString *)boundary {
    for (RFFormData *attachment in attachments) {
        [self addAttachment:attachment toBodyData:bodyData boundary:boundary];
    }
}

+ (void)addAttachment:(RFFormData *)attachment toBodyData:(NSMutableData *)bodyData boundary:(NSString *)boundary {
    NSAssert(attachment.name
             && attachment.data, @"Attachment has not filled required properties");
    
    NSMutableData * nextAttachment = [[NSMutableData alloc] init];
    if (!bodyData.length) {
        [nextAttachment appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    }

    if (attachment.fileName.length > 0) {
        [nextAttachment appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", attachment.name, attachment.fileName] dataUsingEncoding:NSUTF8StringEncoding]];
        [nextAttachment appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", attachment.contentType] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    else {
        [nextAttachment appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", attachment.name] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [nextAttachment appendData:[NSData dataWithData:attachment.data]];
    
    [nextAttachment appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [bodyData appendData:nextAttachment];
}

+ (NSString *)boundaryFromAttributes:(NSArray *)attributes {
    RFMultipartData *multipartDataAttribute = [attributes RF_firstObjectWithClass:[RFMultipartData class]];
    NSString *boundary;
    if (!multipartDataAttribute.boundary) {
        // Default boundary
        boundary = kRFBoundaryDefaultString;
    }
    else {
        boundary = multipartDataAttribute.boundary;
    }
    
    return boundary;
}

@end
