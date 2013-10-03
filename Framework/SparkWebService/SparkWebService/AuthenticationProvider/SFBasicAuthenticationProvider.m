//
//  SFBasicAuthenticationProvider.m
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

#import "SFBasicAuthenticationProvider.h"
#import "NSError+SFSparkWebService.h"

@implementation SFBasicAuthenticationProvider


#pragma mark - Initialization

- (id)initWithUser:(NSString *)user password:(NSString *)password {
    self = [super init];
    if (self) {
        _user = user;
        _password = password;
    }
    return self;
}

#pragma mark - SFAuthenticating

- (void)authenticate {
    _credential = [[NSURLCredential alloc] initWithUser:_user password:_password persistence:NSURLCredentialPersistenceForSession];
}

- (void)processAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge forConnection:(NSURLConnection *)connection {
    [super processAuthenticationChallenge:challenge forConnection:connection];
    
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodDefault] || [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodHTTPBasic]) {
        if (!_credential) [self authenticate];
        [challenge.sender useCredential:_credential forAuthenticationChallenge:challenge];
    }
}

- (void)invalidate {
    
    if (_credential) {
        NSDictionary *credentials = [[NSURLCredentialStorage sharedCredentialStorage] allCredentials];
        
        if ([credentials count] > 0) {
            NSEnumerator *protectionSpaceEnumerator = [credentials keyEnumerator];
            id protectionSpace;
            while (protectionSpace = [protectionSpaceEnumerator nextObject]) {
                NSEnumerator *userEnumerator = [(credentials[protectionSpace]) keyEnumerator];
                id user;
                while (user = [userEnumerator nextObject]) {
                    NSURLCredential *credential = (credentials[protectionSpace])[user];
                    [[NSURLCredentialStorage sharedCredentialStorage] removeCredential:credential forProtectionSpace:protectionSpace];
                }
            }
        }
        _credential = nil;
        // Set flag - session is closed
        _sessionOpened = NO;
    }
}

- (void)checkResponse:(NSHTTPURLResponse *)response forConnection:(NSURLConnection *)connection {
    // Response did not get authentication challenge again
    // Set flag - session is opened
    if ([response statusCode] != kSFUnauthorizedCode && [response statusCode] != kSFProxyAuthenticationRequiredCode) {
        _sessionOpened = YES;
        [self callSuccessBlocksWithResult:response];
    }
    else {
        [self callFailureBlocksWithError:[NSError errorWithDomain:kSFWebServiceErrorDomain code:[response statusCode] userInfo:nil]];
    }
}

@end
