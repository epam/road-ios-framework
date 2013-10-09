//
//  EDSDownloader.h
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

#import "SFWebServiceCancellable.h"

@protocol SFAuthenticating;
@class SFWebServiceClient;

@interface SFDownloader : NSObject <SFWebServiceCancellable, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (strong, nonatomic) NSString *loggerType;
@property (readonly, nonatomic, readonly) NSMutableArray *successCodes;
@property (strong, nonatomic) id<SFAuthenticating> authenticationProvider;
@property (strong, nonatomic, readonly) NSMutableURLRequest *request;

/**
 * The flag that specify if current request is multipart form data request.
 */
@property (assign, nonatomic, getter = isMultipartData) BOOL multipartData;

@property (nonatomic, strong, readonly) SFWebServiceClient *webServiceClient;
@property (nonatomic, strong, readonly) NSString *methodName;
/**
 The serialized data from the request,
 */
@property (strong, nonatomic) id serializedData;
/**
 The response success block.
 */
@property (copy, nonatomic) void (^successBlock)(id result);
/**
 The response failure block.
 */
@property (copy, nonatomic) void (^failureBlock)(id error);
/**
 Indicates that the request has been cancelled.
 */
@property (atomic, assign, readonly, getter = isRequestCancelled) BOOL requestCancelled;

- (id)initWithClient:(SFWebServiceClient *)webServiceClient methodName:(NSString *)methodName authenticationProvider:(id<SFAuthenticating>)authenticaitonProvider;

- (void)configureRequestForUrl:(NSURL * const)anUrl body:(NSData * const)httpBody sharedHeaders:(NSDictionary *)sharedHeaders values:(NSDictionary *)values;

- (void)start;

- (void)cancel;

@end
