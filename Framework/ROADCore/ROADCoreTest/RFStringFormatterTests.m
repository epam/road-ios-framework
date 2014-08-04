//
//  RFTemplateParsingTest.m
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

#import "NSMutableString+RFStringFormatter.h"


@interface RFTemplateParsingTests : XCTestCase

@end


@implementation RFTemplateParsingTests {
    NSString *escape;
    NSDictionary *values;
}

- (void)setUp {
    escape = @"%%";
    values = @{ @"key1" : @"value1", @"key2" : @"value2", @"key3" : @"value3" };
    
    [super setUp];
}

- (void)tearDown {
    escape = nil;
    values = nil;
    
    [super tearDown];
}

- (void)testTemplateParsing {
    
    NSMutableString* template = @"someExample:%%key1%% withOtherValue:%%key2%% andThirdValue:%%key3%%".mutableCopy;
    
    [template RF_formatUsingValues:values withEscape:escape];
    
    NSRange rangeOfKey = [template rangeOfString:@"key"];
    NSRange rangeOfEscape = [template rangeOfString:escape];
    NSRange rangeOfValue1 = [template rangeOfString:@"value1"];
    NSRange rangeOfValue2 = [template rangeOfString:@"value2"];
    NSRange rangeOfValue3 = [template rangeOfString:@"value3"];
    
    XCTAssertTrue(rangeOfKey.location == NSNotFound, @"Assertion: no key is in the template.");
    XCTAssertTrue(rangeOfEscape.location == NSNotFound, @"Assertion: escape is no longer in the template.");
    XCTAssertTrue(rangeOfValue1.location != NSNotFound, @"Assertion: value1 is in the template.");
    XCTAssertTrue(rangeOfValue2.location != NSNotFound, @"Assertion: value2 is in the template.");
    XCTAssertTrue(rangeOfValue3.location != NSNotFound, @"Assertion: value3 is in the template.");
}

- (void)testURLParsing {

    NSMutableString* urlTemplate = @"http://test.url.com/?key1=%%key1%%&key2=%%key2%%&key3=%%key3%%".mutableCopy;
    [urlTemplate RF_formatAsURLUsingValues:values withEscape:escape];
    XCTAssertTrue([urlTemplate isEqualToString:@"http://test.url.com/?key1=value1&key2=value2&key3=value3"]);
    
    urlTemplate = @"http://test.url.com/?key1=%%key1%%&key2=%%absentParam%%&key3=%%key3%%&key4=%%absentParam%%".mutableCopy;
    [urlTemplate RF_formatAsURLUsingValues:values withEscape:escape];
    XCTAssertTrue([urlTemplate isEqualToString:@"http://test.url.com/?key1=value1&key3=value3"]);
    
    urlTemplate = @"http://test.url.com/?key1=%%absentParam%%".mutableCopy;
    [urlTemplate RF_formatAsURLUsingValues:values withEscape:escape];
    XCTAssertTrue([urlTemplate isEqualToString:@"http://test.url.com/?"]);
    
    urlTemplate = @"http://test.url.com/?key1=%%absentParam%%&key2=%%absentParam%%&key3=%%absentParam%%&key4=%%absentParam%%".mutableCopy;
    [urlTemplate RF_formatAsURLUsingValues:values withEscape:escape];
    XCTAssertTrue([urlTemplate isEqualToString:@"http://test.url.com/?"]);
}

@end
