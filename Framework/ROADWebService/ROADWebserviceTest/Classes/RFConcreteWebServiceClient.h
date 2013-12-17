//
//  RFConcreteWebServiceClient.h
//  ROADWebService
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "RFWebServiceClient.h"
#import "RFWebServiceErrorHandler.h"
#import "RFWebServiceHeader.h"
#import "RFWebServiceCall.h"
#import "RFWebServiceURLBuilder.h"
#import "RFODataWebServiceURLBuilder.h"
#import "RFFormData.h"
#import "RFMultipartData.h"

@class RFODataFetchRequest;
@protocol RFWebServiceCancellable;

@interface RFConcreteWebServiceClient : RFWebServiceClient

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, relativePath = @"%%0%%")
RF_ATTRIBUTE(RFWebServiceHeader, headerFields = @{@"Accept" : @"application/json"})
RF_ATTRIBUTE(RFWebServiceErrorHandler, handlerClass = @"RFODataErrorHandler")
- (id<RFWebServiceCancellable>)testErrorHandlerRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall)
RF_ATTRIBUTE(RFWebServiceHeader, headerFields = @{@"Accept": @"application/json"})
RF_ATTRIBUTE(RFWebServiceURLBuilder, builderClass = [RFODataWebServiceURLBuilder class])
- (id<RFWebServiceCancellable>)loadDataWithFetchRequest:(RFODataFetchRequest *)fetchRequest success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, relativePath = @"?importantParameter=%%1%%")
RF_ATTRIBUTE(RFWebServiceURLBuilder, builderClass = [RFODataWebServiceURLBuilder class])
RF_ATTRIBUTE(RFWebServiceHeader, headerFields = @{@"Accept" : @"application/json"})
- (id<RFWebServiceCancellable>)loadDataWithFetchRequest:(RFODataFetchRequest *)fetchRequest someImportantParameter:(NSString *)importantParameter success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])
- (id<RFWebServiceCancellable>)testSerializationRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon.localizedMessage.locale", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])
- (id<RFWebServiceCancellable>)testWrongSerializationRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES, method = @"POST")
RF_ATTRIBUTE(RFMultipartData, boundary = @"sdfsfsf")
- (id<RFWebServiceCancellable>)testMultipartDataWithAttachment:(RFFormData *)attachment success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES, method = @"POST")
- (id<RFWebServiceCancellable>)testMultipartDataWithAttachments:(NSArray *)attachments success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES)
- (id<RFWebServiceCancellable>)testMethodWithoutBlocks;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES)
- (id<RFWebServiceCancellable>)testPragmaNoCacheWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES)
- (id<RFWebServiceCancellable>)testCacheControlNoCacheWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES)
- (id<RFWebServiceCancellable>)testNoCacheHeadersWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
