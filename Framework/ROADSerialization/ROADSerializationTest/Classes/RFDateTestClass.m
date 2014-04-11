//
//  RFDateTestClass.m
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

#import "RFDateTestClass.h"

@implementation RFDateTestClass

+ (id)testObject {
    RFDateTestClass *testObject = [[RFDateTestClass alloc] init];
    testObject.unixTimestamp = [NSDate dateWithTimeIntervalSince1970:100000];
    testObject.unixTimestampWithMultiplier = [NSDate dateWithTimeIntervalSince1970:200000];
    testObject.dateWithFormat = [NSDate dateWithTimeIntervalSince1970:300000];
    testObject.dateWithEncodeDecodeFormat = [NSDate dateWithTimeIntervalSince1970:400000];
    testObject.dateWithDecodeFormatPriority = [NSDate dateWithTimeIntervalSince1970:500000];
    testObject.dateWithEncodeFormatPriority = [NSDate dateWithTimeIntervalSince1970:600000];
    
    return testObject;
}

+ (NSString *)testObjectStringRepresentation {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathToSerialisationTestFile = [testBundle pathForResource:@"DateTestStandard" ofType:@"json"];
    NSError *error = nil;
    NSString *serialisationTestString = [NSString stringWithContentsOfFile:pathToSerialisationTestFile encoding:NSStringEncodingConversionAllowLossy error:&error];
    return serialisationTestString;
}

+ (NSString *)testDeserialisationString {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathToDeserialisationTestFile = [testBundle pathForResource:@"DateTest" ofType:@"json"];
    NSError *error = nil;
    NSString *deserialisationTestString = [NSString stringWithContentsOfFile:pathToDeserialisationTestFile encoding:NSStringEncodingConversionAllowLossy error:&error];
    return deserialisationTestString;
}

- (BOOL)isEqual:(id)object {
    BOOL isEqual = NO;
    if ([object isMemberOfClass:[RFDateTestClass class]]) {
        RFDateTestClass *dateTestObject = object;
        if ([dateTestObject.unixTimestamp isEqualToDate:self.unixTimestamp]
            && [dateTestObject.unixTimestampWithMultiplier isEqualToDate:self.unixTimestampWithMultiplier]
            && [dateTestObject.dateWithFormat isEqualToDate:self.dateWithFormat]
            && [dateTestObject.dateWithDecodeFormatPriority isEqualToDate:self.dateWithDecodeFormatPriority]
            && [dateTestObject.dateWithEncodeDecodeFormat isEqualToDate:self.dateWithEncodeDecodeFormat]
            && [dateTestObject.dateWithEncodeFormatPriority isEqualToDate:self.dateWithEncodeFormatPriority]) {
            isEqual = YES;
        }
    }
    
    return isEqual;
}

@end
