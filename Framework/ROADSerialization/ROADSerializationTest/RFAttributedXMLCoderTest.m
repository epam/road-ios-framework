//
//  RFAttributedXMLCoderTest.m
//  ROADSerialization
//
//  Created by Oleh Sannikov on 03.10.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RFAttributedXMLCoder.h"
#import "RFAttributedXMLDecoder.h"
#import "RFSerializationTestObject.h"
#import <ROAD/ROADLogger.h>

@interface RFAttributedXMLCoderTest : SenTestCase {
    RFSerializationTestObject *object;

    RFAttributedXMLDecoder *decoder;
    RFAttributedXMLCoder *coder;
}

@end

@implementation RFAttributedXMLCoderTest

- (void)setUp {

    [RFServiceProvider logger].logLevel = RFLogLevelDebug;
    
    decoder = [[RFAttributedXMLDecoder alloc] init];
    coder = [[RFAttributedXMLCoder alloc] init];
    
    object = [RFSerializationTestObject sampleObject];
    
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testSimpleSerialization
{
    id objects = @[@1, @2, @"3", [NSDate date], @[@"string1", @"string2", @"string3"], @{@"myValue1" : @1, @"myValue2" : @2}];
    NSString *result = [coder encodeRootObject:objects];
    STAssertTrue([result length] > 0, @"Assertion: serialization of array is not successful.");
    
    id recreatedObjects = [decoder decodeData:[result dataUsingEncoding:NSUTF8StringEncoding] withRootObjectClass:nil];
    STAssertTrue([objects count] == [recreatedObjects count], @"Assertion: serialization is not successful.");
    
    RFSerializationTestObject *emptyObject = [[RFSerializationTestObject alloc] init];
    result = [coder encodeRootObject:emptyObject];
    STAssertTrue([result length] > 0, @"Assertion: serialization of empty test object is not successful.");
    
    RFSerializationTestObject *recreatedEmptyObject = [decoder decodeData:[result dataUsingEncoding:NSUTF8StringEncoding] withRootObjectClass:[RFSerializationTestObject class]];
    STAssertTrue([emptyObject isEqual:recreatedEmptyObject], @"Assertion: object is not equal to initial after serialization and deserialization.");
}

- (void)testObjectSerialization
{
    NSString* string = [coder encodeRootObject:object];
    RFSerializationTestObject *recreatedObject = [decoder decodeData:[string dataUsingEncoding:NSUTF8StringEncoding] withRootObjectClass:[RFSerializationTestObject class]];
    
    string = [coder encodeRootObject:recreatedObject];
    STAssertTrue([string length] > 0, @"Assertion: double serialization of test object is not successful.");
    
    STAssertTrue(![object isEqual:recreatedObject], @"Assertion: object is equal to initial after serialization and deserialization.");
    
    // string2 is derived attribute
    recreatedObject.string2 = object.string2;
    [recreatedObject.subDictionary[@"object3"] setString2:[object.subDictionary[@"object3"] string2]];
    
    STAssertTrue([object isEqual:recreatedObject], @"Assertion: object is not equal to initial after serialization and deserialization.");
}

- (void)testDeserializationFromFile
{
    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *fileURL = [testBundle URLForResource:@"DeserialisationTest" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];

    id result = [decoder decodeData:data withRootObjectClass:[RFSerializationTestObject class]];
    STAssertTrue(result, @"Assertion: serialization is not successful.");
}

@end
