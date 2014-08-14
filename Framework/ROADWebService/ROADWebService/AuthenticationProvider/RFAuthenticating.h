//
//  RFAuthenticating.h
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


@class RFWebServiceClient;
@protocol RFWebServiceCancellable;


typedef void (^RFAuthenticationSuccessBlock)(id result);
typedef void (^RFAuthenticationFailureBlock)(NSError *error);


@protocol RFAuthenticating <NSObject>

/**
 * Web service client related to this provider
 */
@property (nonatomic, weak) RFWebServiceClient *webServiceClient;

/**
 * Blocks, that will be invoked after confirmation of success authentication
 */
@property (nonatomic, strong) NSMutableSet *successBlocks;
/**
 * Blocks, that will be invoked after failing of authentication
 */
@property (nonatomic, strong) NSMutableSet *failureBlocks;

/**
 * Methods have to be implemented to open session, add authorization headers or any other operation, that will result in preliminary authentication (and following requests will be authenticated) or finishing preparations for processAuthenticationChallenge:forConnection: method (and late requests can handle authentication without additional requests/calculations).
 */
- (id<RFWebServiceCancellable>)authenticate;
/**
 * Methods have to be implemented to open session, add authorization headers or any other operation, that will result in preliminary authentication (and following requests will be authenticated) or finishing preparations for processAuthenticationChallenge:forConnection: method (and late requests can handle authentication without additional requests/calculations).
 * @param successBlock The block will be executed in case of successfully of authentication process
 * @param failureBlock The block will be executed in case of failure of authentication process
 */
- (id<RFWebServiceCancellable>)authenticateWithSuccessBlock:(void(^)(id result))successBlock failureBlock:(void(^)(NSError *error))failureBlock;

/**
 * Method intended to invalidate current open session. If there is no open sessions now, method does nothing
 */
- (id<RFWebServiceCancellable>)invalidate;

@optional
/**
 * Method checks whether session is opened already or not.
 */
- (BOOL)isSessionOpened;

/**
 * Method checks response status for related to authentication things (for instance, 401 status code)
 * @param response The response that was received from service after authenctication challenge was arised
 * @param connection The connection where authenctication challenge was arised
 */
- (void)checkResponse:(NSURLResponse *)response forConnection:(NSURLConnection *)connection;

/**
 * Method for internal usage by web service client. It will be invoked when authentication challenge arise
 * @param challenge The challenge that was arised and need to be resolved in this method
 * @param connection The connection where authenctication challenge was arised
 */
- (void)processAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge forConnection:(NSURLConnection *)connection;

/**
 * Method adds to request data that will allow it to pass authentication
 * @param request The request that will be sent to service
 */
- (void)addAuthenticationDataToRequest:(NSMutableURLRequest *)request;

@end
