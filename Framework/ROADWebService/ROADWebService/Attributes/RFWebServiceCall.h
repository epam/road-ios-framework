//
//  RFWebServiceCall.h
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

#import <ROAD/ROADAttribute.h>

@interface RFWebServiceCall : NSObject

/**
 * Specifies path relative to service root of web service client.
 */
@property (strong, nonatomic) NSString *relativePath;

/**
 * List valid status codes of response for annotated method (array of `NSNumber` or `NSValue` range values).
 */
@property (copy, nonatomic) NSArray* successCodes;

/**
 * Specifies if successCodes parameter do or not override global settings (for web service client class). Default - YES.
 */
@property (assign, nonatomic) BOOL overrideGlobalSuccessCodes;

/**
 * Sets the HTTP request method of the receiver.
 */
@property (copy, nonatomic) NSString *method;

/**
 * Specifies class which represents response.
 */
@property (strong, nonatomic) Class prototypeClass;

/**
 * Specifies key path to prototype class in response.
 */
@property (copy, nonatomic) NSString *serializationRoot;

/**
 * Manually disable serialization of response.
 */
@property (nonatomic) BOOL serializationDisabled;

/**
 * Works only if method == @"POST". Specifies index of parameter from method, which will be sent in request body. Numeration starts from 0.
 */
@property (assign, nonatomic) int postParameter;

/**
 * Forces web service request to perform synchronously with the thread it was created from.
 * Rquest is asynchronous by default
 */
@property (assign, nonatomic) BOOL syncCall;


@end
