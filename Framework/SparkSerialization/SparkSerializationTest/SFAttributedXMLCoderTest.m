//
//  SFAttributedXMLCoderTest.m
//  SparkSerialization
//
//  Created by Oleh Sannikov on 03.10.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SFAttributedXMLCoder.h"
#import "SFAttributedXMLDecoder.h"
#import "SFSerializationTestObject.h"

@interface SFAttributedXMLCoderTest : SenTestCase

@end

@implementation SFAttributedXMLCoderTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testSerialization
{
    SFAttributedXMLCoder *coder = [[SFAttributedXMLCoder alloc] init];
    
    id testObject = @[@1, @2, @"3", [NSDate date]];
    
    NSString *result = [coder encodeRootObject:testObject];
//    STAssertTrue([result length] > 0, @"Assertion: serialization is successful.");

    NSLog(@"%@", result);
}

- (void)testDeserializationFromFile
{
    SFAttributedXMLDecoder *decoder = [[SFAttributedXMLDecoder alloc] init];

    NSBundle *testBundle = [NSBundle bundleForClass:[self class]];
    NSURL *fileURL = [testBundle URLForResource:@"DeserialisationTest" withExtension:@"xml"];
    NSData *data = [NSData dataWithContentsOfURL:fileURL];
    
    [decoder decodeData:data withRootObjectClass:[SFSerializationTestObject class] completionBlock:^(id result, NSError *error) {
        
        STAssertTrue(result, @"Assertion: serialization is successful.");

    }];
}

@end
