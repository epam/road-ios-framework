//
//  RFDownloader.m
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


#import "RFDownloader.h"
#import <ROAD/ROADCore.h>

#import "RFWebServiceLog.h"
#import "RFLooper.h"
#import "NSError+RFWebService.h"
#import "RFWebServiceCall.h"
#import "RFWebServiceHeader.h"
#import "RFWebServiceClientStatusCodes.h"
#import "RFAuthenticating.h"
#import "RFWebServiceSerializationHandler.h"
#import "RFWebServiceClient.h"
#import "RFMultipartData.h"
#import "RFWebServiceCallParameterEncoder.h"
#import "RFWebServiceSerializer.h"
#import "RFServiceProvider+WebServiceCachingManager.h"
#import "RFWebResponse+HTTPResponse.h"
#import "RFWebServiceCache.h"

@interface RFDownloader () {
    NSURLConnection * _connection;
    RFLooper * _looper;
    NSMutableArray * _successCodes;
}

@property (strong, nonatomic) NSError *downloadError;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (assign, nonatomic) long long expectedContentLenght;
@property (strong, nonatomic) RFWebServiceCall * callAttribute;
@property (strong, nonatomic) NSDictionary * values;
@property (assign, atomic, readwrite, getter = isRequestCancelled) BOOL requestCancelled;

- (void)stop;

@end

@implementation RFDownloader

- (id)initWithClient:(RFWebServiceClient *)webServiceClient methodName:(NSString *)methodName authenticationProvider:(id<RFAuthenticating>)authenticaitonProvider {
    self = [super init];
    
    if (self) {
        _webServiceClient = webServiceClient;
        _methodName = methodName;
        _authenticationProvider = authenticaitonProvider;
        _successCodes = [NSMutableArray arrayWithObjects:[NSValue valueWithRange:NSMakeRange(200, 100)], nil];
        _callAttribute = [[_webServiceClient class] RF_attributeForMethod:_methodName withAttributeType:[RFWebServiceCall class]];
    }
    
    return self;
}

- (NSMutableArray*)successCodes {
    return _successCodes;
}

- (void)configureRequestForUrl:(NSURL * const)anUrl body:(NSData * const)httpBody sharedHeaders:(NSDictionary *)sharedHeaders values:(NSDictionary *)values {
    _request = [self requestForUrl:anUrl withMethod:_callAttribute.method withBody:httpBody values:values];

    // Saving the values for the cache identifier parsing.
    self.values = [values copy];

    // For multipart form data we have to add specific header
    if (_multipartData) {
        NSString *boundary;
        RFMultipartData *multipartDataAttribute = [[_webServiceClient class] RF_attributeForMethod:_methodName withAttributeType:[RFMultipartData class]];
        boundary = multipartDataAttribute.boundary;
        if (!boundary.length) {
            // Some random default boundary
            boundary = @"AaB03x"; //kRFBoundaryDefaultString; // Bug of Travis: const string contain nil
            RFWSLogVerbose(@"WebService: Boundary is not specified, using default one");
        }
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [_request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    }
    
    RFWebServiceHeader * const headerAttribute = [[_webServiceClient class] RF_attributeForMethod:_methodName withAttributeType:[RFWebServiceHeader class]];
    
    // Adding shared headers to request
    NSMutableDictionary *headerFields = [sharedHeaders mutableCopy];
    // Adding headers from attributes
    [headerFields addEntriesFromDictionary:[self dynamicPropertyValuesFromAttribute:headerAttribute withPropertyValues:values]];
    [_request setAllHTTPHeaderFields:headerFields];

    if ([self.authenticationProvider respondsToSelector:@selector(addAuthenticationDataToRequest:)]) {
        [self.authenticationProvider addAuthenticationDataToRequest:_request];
    }

    if (_callAttribute.overrideGlobalSuccessCodes
        && _callAttribute.successCodes) {
        [self.successCodes removeAllObjects];
        [self.successCodes addObjectsFromArray:_callAttribute.successCodes];
    } else {
        RFWebServiceClientStatusCodes* wsca = [[self.webServiceClient class] RF_attributeForClassWithAttributeType:[RFWebServiceClientStatusCodes class]];

        if ([wsca.successCodes count] > 0) {
            [self.successCodes removeAllObjects];
            [self.successCodes addObjectsFromArray:wsca.successCodes];
        }
        [self.successCodes addObjectsFromArray:_callAttribute.successCodes];
    }
}

- (void)checkCacheAndStart {
    if (self.requestCancelled) {
        return;
    }
    
    RFWebServiceCache *cacheAttribute = [[_webServiceClient class] RF_attributeForMethod:_methodName withAttributeType:[RFWebServiceCache class]];
    id<RFWebServiceCachingManaging> cacheManager = [RFServiceProvider webServiceCacheManager];
    RFWebResponse *cachedResponse;
    if (!cacheAttribute.cacheDisabled) {
        cachedResponse = [cacheManager cacheWithRequest:_request];
    }
    
    if (cachedResponse) {
        [self downloaderFinishedWithResult:cachedResponse.responseBodyData response:[cachedResponse unarchivedResponse] error:nil];
    }
    else {
        [self start];
    }
}

- (void)start {
    if (self.requestCancelled) {
        return;
    }

    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    
    if (_looper == nil) {
        _looper = [[RFLooper alloc] init];
        _data = [NSMutableData data];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_connection start];
        RFWSLogInfo(@"URL connection(%p) has started. Method: %@. URL: %@\nHeader fields: %@", _connection, _connection.currentRequest.HTTPMethod, [_connection.currentRequest.URL absoluteString], [_connection.currentRequest allHTTPHeaderFields]);
        [_looper start];
    }
}

- (void)cacheAndFinishWithResult:(NSData *)result response:(NSHTTPURLResponse *)response error:(NSError *)error {
    // Check 304 status code in case we have
    if (!error) {
        if ([self checkCacheWithResponse:response]) {
            result = self.data;
            response = self.response;
        }
        else {
            RFWebServiceCache *cacheAttribute = [[_webServiceClient class] RF_attributeForMethod:_methodName withAttributeType:[RFWebServiceCache class]];
            if (!cacheAttribute.cacheDisabled) {
                NSDate *expirationDate;
                if (cacheAttribute.maxAge) {
                    expirationDate = [NSDate dateWithTimeIntervalSinceNow:cacheAttribute.maxAge];
                }
                // checking for the cache identifier and parsing
                NSString *cacheIdentifier = [[RFServiceProvider webServiceCacheManager] parseCacheIdentifier:cacheAttribute.cacheIdentifier withParameters:self.values];

                id<RFWebServiceCachingManaging> cacheManager = [RFServiceProvider webServiceCacheManager];
                [cacheManager setCacheWithRequest:_request response:response responseBodyData:result expirationDate:expirationDate cacheIdentifier:cacheIdentifier];
            }
        }
    }
    
    [self downloaderFinishedWithResult:result response:response error:error];
}

- (void)downloaderFinishedWithResult:(NSData *)result response:(NSHTTPURLResponse *)response error:(NSError *)downloaderError {
    __block id resultData = result;
    __block NSError *resultError = downloaderError;
    self.response = response;
    
    if (!resultError && !_callAttribute.serializationDisabled) {
        [RFWebServiceSerializationHandler deserializeData:result withSerializator:[self serializationDelegate] serializatinRoot:_callAttribute.serializationRoot toDeserializationClass:_callAttribute.prototypeClass withCompletitionBlock:^(id serializedData, NSError *error) {
            resultData = serializedData;
            resultError = error;
        }];
    }
    
    // Perform callback block
    self.downloadError = resultError;
    if (!self.downloadError) {
        self.serializedData = resultData;
        [self performSelector:@selector(performSuccessBlockOnSpecificThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
    else {
        [self performSelector:@selector(performFailureBlockOnSpecificThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
}

- (id<RFSerializationDelegate>)serializationDelegate {
    RFWebServiceSerializer *serializerAttribute = [[self.webServiceClient class] RF_attributeForMethod:self.methodName withAttributeType:[RFWebServiceSerializer class]];
    id<RFSerializationDelegate> serializationDelegate;
    if (serializerAttribute.serializerClass) {
        serializationDelegate = [[serializerAttribute.serializerClass alloc] init];
    }
    else {
        serializationDelegate = self.webServiceClient.serializationDelegate;
    }
    
    return serializationDelegate;
}

- (void)stop {
    _connection = nil;
    if (!self.requestCancelled) { // If request is cancelled already, simply release variables
        [self fillErrorUserInfoAndCleanData];
        [self cacheAndFinishWithResult:_data response:_response error:_downloadError];
    }
    [_looper stop];
    _looper = nil;
    
}

- (NSUInteger)receivedData {
    return [_data length];
}

- (long long)expectedContentLenght {
    return _expectedContentLenght;
}

- (NSMutableURLRequest *)requestForUrl:(NSURL * const)anUrl withMethod:(NSString * const)method withBody:(NSData *)httpBody values:(NSDictionary *)values {
    NSData *body = httpBody;
    
    if ([_callAttribute.method isEqualToString:@"POST"]) {
        if (_callAttribute.postParameter != (int)NSNotFound && !httpBody.length) {
            id bodyObject = values[[NSString stringWithFormat:@"%d", _callAttribute.postParameter]];
            body = [self dataFromParameter:bodyObject];
        }
        else {
            if (!body.length) {
                id firstParameter = values[@"0"];
                if (firstParameter) { // Checking first parameter of web service call method
                    body = [self dataFromParameter:firstParameter];
                }
            }
            else if (_callAttribute.postParameter != (int)NSNotFound) {
                RFWSLogWarn(@"Web service method %@ specifies postParameter, but has NSData or RFFormData variable in parameters and use it instead", method);
            }
        }
    }
    
    
    NSMutableURLRequest * const request = [NSMutableURLRequest requestWithURL:anUrl];
    request.HTTPMethod = method;
    request.HTTPBody = body;
    return request;
}

- (void)fillErrorUserInfoAndCleanData {
    if (self.downloadError && self.data) {
        NSMutableDictionary* userInfo = self.downloadError.userInfo == nil ? [NSMutableDictionary new] : [self.downloadError.userInfo mutableCopy];
        NSString* result = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        userInfo[@"result"] = result ? result : self.data;
        self.downloadError = [[NSError alloc] initWithDomain:self.downloadError.domain code:self.downloadError.code userInfo:userInfo];
        self.data = nil;
    }
}

#pragma mark - Request logic

-(void)performSuccessBlockOnSpecificThread {
    if (self.successBlock) {
        self.successBlock(_serializedData);
    }
}

-(void)performFailureBlockOnSpecificThread {
    if (self.failureBlock) {
        self.failureBlock(_downloadError);
    }
}

#pragma mark - Utitlity

NSString * const RFAttributeTemplateEscape = @"%%";

- (NSMutableDictionary*)dynamicPropertyValuesFromAttribute:(RFWebServiceHeader *)serviceHeaderAttribute withPropertyValues:(NSDictionary*)values {
    NSMutableDictionary* result = [NSMutableDictionary new];
    [serviceHeaderAttribute.headerFields enumerateKeysAndObjectsUsingBlock:^(id key, NSString* obj, BOOL *stop) {
        NSMutableString* value = [obj mutableCopy];
        [value RF_formatStringUsingValues:values withEscape:RFAttributeTemplateEscape];
        result[key] = [value copy];
    }];
    return result;
}

- (NSData *)dataFromParameter:(id)parameter {
    NSData *data;
    
    if ([parameter isKindOfClass:[NSString class]]) {
        data = [parameter dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    return data;
}

- (BOOL)checkCacheWithResponse:(NSHTTPURLResponse *)response {
    RFWebResponse *cachedResponse = [[RFServiceProvider webServiceCacheManager] cacheForResponse:response request:self.request];
    if (cachedResponse) {
        self.data = [cachedResponse.responseBodyData mutableCopy];
        self.response = [cachedResponse unarchivedResponse];
    }
    
    return cachedResponse != nil;
}


#pragma mark - RFWebServiceCancellable

- (void)cancel {
    [self cancelWithReason:nil];
}

- (void)cancelWithReason:(id)reason {
    if (_connection) {
        [_connection cancel];
        RFWSLogInfo(@"URL connection(%p) is cancelled. URL: %@", _connection, [_connection.currentRequest.URL absoluteString]);
    }
    self.data = nil;
    self.downloadError = [NSError RFWS_cancelErrorWithReason:reason];
    [self stop];
    self.requestCancelled = YES;
}

@end
