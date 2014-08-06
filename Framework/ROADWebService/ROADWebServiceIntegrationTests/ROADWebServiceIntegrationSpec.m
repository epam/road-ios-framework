//
//  ROADWebServiceIntegrationSpec.m
//  ROADWebServiceIntegrationTest
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

#import <Kiwi.h>

#import "RFConcreteWebServiceClient.h"

#import "RFConcreteWebServiceClient.h"
#import "RFWebServiceClient+DynamicTest.h"
#import "RFWebServiceCachingManager.h"
#import "RFBasicAuthenticationProvider.h"

@interface RFServiceProvider (RFWebServiceSpec)
+(RFWebServiceCachingManager*)webServiceCacheManager;
@end

@implementation RFServiceProvider (RFWebServiceSpec)
+ (RFWebServiceCachingManager *)webServiceCacheManager {
    static dispatch_once_t predicate;
    static RFWebServiceCachingManager *sharedWebServiceCacheManager;
    dispatch_once(&predicate, ^{
        sharedWebServiceCacheManager = [[RFWebServiceCachingManager alloc] init];
    });
    return sharedWebServiceCacheManager;
}
@end

SPEC_BEGIN(ROADWebServiceIntegrationSpec)

describe(@"Web Service Integration", ^{
    __block id responseResult;
    __block NSError *responseError;

    beforeEach(^{
        responseError = nil;
        responseResult = nil;
    });

    context(@"Authentication Web Service", ^{
        __block RFWebServiceClient *dynamicWebServiceClient;

        __block NSString *testServiceHost = @"httpbin.org";
        __block NSString *testUser = @"user";
        __block NSString *testPass = @"passwd";
        __block NSString *testService;
        __block RFAuthenticationProvider *testAuthenticationProvider;

        __block NSString *(^testServiceRoot)(NSString*) =
        ^(NSString *protocol){
            NSString *serviceRoot = [NSString stringWithFormat:@"%@://%@",
                                    protocol,
                                    testServiceHost];
            return serviceRoot;
        };

        __block NSString *(^testRequestPath)(void) =
        ^(void){
            NSString *requestPath = [NSString stringWithFormat:@"%@/%@/%@",
                                    testService,
                                    testUser,
                                    testPass];
            return requestPath;
        };

        __block void(^runAuthenticationRequest)(void) =
        ^(void){
            __block BOOL isFinished = NO;

            dynamicWebServiceClient.authenticationProvider = testAuthenticationProvider;
            [dynamicWebServiceClient dynamicTestHttpRequestPath:testRequestPath() success:^(id result) {
                isFinished = YES; /* reveived data ... */
            } failure:^(NSError *error) {
                isFinished = YES;
            }];

            while (!isFinished) {
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
            }
        };

        context(@"Dynamic Web Service Client", ^{
            beforeAll(^{
                dynamicWebServiceClient = [[RFWebServiceClient alloc] initWithServiceRoot:testServiceRoot(@"http")];
            });

            it(@"should exist and be of a proper type", ^{
                [[dynamicWebServiceClient shouldNot] beNil];
                [[dynamicWebServiceClient should] beKindOfClass:[RFWebServiceClient class]];
            });

            it(@"should have proper Service Root", ^{
                [dynamicWebServiceClient.serviceRoot isEqualToString:testServiceRoot(@"http")];
            });
            
        });

        context(@"HTTPBasicAuthentication", ^{
            beforeAll(^{
                testService = @"basic-auth";
                testAuthenticationProvider = [[RFBasicAuthenticationProvider alloc] initWithUser:testUser password:testPass];
            });

            context(@"with plane HTTP", ^{
                beforeAll(^{
                    dynamicWebServiceClient = [[RFWebServiceClient alloc] initWithServiceRoot:testServiceRoot(@"http")];
                });

                it(@"should succeed and session should be opened", ^{
                    runAuthenticationRequest();

                    [[theValue([dynamicWebServiceClient.authenticationProvider isSessionOpened]) should] equal:theValue(YES)];
                });
            });

            context(@"with SSL (HTTPS)", ^{
                beforeAll(^{
                    dynamicWebServiceClient = [[RFWebServiceClient alloc] initWithServiceRoot:testServiceRoot(@"https")];
                });

                it(@"should succeed and session should be opened", ^{
                    runAuthenticationRequest();

                    [[theValue([dynamicWebServiceClient.authenticationProvider isSessionOpened]) should] equal:theValue(YES)];
                });
            });
        });
    });
});

SPEC_END
