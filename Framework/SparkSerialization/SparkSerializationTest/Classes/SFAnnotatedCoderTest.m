//
//  SFAnnotatedCoderTest.m
//  SparkSerialization
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


#import "SFAnnotatedCoderTest.h"
#import "SFSerializationTestObject.h"
#import "SFAttributedDecoder.h"
#import "SFAttributedCoder.h"

@implementation SFAnnotatedCoderTest {
    SFSerializationTestObject *object;
}

- (void)setUp {
    SFSerializationTestObject *object3 = [[SFSerializationTestObject alloc] init];
    object3.string1 = @"value31";
    object3.string2 = @"value32";
    object3.integer = 5;
    SFSerializationTestObject *object4 = [[SFSerializationTestObject alloc] init];
    object4.string2 = @"value42";
    object4.string1 = @"value41";
    object4.number = @(3);
    
    object = [[SFSerializationTestObject alloc] init];
    object.string1 = @"value1";
    object.string2 = @"value2";
    object.strings = @[@"value3", @"value4"];
    object.boolean = YES;
    object.subDictionary = @{@"object3" : object3};
    object.child = [[SFSerializationTestObject alloc] init];
    object.child.boolean = NO;
    object.child.string1 = @"value5";
    object.child.string2 = @"value6";
    object.child.strings = @[@"value7", @"value8"];
    object.child.subObjects = @[object3, object4];
    object.child.subDictionary = nil;
    object.date1 = [NSDate date];
    object.date2 = [NSDate dateWithTimeIntervalSinceNow:10000];
    object.unixTimestamp = [NSDate dateWithTimeIntervalSince1970:200000];
    
    [super setUp];
}

- (void)tearDown {
    object.child = nil;
    object = nil;
    
    [super tearDown];
}

- (void)testSerialization {
    NSString *result = [SFAttributedCoder encodeRootObject:object];
    STAssertTrue([result length] > 0, @"Assertion: serialization is successful.");
}

- (void)testDeserialization {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathToDeserialisationTestFile = [testBundle pathForResource:@"DeserialisationTest" ofType:@"json"];
    NSError *error = nil;
    NSString *deserialisationTestString = [NSString stringWithContentsOfFile:pathToDeserialisationTestFile encoding:NSStringEncodingConversionAllowLossy error:&error];
    STAssertTrue(!error, @"Deserialisation content is not available, error: %@", error);
    STAssertTrue([deserialisationTestString length] > 0, @"Deserialisation content is missing");
    
    SFSerializationTestObject *restored = [SFAttributedDecoder decodeJSONString:deserialisationTestString];
    STAssertTrue([restored isKindOfClass:[SFSerializationTestObject class]], @"Assertion: the restored object is of the correct class:", NSStringFromClass([restored class]));
    STAssertTrue([restored.string1 isEqualToString:@"value1"] && [restored.child.string1 isEqualToString:@"value5"], @"Assertion: strings are restored to the correct value.");
    STAssertTrue([restored.strings[1] isEqualToString:@"value4"], @"Assertion: stringarray is restored correctly.");
    STAssertTrue([restored.subDictionary[@"object3"] isKindOfClass:[SFSerializationTestObject class]], @"Assertion: dictionary value is of the correct class");
    STAssertTrue([[restored.subDictionary[@"object3"] string1] isEqualToString:@"value31"], @"Assertion: object embedded in dictionary is restored correctly.");
    STAssertTrue([restored.string2 length] == 0 && [restored.child.string2 length] == 0, @"Assertion: derived properties are ignored.");
    STAssertTrue([[restored.child.subObjects[0] string1] isEqualToString:@"value31"], @"Assertion: embedded objects in array are restored properly.");
    STAssertTrue([restored.subDictionary[@"object3"] integer] == 5, @"Assertion: primitive types in embedded objects are restored correctly.");
    STAssertTrue([[restored.child.subObjects[1] number] integerValue] == 3, @"Assertion: NSNumber values are restored correctly.");
    //STAssertTrue([restored.unixTimestamp isEqualToDate:[NSDate dateWithTimeIntervalSince1970:1365609600]], @"Assertion: NSDate unix timestamp values are restored correctly.");
}

@end
