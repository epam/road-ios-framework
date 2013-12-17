//
//  RFWebServiceCacheTest.m
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

#import <SenTestingKit/SenTestingKit.h>
#import <ROAD/ROADLogger.h>
#import <objc/runtime.h>

#import "RFServiceProvider+ConcreteWebServiceClient.h"
#import "RFDownloader+FakeRequest.h"


@interface RFWebServiceCacheTest : SenTestCase

@end

@implementation RFWebServiceCacheTest

+ (void)setUp {
    [[RFServiceProvider logger] addWriter:[RFConsoleLogWriter new]];
    
    SEL originalSelector = @selector(start);
    SEL overrideSelector = @selector(fakeStart);
    Method originalMethod = class_getInstanceMethod([RFDownloader class], originalSelector);
    Method overrideMethod = class_getInstanceMethod([RFDownloader class], overrideSelector);
    method_exchangeImplementations(originalMethod, overrideMethod);
}

// Travis bug cause performing +setUp before each test
+ (void)tearDown {
    [[RFServiceProvider logger] removeWriter:[[[RFServiceProvider logger] writers] lastObject]];
    
    SEL originalSelector = @selector(start);
    SEL overrideSelector = @selector(fakeStart);
    Method originalMethod = class_getInstanceMethod([RFDownloader class], originalSelector);
    Method overrideMethod = class_getInstanceMethod([RFDownloader class], overrideSelector);
    method_exchangeImplementations(originalMethod, overrideMethod);
}

- (void)testPragmaNoCaching {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.pragma"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient withFirstResult:&firstDate secondResult:&controlDate];
    
    STAssertFalse([controlDate isEqualToString:firstDate], @"Response with Pragma:no-cache was cached!");
}

- (void)testCacheControlNoCaching {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.cache-control.no-cache"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient withFirstResult:&firstDate secondResult:&controlDate];
    
    STAssertFalse([controlDate isEqualToString:firstDate], @"Response with Cache-control:no-cache was cached!");
}

- (void)testNoCacheHeaders {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.no.cache.headers"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient withFirstResult:&firstDate secondResult:&controlDate];

    STAssertFalse([controlDate isEqualToString:firstDate], @"Response without any cache specifying was cached!");
}

- (void)testExpiresHeader {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.expires.header"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient withFirstResult:&firstDate secondResult:&controlDate];
    
    STAssertTrue([controlDate isEqualToString:firstDate], @"Response without any cache specifying was cached!");
}

- (void)testMaxAgeHeader {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.max-age.header"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient withFirstResult:&firstDate secondResult:&controlDate];
    
    STAssertTrue([controlDate isEqualToString:firstDate], @"Response without any cache specifying was cached!");
}


#pragma mark - Utility methods

- (BOOL)sendTwoConsequentRequestsOnWebServiceClient:(RFConcreteWebServiceClient *)webClient withFirstResult:(NSString **)firstResult secondResult:(NSString **)secondResult {
    __block BOOL isFinished = NO;
    [webClient testCacheControlNoCacheWithSuccess:^(NSData *result) {
        *firstResult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    
    STAssertNotNil(*firstResult, @"Web service request with cache failed!");
    
    isFinished = NO;
    [webClient testPragmaNoCacheWithSuccess:^(NSData *result) {
        *secondResult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    
    STAssertNotNil(*secondResult, @"Web service request with cache failed at second call!");
}

@end
