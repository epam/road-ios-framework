//
//  RFAnnotatedCoderTest.m
//  ROADSerialization
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
#import "RFSerializationTestObject.h"
#import "RFAttributedDecoder.h"
#import "RFAttributedCoder.h"

@interface RFAnnotatedCoderTest : SenTestCase

@end

@implementation RFAnnotatedCoderTest {
    RFSerializationTestObject *object;
}

- (void)setUp {

    object = [RFSerializationTestObject sampleObject];
    
    [super setUp];
}

- (void)tearDown {
    object.child = nil;
    object = nil;
    
    [super tearDown];
}

- (void)testSerialization {
    NSString *result = [RFAttributedCoder encodeRootObject:object];
    NSError *error;
    NSString *test = [NSString stringWithContentsOfFile:[[NSBundle bundleForClass:self.class] pathForResource:@"SerializationTest" ofType:@"json"] encoding:NSUTF8StringEncoding error:&error];
    
    NSArray *tests = [test componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    tests = [tests filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    NSArray *results = [result componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" \n"]];
    results = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    STAssertNil(error, @"Assertion: SerializationTest.json file was not loaded to check result");
    STAssertEquals([tests count], [results count], @"Assertion: number of components in result json is wrong");
    
    BOOL skippingDate = NO;
    for (int index = 0; index < [tests count]; index++) {
        if (index > 2 && [tests[index - 2] hasPrefix:@"\"date"]) {
            // Date field is depends on time zone
            skippingDate = YES;
        }
        
        if (!skippingDate) {
            NSLog(@"%@", results[index]);
            STAssertTrue([tests[index] isEqualToString:results[index]], @"Assertion: serialization is not successful. Result: %@", result);
        }
        
        if ([tests[index] hasSuffix:@","]) {
            skippingDate = NO;
        }
    }
}

- (void)testDeserialization {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathToDeserialisationTestFile = [testBundle pathForResource:@"DeserialisationTest" ofType:@"json"];
    NSError *error = nil;
    NSString *deserialisationTestString = [NSString stringWithContentsOfFile:pathToDeserialisationTestFile encoding:NSStringEncodingConversionAllowLossy error:&error];
    STAssertTrue(!error, @"Deserialisation content is not available, error: %@", error);
    STAssertTrue([deserialisationTestString length] > 0, @"Deserialisation content is missing");
    
    RFSerializationTestObject *restored = [RFAttributedDecoder decodeJSONString:deserialisationTestString];
    STAssertTrue([restored isKindOfClass:[RFSerializationTestObject class]], @"Assertion: the restored object is of the correct class:", NSStringFromClass([restored class]));
    STAssertTrue([restored.string1 isEqualToString:@"value1"] && [restored.child.string1 isEqualToString:@"value5"], @"Assertion: strings are restored to the correct value.");
    STAssertTrue([restored.strings[1] isEqualToString:@"value4"], @"Assertion: stringarray is restored correctly.");
    STAssertTrue([restored.subDictionary[@"object3"] isKindOfClass:[RFSerializationTestObject class]], @"Assertion: dictionary value is of the correct class");
    STAssertTrue([[restored.subDictionary[@"object3"] string1] isEqualToString:@"value31"], @"Assertion: object embedded in dictionary is restored correctly.");
    STAssertTrue([restored.string2 length] == 0 && [restored.child.string2 length] == 0, @"Assertion: derived properties are ignored.");
    STAssertTrue([[restored.child.subObjects[0] string1] isEqualToString:@"value31"], @"Assertion: embedded objects in array are restored properly.");
    STAssertTrue([restored.subDictionary[@"object3"] integer] == 5, @"Assertion: primitive types in embedded objects are restored correctly.");
    STAssertTrue([[restored.child.subObjects[1] number] integerValue] == 3, @"Assertion: NSNumber values are restored correctly.");
    //STAssertTrue([restored.unixTimestamp isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1365609600]], @"Assertion: NSDate unix timestamp values are restored correctly.");
}

@end
