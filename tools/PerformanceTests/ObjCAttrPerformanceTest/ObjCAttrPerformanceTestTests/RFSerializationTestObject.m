//
//  RFSerializationTestObject.m
//  ObjCAttrPerformanceTest
//
//  Created by Alexander Dorofeev on 25/09/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#import "RFSerializationTestObject.h"
#import "RFAttributedXMLCoder.h"


static const NSTimeInterval kDateComparisonDelta = 1;

@implementation RFSerializationTestObject

- (BOOL)isEqual:(id)object
{
    BOOL result = (object == self);
    
    do {
        if (result) break;
        
        RFSerializationTestObject *pair = [object isKindOfClass:[self class]] ? object : nil;
        if (!pair) break;
        
        if (_boolean != pair.boolean) break;
        if (_integer != pair.integer) break;
        
        if ((_number != pair.number) && ![_number isEqualToNumber:pair.number]) break;
        
        if ((_string1 != pair.string1) && ![_string1 isEqualToString:pair.string1]) break;
        if ((_string2 != pair.string2) && ![_string2 isEqualToString:pair.string2]) break;
        if ((_date1 != pair.date1) && ([_date1 timeIntervalSinceDate:pair.date1] > kDateComparisonDelta)) break;
        if ((_date2 != pair.date2) && ([_date2 timeIntervalSinceDate:pair.date2] > kDateComparisonDelta)) break;
        if ((_unixTimestamp != pair.unixTimestamp) && ![_unixTimestamp isEqualToDate:pair.unixTimestamp]) break;
        
        if ((_strings != pair.strings) && ![_strings isEqualToArray:pair.strings]) break;
        
        if ((_subObjects != pair.subObjects) && ![_subObjects isEqualToArray:pair.subObjects]) break;
        if ((_subDictionary != pair.subDictionary) && ![_subDictionary isEqualToDictionary:pair.subDictionary]) break;
        
        result = YES;
        
    } while (0);
    
    return result;
}

- (NSUInteger)hash
{
    return (NSUInteger)self;
}

+ (RFSerializationTestObject*)sampleObject {
    
    RFSerializationTestObject *object3 = [[RFSerializationTestObject alloc] init];
    object3.string1 = @"value31";
    object3.string2 = @"value32";
    object3.booleanToTranslateFalse = NO;
    object3.booleanToTranslateFalseFromNumber = NO;
    object3.booleanToTranslateTrue = YES;
    object3.booleanToTranslateTrueFromNumber = YES;
    object3.integer = 5;
    
    RFSerializationTestObject *object4 = [[RFSerializationTestObject alloc] init];
    object4.string2 = @"value42";
    object4.string1 = @"value41";
    object4.booleanToTranslateFalse = NO;
    object4.booleanToTranslateFalseFromNumber = NO;
    object4.booleanToTranslateTrue = YES;
    object4.booleanToTranslateTrueFromNumber = YES;
    object4.number = @(3);
    
    RFSerializationTestObject *object = [[RFSerializationTestObject alloc] init];
    object.string1 = @"value1";
    object.string2 = @"value2";
    object.strings = @[@"value3", @"value4"];
    object.boolean = YES;
    object.subDictionary = @{@"object3" : object3};
    
    object.child = [[RFSerializationTestObject alloc] init];
    object.child.boolean = NO;
    
    object.booleanToTranslateTrue = YES;
    object.booleanToTranslateFalse = NO;
    object.booleanToTranslateTrueFromNumber = YES;
    object.booleanToTranslateFalseFromNumber = NO;
    
    object.child.string1 = @"value5";
    object.child.string2 = @"value6";
    object.child.strings = @[@"value7", @"value8"];
    object.child.subObjects = @[object3, object4];
    
    object.child.subDictionary = nil;
    object.date1 = [NSDate dateWithTimeIntervalSince1970:34530523];
    object.date2 = [NSDate dateWithTimeIntervalSince1970:10000];
    object.unixTimestamp = [NSDate dateWithTimeIntervalSince1970:200000];
    
    return object;
}

+ (RFSerializationTestObject*)bigObject{
    RFSerializationTestObject *bigTestObject = [RFSerializationTestObject sampleObject];
    
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    for (int i =0; i< 200; i++){
        RFSerializationTestObject *object4 = [[RFSerializationTestObject alloc] init];
        object4.string2 = @"value42";
        object4.string1 = @"value41";
        object4.booleanToTranslateFalse = NO;
        object4.booleanToTranslateFalseFromNumber = NO;
        object4.booleanToTranslateTrue = YES;
        object4.booleanToTranslateTrueFromNumber = YES;
        object4.number = @(3);
        [tmpArray addObject:object4];
    }
    
    bigTestObject.child.subObjects = tmpArray;
    
    return bigTestObject;
}

@end
