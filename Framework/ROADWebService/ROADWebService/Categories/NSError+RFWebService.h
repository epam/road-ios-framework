//
//  NSError+RFWebService.h
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


#import <Foundation/Foundation.h>

extern NSString * const kRFWebServiceErrorDomain;
extern NSString * const kRFWebServiceRecievedDataKey;
extern NSString * const kRFWebServiceCancellationReason;

extern const NSInteger kRFWebServiceErrorCodeSerialization;
extern const NSInteger kRFWebServiceErrorCodeCancel;

@interface NSError (RFWebService)

/**
 * Create serialization error, and insert the original object into the error userinfo.
 * @param object The original data.
 * @return The error with serialization code and the object to be sent.
 */
+ (NSError *)RFWS_serializationErrorWithObject:(id)object;

/**
 * Create deserialization error, and insert the original data into the error userinfo.
 * @param data The original data.
 * @return The error with deserialization code and received data.
 */
+ (NSError *)RFWS_deserializationErrorWithData:(NSData *)data;

/**
 * Create cancel error for cancelled web service calls.
 * @return The error with cancellation code.
 */
+ (NSError *)RFWS_cancelError;

/**
 * Create cancel error for cancelled web service calls with reason.
 * @param reason An any reason why web service call will be cancelled. Will be passed to user in userInfo dictionary with kRFWebServiceCancellationReason key.
 * @return The error with cancellation reason.
 */
+ (NSError *)RFWS_cancelErrorWithReason:(id)reason;

@end
