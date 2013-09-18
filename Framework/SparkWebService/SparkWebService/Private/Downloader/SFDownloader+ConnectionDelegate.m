//
//  SFDownloader+ConnectionDelegate.m
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


#import "SFDownloader+ConnectionDelegate.h"
#import <Spark/SparkLogger.h>
#import "NSError+SFSparkWebService.h"

#import "SFAuthenticating.h"
#import "SFWebServiceClient.h"
#import "SFWebServiceErrorHandler.h"
#import "SFWebServiceErrorHandling.h"

@interface SFDownloader ()

@property (strong, nonatomic) NSError *downloadError;
@property (strong, nonatomic) NSMutableData *data;
@property (strong, nonatomic) NSHTTPURLResponse *response;
@property (assign, nonatomic) NSUInteger expectedContentLenght;

- (void)stop;

@end

@implementation SFDownloader (ConnectionDelegate)

#pragma mark - NSURLConnection delegates

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    self.downloadError = error;
    [self stop];
    SFLogTypedWarning(self.loggerType, @"URL connection(%p) has failed. URL: %@", connection, [connection.currentRequest.URL absoluteString]);
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    SFLogTypedWarning(self.loggerType, @"URL connection(%p) has received authentication method:%@. URL: %@", connection, challenge.protectionSpace.authenticationMethod, [connection.currentRequest.URL absoluteString]);
    SFLogTypedInfo(self.loggerType, @"URL connection(%p) has passed authentication challenge to authentication provider %@", connection, self.authenticationProvider);

    if (self.authenticationProvider) {
        
        if ([self.authenticationProvider respondsToSelector:@selector(processAuthenticationChallenge:forConnection:)]) {
            [self.authenticationProvider processAuthenticationChallenge:challenge forConnection:connection];
        }
    } else {
        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
}

#pragma mark - NSURLConnection data delegates

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    SFLogTypedDebug(self.loggerType, @"URL connection(%p) has finished. URL: %@. Data was received: %@", aConnection, [aConnection.currentRequest.URL absoluteString], [[NSString alloc] initWithData:self.data encoding:NSUTF8StringEncoding]);
    
    // Checking response with error handler
    SFWebServiceErrorHandler *errorHandlerAttribute = [[self.webServiceClient class] SF_attributeForClassWithAttributeType:[SFWebServiceErrorHandler class]];
    if (!errorHandlerAttribute) {
        errorHandlerAttribute = [[self.webServiceClient class] SF_attributeForMethod:self.methodName withAttributeType:[SFWebServiceErrorHandler class]];
    }
    
    if (errorHandlerAttribute.handlerClass.length) {
        Class errorHandler = NSClassFromString(errorHandlerAttribute.handlerClass);
        NSAssert(errorHandler, @"Error handler class (%@) is not exist in app", errorHandlerAttribute.handlerClass);
        
        if ([errorHandler conformsToProtocol:@protocol(SFWebServiceErrorHandling)]) {
            self.downloadError = [errorHandler validateResponse:self.response withData:self.data];
        }
    }
    else {
        if ([self.response isKindOfClass:[NSHTTPURLResponse class]]) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)self.response;
            if (![self isOkStatusCode:[response statusCode]]) {
                self.downloadError = [[NSError alloc] initWithDomain:NSURLErrorDomain code:[response statusCode] userInfo:nil];
            }
        }
        
    }
    
    [self stop];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)aData {
    [self.data appendData:aData];
    SFLogTypedInfo(self.loggerType, @"URL connection(%p) to URL: %@ received data: %@", connection, [connection.currentRequest.URL absoluteString], [NSString stringWithUTF8String:[self.data bytes]]);
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)aResponse {
    if ([self.authenticationProvider respondsToSelector:@selector(checkResponse:forConnection:)]) {
        [self.authenticationProvider checkResponse:aResponse forConnection:connection];
    }

    self.response = (NSHTTPURLResponse *)aResponse;
    self.expectedContentLenght = [self.response expectedContentLength];
    
    if ([aResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)aResponse;
        SFLogTypedWarning(self.loggerType, @"URL connection(%p) to URL: %@ received response(%p) with status code: %d\nResponse headers: %@", connection, [connection.currentRequest.URL absoluteString], aResponse, [response statusCode], [response allHeaderFields]);
    }
    else {
        SFLogTypedDebug(self.loggerType, @"URL connection(%p) to URL: %@ received response(%p)", connection, [connection.currentRequest.URL absoluteString], aResponse);
    }
    
    [self.data setLength:0]; // discarding previous downloads in case a redirect or mulitpart has sent a new response
}


- (BOOL)isOkStatusCode:(NSUInteger)statusCode {
    __block BOOL result = NO;
    [self.successCodes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]]) {
            result = statusCode == [obj unsignedIntegerValue];
        } else if ([obj isKindOfClass:[NSValue class]]) {
            NSRange range = [obj rangeValue];
            result = (range.location <= statusCode) && (range.location + range.length) > statusCode;
        } else {
            SFLogWarning(@"SFDownloader: Incorrect statusCode type: %@", NSStringFromClass([obj class]));
        }
        *stop = result;
    }];
    return result;
}

@end
