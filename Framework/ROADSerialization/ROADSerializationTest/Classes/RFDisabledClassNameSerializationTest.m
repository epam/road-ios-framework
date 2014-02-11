//
//  RFDisabledClassNameSerializationTest.m
//  ROADSerialization
//
//  Created by Sandor Gazdag on 1/23/14.
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "RFSerializationTestObject.h"
#import "RFAttributedDecoder.h"
#import "RFAttributedCoder.h"
#import "RFDisabledClassNameSerializationTestObject.h"

@interface RFDisabledClassNameSerializationTest : SenTestCase

@end

@implementation RFDisabledClassNameSerializationTest  {
    RFDisabledClassNameSerializationTestObject *_object;
}

- (void)setUp {
    [super setUp];
    _object = [RFDisabledClassNameSerializationTestObject sampleObject];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDisabledClassNameSerialization {
    
    NSString *jsonSrting = [RFAttributedCoder encodeRootObject:_object];
    NSData *jsonData = [jsonSrting dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *decodedJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    STAssertFalse(decodedJSON[RFSerializedObjectClassName], @"The deserialized content contained the \"RFSerializedObjectClassName\" regardless of the annotation. ");
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
}

@end
