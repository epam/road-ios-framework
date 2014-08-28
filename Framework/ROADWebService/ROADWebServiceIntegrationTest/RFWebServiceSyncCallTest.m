//
//  RFWebServiceSyncCallTest.m
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

#import "RFConcreteWebServiceClient.h"
#import "RFWebServiceClientWithRoot.h"
#import "RFWebServiceCachingManager.h"
#import "RFDownloadFaker.h"


@interface RFWebServiceSyncCallTest : XCTestCase

@end


@implementation RFWebServiceSyncCallTest

+ (void)setUp {
    [RFDownloadFaker setUp];
}

// Travis bug cause performing +setUp before each test
+ (void)tearDown {
    [RFDownloadFaker tearDown];
}


- (void)testSyncCallParameter {
    __block BOOL success = NO;
    __block BOOL isFinished = NO;
    __block NSError *responseError;

    RFConcreteWebServiceClient *webServiceClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    [webServiceClient testSyncCallWithSuccess:^(id result) {
        isFinished = YES;
        success = YES;
    } failure:^(NSError *error) {
        responseError = error;
        isFinished = YES;
    }];

    XCTAssertTrue(isFinished, @"Web call and blocks should be called synchronously and should complete before we get to this point.");
    XCTAssertNil(responseError, @"Sync web call should not return an error.");
    XCTAssertTrue(success, @"Sync Web call should succeed.");
}

- (void)testSyncCallParameterWithMultipartData {
    __block BOOL success = NO;
    __block BOOL isFinished = NO;
    __block NSError *responseError;

    RFFormData *attachment = [[RFFormData alloc] initWithName:@"image"
                                                         data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding]
                                                     fileName:@"imageName.jpg"];
    RFConcreteWebServiceClient *webServiceClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"test.simple.call"];
    [webServiceClient testSyncCallMultipartDataWithAttachment:attachment
                                                      success:^(id result) {
                                                          isFinished = YES;
                                                          success = YES;
                                                      } failure:^(NSError *error) {
                                                          responseError = error;
                                                          isFinished = YES;
                                                      }];

    XCTAssertTrue(isFinished, @"Web call with multipart data and blocks should be called synchronously and should complete before we get to this point.");
    XCTAssertNil(responseError, @"Sync Web call should not return an error.");
    XCTAssertTrue(success, @"Sync Web call should succeed.");
}

@end
