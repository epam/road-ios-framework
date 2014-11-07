//
//  RFConcreteWebServiceIntegrationClient.h
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


#import "RFFormData.h"
#import "RFMultipartData.h"
#import "RFODataErrorHandler.h"
#import "RFODataWebServiceURLBuilder.h"
#import "RFWebServiceCache.h"
#import "RFWebServiceCall.h"
#import "RFWebServiceClient.h"
#import "RFWebServiceErrorHandler.h"
#import "RFWebServiceHeader.h"
#import "RFWebServiceURLBuilder.h"

@class RFODataFetchRequest;
@protocol RFWebServiceCancellable;


@interface RFConcreteWebServiceIntegrationClient : RFWebServiceClient

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])
- (id<RFWebServiceCancellable>)testSerializationRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon.localizedMessage.locale", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])
- (id<RFWebServiceCancellable>)testWrongSerializationRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES)
RF_ATTRIBUTE(RFWebServiceURLBuilder, encoding = NSUTF8StringEncoding)
- (id<RFWebServiceCancellable>)testURLEscapingEncodingWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES)
RF_ATTRIBUTE(RFWebServiceURLBuilder, allowedCharset = [NSCharacterSet uppercaseLetterCharacterSet])
- (id<RFWebServiceCancellable>)testURLEscapingAllowedCharsetWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
