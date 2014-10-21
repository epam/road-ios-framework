//
//  RFPerformanceTest.m
//  ROADSerialization
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
#import "RFDateTestClass.h"
#import "RFAttributedCoder.h"
#import "NSDate+RFISO8601Formatter.h"

@interface RFPerformanceTest : XCTestCase

@end
static NSDateFormatter *dateFormatter;
@implementation RFPerformanceTest

- (void)dateSerialization:(NSDictionary*)dateDictionary {
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
    }
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithFormat" withAttributeType:[RFSerializableDate class]] format];
    [dateFormatter dateFromString:dateDictionary[@"dateWithFormat"]];
    
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithEncodeDecodeFormat" withAttributeType:[RFSerializableDate class]] encodingFormat];
    [dateFormatter dateFromString:dateDictionary[@"dateWithEncodeDecodeFormat"]];
    
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithEncodeFormatPriority" withAttributeType:[RFSerializableDate class]] encodingFormat];
    [dateFormatter dateFromString:dateDictionary[@"dateWithEncodeFormatPriority"]];
    
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithDecodeFormatPriority" withAttributeType:[RFSerializableDate class]] format];
    [dateFormatter dateFromString:dateDictionary[@"dateWithDecodeFormatPriority"]];
}

- (void)cDateSerialization:(NSDictionary*)dateDictionary {
    NSString* dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithCFormat" withAttributeType:[RFSerializableDate class]] format];
    [NSDate RF_dateFromISO8601String:dateDictionary[@"dateWithCFormat"] withDateFormat:dateFormat];
    
    dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithCEncodeDecodeFormat" withAttributeType:[RFSerializableDate class]] encodingFormat];
    [NSDate RF_dateFromISO8601String:dateDictionary[@"dateWithCEncodeDecodeFormat"] withDateFormat:dateFormat];
    
    dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithCEncodeFormatPriority" withAttributeType:[RFSerializableDate class]] encodingFormat];
    [NSDate RF_dateFromISO8601String:dateDictionary[@"dateWithCEncodeFormatPriority"] withDateFormat:dateFormat];
    
    dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithCDecodeFormatPriority" withAttributeType:[RFSerializableDate class]] format];
    [NSDate RF_dateFromISO8601String:dateDictionary[@"dateWithCDecodeFormatPriority"] withDateFormat:dateFormat];
}

- (void)testDateSerializationPerformance {
    SEL measureBlockSelector = @selector(measureBlock:);
    if([self respondsToSelector:measureBlockSelector]) {
        [self performSelector:measureBlockSelector withObject:^{
            RFDateTestClass *testObject = [RFDateTestClass testObject];
            NSString * testString = [RFAttributedCoder encodeRootObject:testObject];
            NSDictionary *test = [NSJSONSerialization JSONObjectWithData:[testString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            for(int i = 0 ; i < 1000; i++){
                [self dateSerialization:test];
            }
        }];
    }
    else {
        XCTAssertTrue(YES, @"");
    }
}

- (void)testCDateSerializationPerformance {
    SEL measureBlockSelector = @selector(measureBlock:);
    if([self respondsToSelector:measureBlockSelector]) {
        [self performSelector:measureBlockSelector withObject:^{
            RFDateTestClass *testObject = [RFDateTestClass testObject];
            NSString * testString = [RFAttributedCoder encodeRootObject:testObject];
            NSDictionary *test = [NSJSONSerialization JSONObjectWithData:[testString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
            for(int i = 0 ; i < 1000; i++){
                [self cDateSerialization:test];
            }
            
        }];
    }
    else {
        XCTAssertTrue(YES, @"");
    }
    
}

@end
