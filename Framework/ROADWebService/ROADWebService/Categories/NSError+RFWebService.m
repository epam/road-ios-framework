//
//  NSError+RFWebService.m
//  ROADWebService
//
//  Copyright (c) 2014 Epam Systems. All rights reserved.
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing


#import "NSError+RFWebService.h"


NSString * const kRFWebServiceErrorDomain               = @"RFWebServiceError";
NSString * const kRFWebServiceRecievedDataKey           = @"RFRecievedData";
NSString * const kRFWebServiceCancellationReason        = @"RFCancellationReason";

const NSInteger kRFWebServiceErrorCodeSerialization     = 1000;
const NSInteger kRFWebServiceErrorCodeCancel            = 1001;

// Private
static NSString * const kRFWSDescManualCancel = @"The request has been cancelled.";
static NSString * const kRFWSDescDeserializationError = @"Error during the deserialization.";


@implementation NSError (RFWebService)

+ (NSError *)RFWS_deserializationErrorWithData:(NSData *)data {
    return [NSError errorWithDomain:kRFWebServiceErrorDomain code:kRFWebServiceErrorCodeSerialization userInfo:@{NSLocalizedDescriptionKey : kRFWSDescDeserializationError, kRFWebServiceRecievedDataKey : data}];
}

+ (NSError *)RFWS_cancelError {
    return [NSError errorWithDomain:kRFWebServiceErrorDomain code:kRFWebServiceErrorCodeCancel userInfo:@{NSLocalizedDescriptionKey : kRFWSDescManualCancel}];
}

+ (NSError *)RFWS_cancelErrorWithReason:(id)reason {
    NSError *error;
    if (reason) {
        error = [NSError errorWithDomain:kRFWebServiceErrorDomain code:kRFWebServiceErrorCodeCancel userInfo:@{NSLocalizedDescriptionKey : kRFWSDescManualCancel, kRFWebServiceCancellationReason: reason}];
    } else {
        error = [self RFWS_cancelError];
    }
    
    return error;
}

@end
