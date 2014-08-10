//
//  RFPoolTest.m
//  ROADCore
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

#import "RFObjectPool.h"

static NSString* timeFormat1 = @"dd/MM/yyyy HH:mm:ss Z";
static NSString* timeFormat2 = @"MM.dd.yyyy HH:mm";

static NSString* key1 = @"key1";

@interface RFPoolTests : XCTestCase

@end


@implementation RFPoolTests {
    RFObjectPool* _dateFormattersPool;
    RFObjectPool* _dateFormatterStrictPool;
    RFObjectPool* _genericPool;
}

- (void)setUp {
    _dateFormattersPool = [[RFObjectPool alloc] initWithClass:NSDateFormatter.class defaultObjectInitializer:^id(id objectCreated, id identifier) {
        NSAssert([objectCreated isKindOfClass:NSDateFormatter.class], @"Check if the class of the object created is NSDateFormatter");
        NSAssert([identifier isKindOfClass:NSString.class], @"Check if the identifier is a NSString");
        
        NSString* formatString = (NSString*)identifier;
        NSDateFormatter* formatter = (NSDateFormatter*)objectCreated;
        formatter.dateFormat = formatString;
        return formatter;
    }];
    
    _dateFormatterStrictPool = [[RFObjectPool alloc] initWithClass:NSDateFormatter.class defaultObjectInitializer:nil];
    
    _genericPool = [[RFObjectPool alloc] init];
}

- (void)tearDown {
    _dateFormattersPool = nil;
    _genericPool = nil;
}

- (void)testObjectPoolAllocation {
    
    NSDateFormatter* formatter11 = _dateFormattersPool[timeFormat1];
    XCTAssertTrue(formatter11 != nil, @"Assertion: checking default object creation");
    
    NSDateFormatter* formatter12 = _dateFormattersPool[timeFormat1];
    XCTAssertTrue([formatter11 isEqual:formatter12], @"Assertion: checking objects pooling");
    
    NSDateFormatter* formatter21 = _dateFormattersPool[timeFormat2];
    XCTAssertTrue(formatter21 != nil, @"Assertion: checking default object creation");
    XCTAssertFalse([formatter11 isEqual:formatter21], @"Assertion: checking objects difference in pool");
    
    NSDateFormatter* formatterToBeNil = _dateFormatterStrictPool[timeFormat1];
    XCTAssertTrue(formatterToBeNil == nil);
    
    NSObject* genericObj11 = [[NSObject alloc] init];
    _genericPool[key1] = genericObj11;
    NSObject* genericObj12 = _genericPool[key1];
    XCTAssertTrue([genericObj11 isEqual:genericObj12], @"Assertion: checking objects equality after pooling");
    
    [_genericPool purge];
    XCTAssertTrue(_genericPool[key1] == nil, @"Assertion: no objects in a pool after clearing a memory");
}

- (void)testNegativeReaction {
    
    XCTAssertThrows(_dateFormattersPool[@"test"] = [[NSObject alloc] init], @"Exception: object of a wrong type is trying to be stored in a pool");
    XCTAssertThrows(_dateFormatterStrictPool[@"test"] = [[NSObject alloc] init], @"Exception: object of a wrong type is trying to be stored in a pool");
    XCTAssertNoThrow(_genericPool[@"test"] = [[NSDateFormatter alloc] init], @"No exception: it is allowed any object storing in a generic pool");
}

@end
