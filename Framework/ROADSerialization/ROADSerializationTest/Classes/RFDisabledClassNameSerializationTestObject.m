//
//  RFDisabledClassNameSerializationTestObject.m
//  ROADSerialization
//
//  Created by Sandor Gazdag on 1/23/14.
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import "RFDisabledClassNameSerializationTestObject.h"

@implementation RFDisabledClassNameSerializationTestObject

+ (RFDisabledClassNameSerializationTestObject *)sampleObject {
    
    RFDisabledClassNameSerializationTestObject *object = [[RFDisabledClassNameSerializationTestObject alloc] init];
    
    object.string1 = @"String one";
    object.string2 = @"String two";
    return object;
    
}

@end
