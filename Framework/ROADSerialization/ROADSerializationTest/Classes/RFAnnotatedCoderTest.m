//
//  RFAnnotatedCoderTest.m
//  ROADSerialization
//
//  Copyright (c) 2014 Epam Systems. All rights reserved.
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
#import "RFDateTestClass.h"

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
    [self checkRestoredObject:restored];
}

- (void)checkRestoredObject:(RFSerializationTestObject *)restored {
    STAssertTrue([restored isKindOfClass:[RFSerializationTestObject class]], @"Assertion: the restored object is of the correct class:", NSStringFromClass([restored class]));
    STAssertTrue([restored.string1 isEqualToString:@"value1"] && [restored.child.string1 isEqualToString:@"value5"], @"Assertion: strings are restored to the correct value.");
    STAssertTrue([restored.strings[1] isEqualToString:@"value4"], @"Assertion: stringarray is restored correctly.");
    STAssertTrue([restored.subDictionary[@"object3"] isKindOfClass:[RFSerializationTestObject class]], @"Assertion: dictionary value is of the correct class");
    STAssertTrue([[restored.subDictionary[@"object3"] string1] isEqualToString:@"value31"], @"Assertion: object embedded in dictionary is restored correctly.");
    STAssertTrue([restored.string2 length] == 0 && [restored.child.string2 length] == 0, @"Assertion: derived properties are ignored.");
    STAssertTrue([[restored.child.subObjects[0] string1] isEqualToString:@"value31"], @"Assertion: embedded objects in array are restored properly.");
    STAssertTrue([restored.subDictionary[@"object3"] integer] == 5, @"Assertion: primitive types in embedded objects are restored correctly.");
    STAssertTrue([[restored.child.subObjects[1] number] integerValue] == 3, @"Assertion: NSNumber values are restored correctly.");
    
    STAssertTrue(restored.booleanToTranslateTrue, @"The translation was unsuccessfull.");
    STAssertTrue(restored.booleanToTranslateTrueFromNumber, @"The translation was unsuccessfull.");
    STAssertTrue(!restored.booleanToTranslateFalse, @"The translation from number was unsuccessfull.");
    STAssertTrue(!restored.booleanToTranslateFalseFromNumber, @"The translation from number was unsuccessfull.");
}

- (void)testDateSerialization {
    RFDateTestClass *testObject = [RFDateTestClass testObject];
    NSString *testObjectStandardString = [RFDateTestClass testObjectStringRepresentation];
    NSDictionary *testObjectStandard = [NSJSONSerialization JSONObjectWithData:[testObjectStandardString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    STAssertNotNil(testObjectStandard, @"Standard string has invalid format.");
    
    NSString * testString = [RFAttributedCoder encodeRootObject:testObject];
    NSDictionary *test = [NSJSONSerialization JSONObjectWithData:[testString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
    STAssertNotNil(test, @"Serialized string has invalid format.");
    
    STAssertTrue([test[@"unixTimestamp"] isEqualToString:testObjectStandard[@"unixTimestamp"]], @"Unix timestamp serialized incorrectly.");
    STAssertTrue([test[@"unixTimestampWithMultiplier"] isEqualToString:testObjectStandard[@"unixTimestampWithMultiplier"]], @"Unix timestamp with multiplier serialized incorrectly.");
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithFormat" withAttributeType:[RFSerializableDate class]] format];
    STAssertTrue([[dateFormatter dateFromString:test[@"dateWithFormat"]] isEqualToDate:[dateFormatter dateFromString:testObjectStandard[@"dateWithFormat"]]], @"dateWithFormat serialized incorrectly");
    
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithEncodeDecodeFormat" withAttributeType:[RFSerializableDate class]] encodingFormat];
    STAssertTrue([[dateFormatter dateFromString:test[@"dateWithEncodeDecodeFormat"]] isEqualToDate:[dateFormatter dateFromString:testObjectStandard[@"dateWithEncodeDecodeFormat"]]], @"dateWithEncodeDecodeFormat serialized incorrectly.");
    
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithEncodeFormatPriority" withAttributeType:[RFSerializableDate class]] encodingFormat];
    STAssertTrue([[dateFormatter dateFromString:test[@"dateWithEncodeFormatPriority"]] isEqualToDate:[dateFormatter dateFromString:testObjectStandard[@"dateWithEncodeFormatPriority"]]], @"dateWithEncodeFormatPriority serialized incorrectly.");
    
    dateFormatter.dateFormat = [[RFDateTestClass RF_attributeForProperty:@"dateWithDecodeFormatPriority" withAttributeType:[RFSerializableDate class]] format];
    STAssertTrue([[dateFormatter dateFromString:test[@"dateWithDecodeFormatPriority"]] isEqualToDate:[dateFormatter dateFromString:testObjectStandard[@"dateWithDecodeFormatPriority"]]], @"dateWithDecodeFormatPriority serialized incorrectly.");
}

- (void)testDateDeserialization {
    RFDateTestClass *testObject = [RFDateTestClass testObject];
    NSString *testDeserizationString = [RFDateTestClass testDeserialisationString];
    id testDeserizationObject = [RFAttributedDecoder decodeJSONString:testDeserizationString];
    STAssertTrue([testDeserizationObject isEqual:testObject], @"Deserialization of dates works incorrectly.");
}

- (void)testJsonWrongDeserializationRoot {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathToDeserialisationTestFile = [testBundle pathForResource:@"DeserialisationTest" ofType:@"json"];
    NSData *deserialisationTestData = [NSData dataWithContentsOfFile:pathToDeserialisationTestFile];
    id decodedObject = [RFAttributedDecoder decodeJSONData:deserialisationTestData withSerializtionRoot:@"child.subObjects.object" rootClassNamed:@"RFSerializationTestObject"];
    STAssertNil(decodedObject, @"Wrong deserialization root returned some value.");
}

- (void)testJsonDeserializationRoot {
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSString *pathToDeserialisationTestFile = [testBundle pathForResource:@"DeserialisationTest" ofType:@"json"];
    NSData *deserialisationTestData = [NSData dataWithContentsOfFile:pathToDeserialisationTestFile];
    id decodedObject = [RFAttributedDecoder decodeJSONData:deserialisationTestData withSerializtionRoot:@"child.subObjects.number" rootClassNamed:nil];
    STAssertNotNil(decodedObject, @"Wrong deserialization root returned some value.");
}

- (void)testMappingPredeserializedObject {
    id predeserializedObject = @[ @{@"string1" : @"value1"} ];
    NSArray *testArray = [RFAttributedDecoder decodePredeserializedObject:predeserializedObject withRootClassName:@"RFSerializationTestObject"];
    STAssertNotNil(testArray, @"Mapping predeserialized object failed");
    STAssertTrue([testArray count] == 1, @"Mapping predeserialized object performed incorrectly. Number of object in array must be one");

    RFSerializationTestObject *testObject = [testArray lastObject];
    STAssertNotNil(testObject, @"Mapping predeserialized object failed");
    STAssertTrue([testObject.string1 isEqualToString:@"value1"], @"Mapping predeserialized object performed incorrectly");
}

- (void)testCreationSerializableDictionaryFromObject {
    RFSerializationTestObject *testObject = [[RFSerializationTestObject alloc] init];
    testObject.string1 = @"value1";
    NSDictionary *testDictionary = [RFAttributedCoder encodeRootObjectToSerializableObject:@{ @"testObject" : testObject }];
    STAssertNotNil(testDictionary, @"Creating serializable dictionary failed");
    STAssertTrue([testDictionary[@"testObject"][@"string1"] isEqualToString:@"value1"], @"Creating serializable dictionary performed incorrectly");
}

- (void)testCreationSerializableArrayFromObject {
    RFSerializationTestObject *testObject = [[RFSerializationTestObject alloc] init];
    testObject.string1 = @"value1";
    NSArray *testArray = [RFAttributedCoder encodeRootObjectToSerializableObject:@[ testObject ]];
    STAssertNotNil(testArray, @"Creating serializable array failed");
    STAssertTrue([testArray count] == 1, @"Array must contain only one object. Serialization performed incorrectly");
    NSDictionary *testDictionary = [testArray lastObject];
    STAssertNotNil(testDictionary, @"Creating serializable array performed incorrectly");
    STAssertTrue([testDictionary[@"string1"] isEqualToString:@"value1"], @"Creating serializable dictionary in array performed incorrectly");
}

@end
