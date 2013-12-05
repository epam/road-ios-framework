//
//  RFXMLSerializationTestObject2.m
//  ROADSerialization
//
//  Created by Oleh Sannikov on 15.11.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "RFXMLSerializationTestObject2.h"

@implementation RFXMLSerializationTestObject2

+ (id)sampleObject {
    RFXMLSerializationTestObject2 *result = [super sampleObject];
    result.dog = @"Flurry";
    result.rockets = @[@"Spaceship One", @"Spaceship One on One", @"Spaceship Two"];
    
    return result;
}

- (BOOL)isContentEqual:(id)object
{
    BOOL result = NO;
    
    if ([object isKindOfClass:[self class]]) {
        
        RFXMLSerializationTestObject2 *pair = object;

        result = [super isContentEqual:pair];
        result &= (_dog == pair.dog) || [_dog isEqualToString:pair.dog];
        result &= (_rockets == pair.rockets || [_rockets isEqualToArray:pair.rockets]);
    }
    
    return result;
}

@end
