//
//  SFConcreteWebServiceClient.h
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "SFWebServiceClient.h"
#import "SFWebServiceErrorHandler.h"
#import "SFWebServiceHeader.h"
#import "SFWebServiceCall.h"
#import "SFWebServiceURLBuilder.h"
#import "SFODataWebServiceURLBuilder.h"
#import "SFFormData.h"
#import "SFMultipartData.h"

@class SFODataFetchRequest;
@protocol SFWebServiceCancellable;

@interface SFConcreteWebServiceClient : SFWebServiceClient

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = NO, relativePath = @"%%0%%")
SF_ATTRIBUTE(SFWebServiceHeader, hearderFields = @{@"Accept" : @"application/json"})
SF_ATTRIBUTE(SFWebServiceErrorHandler, handlerClass = @"SFODataErrorHandler")
- (id<SFWebServiceCancellable>)testErrorHandlerRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall)
SF_ATTRIBUTE(SFWebServiceHeader, hearderFields = @{@"Accept": @"application/json"})
SF_ATTRIBUTE(SFWebServiceURLBuilder, builderClass = [SFODataWebServiceURLBuilder class])
- (id<SFWebServiceCancellable>)loadDataWithFetchRequest:(SFODataFetchRequest *)fetchRequest success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = NO, relativePath = @"?importantParameter=%%1%%")
SF_ATTRIBUTE(SFWebServiceURLBuilder, builderClass = [SFODataWebServiceURLBuilder class])
SF_ATTRIBUTE(SFWebServiceHeader, hearderFields = @{@"Accept" : @"application/json"})
- (id<SFWebServiceCancellable>)loadDataWithFetchRequest:(SFODataFetchRequest *)fetchRequest someImportantParameter:(NSString *)importantParameter success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])
- (id<SFWebServiceCancellable>)testSerializationRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon.localizedMessage.locale", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])
- (id<SFWebServiceCancellable>)testWrongSerializationRootWithSuccess:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = YES)
SF_ATTRIBUTE(SFMultipartData, boundary = @"sdfsfsf")
- (id<SFWebServiceCancellable>)testMultipartDataWithAttachment:(SFFormData *)attachment success:(id)successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = YES)
- (id<SFWebServiceCancellable>)testMultipartDataWithAttachments:(NSArray *)attachments success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = YES)
- (id<SFWebServiceCancellable>)testMethodWithoutBlocks;

@end
