//
//  RFWebServiceStubbedTest.m
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

#import <XCTest/XCTest.h>
#import <Nocilla.h>

#import "RFConcreteWebServiceClient.h"
#import "RFWebServiceClientWithRoot.h"
#import "RFWebServiceCachingManager.h"

static NSString *mockWebServiceUrl = @"http://www.mock.com/webService";

@interface RFServiceProvider (RFWebServiceStubbedTest)
+(RFWebServiceCachingManager*)webServiceCacheManager;
@end

@implementation RFServiceProvider (RFWebServiceStubbedTest)
+ (RFWebServiceCachingManager *)webServiceCacheManager {
    static dispatch_once_t predicate;
    static RFWebServiceCachingManager *sharedWebServiceCacheManager;
    dispatch_once(&predicate, ^{
        sharedWebServiceCacheManager = [[RFWebServiceCachingManager alloc] init];
    });
    return sharedWebServiceCacheManager;
}
@end

@interface RFWebServiceStubbedTest : XCTestCase
{
    id responseResult;
    NSError *responseError;
}
@end

@implementation RFWebServiceStubbedTest

+ (void)setUp {
    [super setUp];
    [[LSNocilla sharedInstance] start];
}

+ (void)tearDown {
    [[LSNocilla sharedInstance] stop];
    [super tearDown];
}

- (void)setUp
{
    [super setUp];
    responseResult = nil;
    responseError = nil;
}

- (void)tearDown
{
    [[LSNocilla sharedInstance] clearStubs];
    [super tearDown];
}

- (void)testSyncCallParameter {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", mockWebServiceUrl, @"syncCall"];
    NSLog(@"\n\n%@\n\n", requestUrl);
    stubRequest(@"GET", requestUrl).
    andReturn(200);

    __block BOOL blockFinishedFirst = NO;
    __block BOOL success = NO;
    __block BOOL isFinished = NO;

    RFConcreteWebServiceClient *webServiceClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:mockWebServiceUrl];
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

    XCTAssertTrue(blockFinishedFirst, @"Web call and blocks should be called synchronously and should complete before we get to this point.");
    XCTAssertNil(responseError, @"Sync Webb call should not return an error.");
    XCTAssertTrue(success, @"Sync Web call should succeed.");
}

- (void)testSyncCallParameterWithMultipartData {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@", mockWebServiceUrl, @"syncCallMultipartData"];
    NSLog(@"\n\n%@\n\n", requestUrl);
    stubRequest(@"POST", requestUrl).
    andReturn(200);

    __block BOOL blockFinishedFirst = NO;
    __block BOOL success = NO;
    __block BOOL isFinished = NO;

    RFFormData *attachment = [[RFFormData alloc] initWithName:@"image"
                                                         data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding]
                                                     fileName:@"imageName.jpg"];
    RFConcreteWebServiceClient *webServiceClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:mockWebServiceUrl];
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

    XCTAssertTrue(blockFinishedFirst, @"Web call and blocks should be called synchronously and should complete before we get to this point.");
    XCTAssertNil(responseError, @"Sync Webb call should not return an error.");
    XCTAssertTrue(success, @"Sync Web call should succeed.");
}

@end
