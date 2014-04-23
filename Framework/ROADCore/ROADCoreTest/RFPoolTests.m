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
#import "RFPoolObject.h"


@interface RFPoolTests : XCTestCase

@end


@implementation RFPoolTests {
    RFObjectPool *pool;
}

- (void)setUp {
    pool = [[RFObjectPool alloc] init];
    [pool registerClassNamed:@"RFPoolObject" forIdentifier:@"id1"];
    [pool registerClassNamed:@"RFPoolObject" forIdentifier:@"id2"];
}

- (void)tearDown {
    pool = nil;
}

- (void)testObjectPoolAllocation {
    id const object = [pool objectForIdentifier:@"id1"];
    id const nonObject = [pool objectForIdentifier:@"id3"];
    
    XCTAssertTrue(object != nil, @"Assertion: registered classes get instantiated property");
    XCTAssertTrue(nonObject == nil, @"Assertion: unregistered identifiers are not recognized");
}

- (void)testReuse {
    id const object = [pool objectForIdentifier:@"id2"];
    [object repool];
    id const reusedObject = [pool objectForIdentifier:@"id2"];
    
    XCTAssertTrue([object isEqual:reusedObject], @"Assertion: repooled objects are available for reusing.");
    
    id const newObject = [pool objectForIdentifier:@"id2"];
    
    XCTAssertTrue(![newObject isEqual:reusedObject], @"Assertion: requested objects are removed from the pool.");
}

@end