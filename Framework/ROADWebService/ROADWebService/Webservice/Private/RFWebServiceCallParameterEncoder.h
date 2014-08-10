//
//  RFWebServiceCallParameterEncoder.h
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


@protocol RFSerializationDelegate;
@class RFWebServiceClient;


static NSString * const kRFBoundaryDefaultString;


/**
 Parameter encoder to create parameters for the webservice.
 */
@interface RFWebServiceCallParameterEncoder : NSObject

/**
 It will create a parameter dictionary based on the parameter list array. If it needs to be serialized, the serializator object will be used. If one object is NSData, it will be sent back as a post data.
 @param parameterList The list of parameters
 @param webClient The web client which handle service request
 @param methodName The method name is selector name which was invoked
 @param serializator The serializator object
 @param callbackBlock The callback block which will be called.
 */
+ (void)encodeParameters:(NSArray *)parameterList forClient:(RFWebServiceClient *)webClient methodName:(NSString *)methodName withSerializator:(id<RFSerializationDelegate>)serializator callbackBlock:(void(^)(NSDictionary *parameters, NSData *postData, BOOL isMultipartData))callbackBlock;

@end
