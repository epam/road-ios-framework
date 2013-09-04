//
//  SFDownloader.m
//  SparkWebservice
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


#import "SFDownloader.h"
#import "SFLooper.h"
#import <Spark/SparkLogger.h>
#import "NSError+SparkWebService.h"

#import "SFWebServiceCall.h"
#import "SFWebServiceHeader.h"
#import "SFWebServiceClientStatusCodes.h"
#import "SFAuthenticating.h"
#import "SFWebServiceSerializationHandler.h"
#import "SFWebServiceClient.h"
#import "SFWebServiceLogger.h"
#import <Spark/SparkCore.h>

@interface SFDownloader () {
    NSURLConnection * _connection;
    SFLooper * _looper;
    NSMutableArray * _successCodes;
}

@property (strong, nonatomic) NSError *downloadError;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (assign, nonatomic) NSUInteger expectedContentLenght;
@property (strong, nonatomic) SFWebServiceCall * callAttribute;

- (void)stop;

@end

@implementation SFDownloader

- (id)initWithClient:(SFWebServiceClient *)webServiceClient methodName:(NSString *)methodName authenticationProvider:(id<SFAuthenticating>)authenticaitonProvider {
    self = [super init];
    
    if (self) {
        _webServiceClient = webServiceClient;
        _methodName = methodName;
        _authenticationProvider = authenticaitonProvider;
        _successCodes = [NSMutableArray arrayWithObjects:[NSValue valueWithRange:NSMakeRange(200, 100)], nil];
        SFWebServiceLogger *loggerTypeAttribute = [[webServiceClient class] lastAttributeForMethod:_methodName withAttributeType:[SFWebServiceLogger class]];
        if (!loggerTypeAttribute) {
            loggerTypeAttribute = [[self class] lastAttributeForClassWithAttributeType:[SFWebServiceLogger class]];
        }
        _loggerType = loggerTypeAttribute.loggerType;
        _callAttribute = [[_webServiceClient class] lastAttributeForMethod:_methodName withAttributeType:[SFWebServiceCall class]];
    }
    
    return self;
}

- (NSMutableArray*)successCodes {
    return _successCodes;
}

- (void)configureRequestForUrl:(NSURL * const)anUrl body:(NSData * const)httpBody sharedHeaders:(NSDictionary *)sharedHeaders values:(NSDictionary *)values {
    _request = [self requestForUrl:anUrl withMethod:_callAttribute.method withBody:httpBody];
    
    SFWebServiceHeader * const headerAttribute = [[_webServiceClient class] lastAttributeForMethod:_methodName withAttributeType:[SFWebServiceHeader class]];
    
    // Adding shared headers to request
    NSMutableDictionary *headerFields = [sharedHeaders mutableCopy];
    // Adding headers from attributes
    [headerFields addEntriesFromDictionary:[self dynamicPropertyValuesFromAttribute:headerAttribute WithPropertyValues:values]];
    [_request setAllHTTPHeaderFields:headerFields];

    if ([self.authenticationProvider respondsToSelector:@selector(addAuthenticationDataToRequest:)]) {
        [self.authenticationProvider addAuthenticationDataToRequest:_request];
    }

    if (_callAttribute.overrideGlobalSuccessCodes) {
        [self.successCodes removeAllObjects];
        [self.successCodes addObjectsFromArray:_callAttribute.successCodes];
    } else {
        SFWebServiceClientStatusCodes* wsca = [[self class] lastAttributeForClassWithAttributeType:[SFWebServiceClientStatusCodes class]];
        if ([wsca.successCodes count] > 0) {
            [self.successCodes removeAllObjects];
            [self.successCodes addObjectsFromArray:wsca.successCodes];
        }
        [self.successCodes addObjectsFromArray:_callAttribute.successCodes];
    }
}

- (void)start {
    if (_requestCancelled) {
        return;
    }
    
    _connection = [[NSURLConnection alloc] initWithRequest:_request delegate:self startImmediately:NO];
    
    if (_looper == nil) {
        _looper = [[SFLooper alloc] init];
        _data = [NSMutableData data];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [_connection start];
        SFLogTypedDebug(self.loggerType, @"URL connection(%p) has started. Method: %@. URL: %@\nHeader fields: %@", _connection, _connection.currentRequest.HTTPMethod, [_connection.currentRequest.URL absoluteString], [_connection.currentRequest allHTTPHeaderFields]);
        [_looper start];
    }
}

- (void)downloaderFinishedWithResult:(NSData *)result response:(NSHTTPURLResponse *)response error:(NSError *)error {
    __block id resultData = result;
    __block NSError *resultError = error;
    self.response = response;
    
    if (!resultError && !_callAttribute.serializationDisabled) {
        [SFWebServiceSerializationHandler deserializeData:result withSerializator:_webServiceClient.serializationDelegate serializatinRoot:_callAttribute.serializationRoot toDeserializationClass:NSClassFromString(_callAttribute.prototypeClass) withCompletitionBlock:^(id serializedData, NSError *error) {
            resultData = serializedData;
            resultError = error;
        }];
    }
    
    self.downloadError = resultError;
    if (!self.downloadError) {
        self.serializedData = resultData;
        [self performSelector:@selector(performSuccessBlockOnSpecificThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
    else {
        [self performSelector:@selector(performFailureBlockOnSpecificThread) onThread:[NSThread mainThread] withObject:nil waitUntilDone:YES];
    }
    
}

- (void)stop {
    _connection = nil;
    [self fillErrorUserInfoAndCleanData];
    [self downloaderFinishedWithResult:_data response:_response error:_downloadError];
    [_looper stop];
    _looper = nil;
    
}

- (NSUInteger)receivedData {
    return [_data length];
}

- (NSUInteger)expectedContentLenght {
    return _expectedContentLenght;
}

- (void)cancel {
    _requestCancelled = YES;
    [_connection cancel];
     SFLogTypedDebug(self.loggerType, @"URL connection(%p) is canceled. URL: %@", _connection, [_connection.currentRequest.URL absoluteString]);
    self.data = nil;
    self.downloadError = [NSError sparkWS_cancellError];
    [self stop];
   
}

- (NSMutableURLRequest *)requestForUrl:(NSURL * const)anUrl withMethod:(NSString * const)method withBody:(NSData * const)httpBody {
    NSMutableURLRequest * const request = [NSMutableURLRequest requestWithURL:anUrl];
    request.HTTPMethod = method;
    request.HTTPBody = httpBody;
    return request;
}

- (void)fillErrorUserInfoAndCleanData {
    if (self.downloadError && self.data) {
        NSMutableDictionary* userInfo = self.downloadError.userInfo == nil ? [NSMutableDictionary new] : [self.downloadError.userInfo mutableCopy];
        NSString* result = [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding];
        [userInfo setObject: result ? result : self.data forKey:@"result"];
        self.downloadError = [[NSError alloc] initWithDomain:self.downloadError.domain code:self.downloadError.code userInfo:userInfo];
        self.data = nil;
    }
}

#pragma mark - Request logic

-(void)performSuccessBlockOnSpecificThread {
    self.successBlock(_serializedData);
}

-(void)performFailureBlockOnSpecificThread {
    self.failureBlock(_downloadError);
}

#pragma mark - Utitlity

NSString * const SFAttributeTemplateEscape = @"%%";

- (NSMutableDictionary*)dynamicPropertyValuesFromAttribute:(SFWebServiceHeader *)serviceHeaderAttribute WithPropertyValues:(NSDictionary*)values {
    NSMutableDictionary* result = [NSMutableDictionary new];
    [serviceHeaderAttribute.hearderFields enumerateKeysAndObjectsUsingBlock:^(id key, NSString* obj, BOOL *stop) {
        NSMutableString* value = [obj mutableCopy];
        [value formatStringUsingValues:values withEscape:SFAttributeTemplateEscape];
        result[key] = [value copy];
    }];
    return result;
}

@end
