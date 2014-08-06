//
//  RFWebServiceSpec.m
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

#import <Kiwi.h>
#import <Nocilla.h>

#import "RFConcreteWebServiceClient.h"
#import "RFWebServiceClientWithRoot.h"
#import "RFWebServiceCachingManager.h"

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

SPEC_BEGIN(RFWebServiceSpec)

describe(@"Web Service", ^{

    beforeAll(^{
        [[LSNocilla sharedInstance] start];
    });

    afterAll(^{
        [[LSNocilla sharedInstance] stop];
    });

    afterEach(^{
        [[LSNocilla sharedInstance] clearStubs];
    });

    context(@"Web Service Client With Root", ^{
        __block RFWebServiceClientWithRoot *webServiceClientWithRoot;

        context(@"with Service Root Attribute", ^{
            beforeAll(^{
                webServiceClientWithRoot = [[RFWebServiceClientWithRoot alloc] init];
            });

            it(@"should exist and be of a proper type", ^{
                [[webServiceClientWithRoot shouldNot] beNil];
                [[webServiceClientWithRoot should] beKindOfClass:[RFWebServiceClientWithRoot class]];
            });

            context(@"Service root", ^{
                it(@"should be initialized by a correct value from an attribute", ^{
                    [[webServiceClientWithRoot.serviceRoot shouldNot] beEmpty];
                    [webServiceClientWithRoot.serviceRoot isEqualToString:@"http://google.com"];
                });
            });
        });

        context(@"init with Service Root", ^{
            __block NSString *yahooServer = @"http://yahoo.com";

            beforeAll(^{
                webServiceClientWithRoot = [[RFWebServiceClientWithRoot alloc] initWithServiceRoot:yahooServer];
            });

            it(@"should exist and be of a proper type", ^{
                [[webServiceClientWithRoot shouldNot] beNil];
                [[webServiceClientWithRoot should] beKindOfClass:[RFWebServiceClientWithRoot class]];
            });

            context(@"Service root", ^{
                it(@"should be overriden by a init method parameter", ^{
                    [[webServiceClientWithRoot.serviceRoot shouldNot] beEmpty];
                    [webServiceClientWithRoot.serviceRoot isEqualToString:yahooServer];
                });
            });
        });
    });

    context(@"Concrete Web Service Client", ^{
        __block NSString *mockWebServiceUrl = @"http://www.mock.com/webService";
        __block RFConcreteWebServiceClient *webServiceClient;

        __block id responseResult;
        __block NSError *responseError;

        beforeAll(^{
            webServiceClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:mockWebServiceUrl];
        });
        
        beforeEach(^{
            responseError = nil;
            responseResult = nil;
        });
        
        it(@"should exist and be of a proper type", ^{
            [[webServiceClient shouldNot] beNil];
            [[webServiceClient should] beKindOfClass:[RFConcreteWebServiceClient class]];
        });

        context(@"Synchronous Calls", ^{
            __block BOOL blockFinishedFirst;
            __block BOOL success;

            context(@"testSyncCall", ^{
                __block void(^runSyncCall)(void) = ^{
                    __block BOOL isFinished = NO;
                    blockFinishedFirst = NO;
                    success = NO;

                    [webServiceClient testSyncCallWithSuccess:^(id result) {
                        responseResult = result;
                        isFinished = YES;
                        success = YES;
                    } failure:^(NSError *error) {
                        responseError = error;
                        isFinished = YES;
                    }];

                    blockFinishedFirst = isFinished;

                    while (!isFinished) {
                        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
                    }
                };

                it(@"blocks should be called synchronously and should complete before the method completes", ^{
                    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", mockWebServiceUrl, @"syncCall"];
                    NSLog(@"\n\n%@\n\n", requestUrl);
                    stubRequest(@"GET", requestUrl).
                    andReturn(200);

                    runSyncCall();

                    [[theValue(blockFinishedFirst) should] equal:theValue(YES)];
                    [[responseError should] beNil];
                    [[theValue(success) should] equal:theValue(YES)];
                });
            });
            
            context(@"testSyncCallMultipartData", ^{
                __block void(^runSyncCall)(void) = ^{
                    __block BOOL isFinished = NO;
                    blockFinishedFirst = NO;
                    success = NO;

                    RFFormData *attachment = [[RFFormData alloc] initWithName:@"image"
                                                                         data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding]
                                                                     fileName:@"imageName.jpg"];
                    [webServiceClient testSyncCallMultipartDataWithAttachment:attachment
                                                                      success:^(id result) {
                                                                          responseResult = result;
                                                                          isFinished = YES;
                                                                          success = YES;
                                                                      } failure:^(NSError *error) {
                                                                          responseError = error;
                                                                          isFinished = YES;
                                                                      }];

                    blockFinishedFirst = isFinished;

                    while (!isFinished) {
                        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
                    }
                };

                beforeAll(^{
                });

                it(@"blocks should be called synchronously and should complete before the method completes", ^{
                    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", mockWebServiceUrl, @"syncCallMultipartData"];
                    NSLog(@"\n\n%@\n\n", requestUrl);
                    stubRequest(@"POST", requestUrl).
                    andReturn(200);

                    runSyncCall();

                    [[theValue(blockFinishedFirst) should] equal:theValue(YES)];
                    [[responseError should] beNil];
                    [[theValue(success) should] equal:theValue(YES)];
                });
            });
        });
    });
});

SPEC_END
