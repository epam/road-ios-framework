//
//  SFIvarInfoTest.m
//  ROADCore
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
#import <objc/runtime.h>
#import "SFIvarInfo.h"


@interface SFIvarInfoTest : SenTestCase {
    Class _testClass;
}
@end

@implementation SFIvarInfoTest

const static NSUInteger numberOfIVars = 352;
const static char *testClassName = "testClassName";

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    _testClass = objc_allocateClassPair([NSObject class], testClassName, 0);
}

- (void)testIVarCount
{
    NSUInteger inc = 0;
    for (int i = inc; i <= numberOfIVars; i++) {
        const char *cstring = [[NSString stringWithFormat:@"var%d", i] UTF8String];
        class_addIvar(_testClass, cstring, sizeof(id), rint(log2(sizeof(id))), @encode(id));
        inc++;
    }
    STAssertTrue(inc == [[SFIvarInfo ivarsOfClass:_testClass] count], @"It's not equals a sum of ivars");
}

- (void)testIVarByName
{
    const char* ivarName = "ivarNameTest";
    char *type = @encode(NSObject);
    class_addIvar(_testClass, ivarName, sizeof(type), log2(sizeof(type)), type);
    
    NSString *tempIvar = [NSString stringWithCString:ivarName encoding:NSUTF8StringEncoding];
    SFIvarInfo *result = [SFIvarInfo SF_ivarNamed:tempIvar ofClass:_testClass];
    STAssertNotNil(result, @"Can't find data by ivar name");
}

- (void)tearDown
{
    _testClass = nil;
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

@end
