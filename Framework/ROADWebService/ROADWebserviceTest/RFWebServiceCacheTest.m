//
//  RFWebServiceCacheTest.m
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

#import "RFServiceProvider+ConcreteWebServiceClient.h"
#import "RFDownloader+FakeRequest.h"
#import "RFServiceProvider+WebServiceCachingManager.h"
#import "RFDownloadFaker.h"


@interface RFWebServiceCacheTest : XCTestCase

@end

@implementation RFWebServiceCacheTest

+ (void)setUp {
    [RFDownloadFaker setUp];
}

// Travis bug cause performing +setUp before each test
+ (void)tearDown {
    [RFDownloadFaker tearDown];
    
    NSArray *cachingFolderList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *webServiceCachingPath = [cachingFolderList lastObject];
    webServiceCachingPath = [webServiceCachingPath stringByAppendingPathComponent:@"RFCachingDirecory"];
    webServiceCachingPath = [webServiceCachingPath stringByAppendingPathComponent:@"RFWebServiceCache.coredata"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:webServiceCachingPath]) {
        [[NSFileManager defaultManager] removeItemAtPath:webServiceCachingPath error:nil];
    }
}

- (void)testPragmaNoCaching {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.pragma"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertFalse([controlDate isEqualToString:firstDate], @"Response with Pragma:no-cache was cached!");
}

- (void)testCacheControlNoCaching {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.cache-control.no-cache"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertFalse([controlDate isEqualToString:firstDate], @"Response with Cache-control:no-cache was cached!");
}

- (void)testNoCacheHeaders {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.no.cache.headers"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];

    XCTAssertFalse([controlDate isEqualToString:firstDate], @"Response without any cache specifying was cached!");
}

- (void)testExpiresHeader {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.expires.header"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertTrue([controlDate isEqualToString:firstDate], @"Response with expires header was not cached!");
}

- (void)testMaxAgeHeader {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.max-age.header"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertTrue([controlDate isEqualToString:firstDate], @"Response with max-age header was not cached!");
}

- (void)testDisableCache {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.max-age.header"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheDisableWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertFalse([controlDate isEqualToString:firstDate], @"Response with disableCache attribute was cached!");
}

- (void)testMaxAgeAttribute {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.max-age.attr"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheMaxAgeWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertTrue([controlDate isEqualToString:firstDate], @"Response with maxAge attribute was not cached!");
}

- (void)testLastModifiedField {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.last.modified"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertFalse([controlDate isEqualToString:firstDate], @"Response with maxAge attribute was not cached!");
}

- (void)testEtagField {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.etag"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertFalse([controlDate isEqualToString:firstDate], @"Response with maxAge attribute was not cached!");
}

- (void)testSameLastModifiedField {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.same.last.modified"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertTrue([controlDate isEqualToString:firstDate], @"Response with maxAge attribute was not cached!");
}

- (void)testSameEtagField {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.same.etag"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertTrue([controlDate isEqualToString:firstDate], @"Response with maxAge attribute was not cached!");
}

- (void)testDropCacheMethod {
    [[RFServiceProvider webServiceCacheManager] dropCache];
    
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.max-age.header"];
    
    NSString *firstDate;
    NSString *controlDate;
    [self sendTwoConsequentRequestsOnWebServiceClient:webClient selector:@selector(testCacheNoAttrWithSuccess:failure:) firstResult:&firstDate secondResult:&controlDate];
    
    XCTAssertTrue([controlDate isEqualToString:firstDate], @"Response with max-age header was not cached!");
}


- (void)testCacheIdentifierParse {

    // GIVEN
    NSString * const comparationBaseCacheIdentifier =  @"cache.identifier.parsed.1";
    NSString * const cacheIdentifier =  @"cache.identifier.parsed.%%0%%";
    NSDictionary * const parseDictionary = @{@"0": @"1"};

    // WHEN
    NSString * const parsedCacheIdentifier = [[RFServiceProvider webServiceCacheManager] parseCacheIdentifier:cacheIdentifier withParameters:parseDictionary];

    // THEN
    XCTAssertTrue([parsedCacheIdentifier isEqualToString:comparationBaseCacheIdentifier], @"The cache identifiers are not equal");
}


- (void)testCacheIdentifierSet {

    // GIVEN
    [[RFServiceProvider webServiceCacheManager] dropCache];
    NSString * const cacheIdentifier = @"test.cache.identifier";

    // WHEN
    [self performRequestWithIdentifiedCacheWithServiceRoot:@"http://test.cache.identifier/first"];
    [self performRequestWithIdentifiedCacheWithServiceRoot:@"http://test.cache.identifier/second"];

    // THEN
    NSArray *response = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifier:cacheIdentifier];

    XCTAssertTrue([response count] == 1, @"The cache hasn't contained the value with the identifier which has been set.");
}

- (void)testCacheIdentifierSetPrefixed {

    // GIVEN
    [[RFServiceProvider webServiceCacheManager] dropCache];
    NSString * const cacheIdentifierToMatch = @"test.cache.identifier.prefix";
    NSString * const cacheIdentifierToFail = @"identifier.prefix";

    // WHEN
    [self performRequestWithParseIdForPrefixedCache:@"1"];
    [self performRequestWithParseIdForPrefixedCache:@"2"];

    // THEN
    NSArray *matchedResponses = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifierPrefix:cacheIdentifierToMatch];
    NSArray *nonMatchingResponses = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifierPrefix:cacheIdentifierToFail];

    XCTAssertTrue([matchedResponses count] == 2, @"The cache did not retrieve all the elements which ahve been set.");
    XCTAssertTrue([nonMatchingResponses count] == 0, @"The cache matched not only for the prefix but to substring also.");
}


- (void)testTargetedCacheInvalidation {

    // GIVEN
    [[RFServiceProvider webServiceCacheManager] dropCache];
    NSString * const cacheIdentifierForPrefixed = @"test.cache.identifier.prefix";
    NSString * const cacheIdentifier = @"test.cache.identifier";

    [self performRequestWithIdentifiedCacheWithServiceRoot:@"http://test.cache.identifier"];
    [self performRequestWithParseIdForPrefixedCache:@"1"];
    [self performRequestWithParseIdForPrefixedCache:@"2"];

    // pre check
    NSArray *removedResponses = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifierPrefix:cacheIdentifierForPrefixed];
    NSArray *remainingResponse = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifier:cacheIdentifier];
    XCTAssertTrue([removedResponses count] == 2, @"The removable cache elemnts for the test have not been created.");
    XCTAssertNotNil(remainingResponse, @"The cache element which needs to be kept after flush not been created.");

    // WHEN
    [[RFServiceProvider webServiceCacheManager] flushElementsWithIdentifierPrefix:cacheIdentifierForPrefixed];


    // THEN
    removedResponses = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifierPrefix:cacheIdentifierForPrefixed];
    remainingResponse = [[RFServiceProvider webServiceCacheManager] cacheWithIdentifier:cacheIdentifier];

    XCTAssertTrue([removedResponses count] == 0, @"The targeted cache elements were not flushed.");
    XCTAssertTrue([remainingResponse count] == 1, @"The cached element which should have been kept have been also removed.");
}

#pragma mark - Utility methods

- (void)performRequestWithIdentifiedCacheWithServiceRoot:(NSString *)serviceRoot {
    __block BOOL isFinished = NO;
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:serviceRoot];
    [webClient testCacheIdentifierWithSuccess:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
}

- (void)performRequestWithParseIdForPrefixedCache:(NSString *)parseId {
    __block BOOL isFinished = NO;
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.cache.identifier"];

    isFinished = NO;
    [webClient testCacheIdentifierWithPrefix:parseId success:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];

    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
}

- (BOOL)sendTwoConsequentRequestsOnWebServiceClient:(RFConcreteWebServiceClient *)webClient selector:(SEL)selector firstResult:(NSString **)firstResult secondResult:(NSString **)secondResult {
    __block BOOL isFinished = NO;
    // Strong variable to store response from web service
    __block NSString *fResult;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [webClient performSelector:selector withObject:^(NSData *result) {
        fResult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        isFinished = YES;
    } withObject:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertNotNil(fResult, @"Web service request with cache failed!");
    
    __block NSString *sResult;
    isFinished = NO;
    [webClient performSelector:selector withObject:^(NSData *result) {
        sResult = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        isFinished = YES;
    } withObject:^(NSError *error) {
        isFinished = YES;
    }];
#pragma clang diagnostic pop
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertNotNil(sResult, @"Web service request with cache failed at second call!");
    
    *firstResult = fResult;
    *secondResult = sResult;
}

@end
