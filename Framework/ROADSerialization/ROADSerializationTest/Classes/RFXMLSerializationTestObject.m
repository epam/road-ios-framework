//
//  RFXMLSerializationTestObject.m
//  ROADSerialization
//
//  Created by Oleh Sannikov on 15.11.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "RFXMLSerializationTestObject.h"

@implementation RFXMLSerializationTestObject

+ (id)sampleObject {
    
    RFXMLSerializationTestObject *mary = [[RFXMLSerializationTestObject alloc] init];
    mary.name = @"Mary Doe";
    mary.age = 25;
    mary.city = @"Boyarka";
    
    RFXMLSerializationTestObject *chris = [[RFXMLSerializationTestObject alloc] init];
    chris.name = @"Chris Doe";
    chris.age = 13;
    chris.city = @"Boyarka";
    
    RFXMLSerializationTestObject *john = [[self alloc] init];
    john.name = @"John Doe";
    john.age = 54;
    john.city = @"Boyarka";
    john.children = @[mary, chris];
    
    john.string2 = @"value32";

    
    return john;
}

- (BOOL)isEqual:(id)object {
    
    return [object isMemberOfClass:[self class]] && [self isContentEqual:object];
}

- (BOOL)isContentEqual:(id)object {
    
    BOOL result = NO;

    if ([object isKindOfClass:[self class]]) {

        RFXMLSerializationTestObject *pair = object;
        
        result = (_name == pair.name) || [_name isEqualToString:pair.name];
        result &= (_city == pair.city) || [_city isEqualToString:pair.city];
        result &= (_age == pair.age);
        result &= (_children == pair.children || [_children isEqualToArray:pair.children]);
        result &= (_string2 == pair.string2) || [_string2 isEqualToString:pair.string2];
    }

    return result;
}

- (NSString *)nm {

    return @"http://itunes.apple.com/rss";
}

@end
