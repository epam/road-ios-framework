//
//  RFXMLSerializationTestObject2.h
//  ROADSerialization
//
//  Created by Oleh Sannikov on 15.11.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFXMLSerializationTestObject.h"

RF_ATTRIBUTE(RFSerializable)
@interface RFXMLSerializationTestObject2 : RFXMLSerializationTestObject

RF_ATTRIBUTE(RFDerived)
@property (copy, nonatomic) NSString *string2;

RF_ATTRIBUTE(RFXMLSerializable, isTagAttribute = YES);
@property (copy, nonatomic) NSString *name;
RF_ATTRIBUTE(RFXMLSerializable, isTagAttribute = YES);
@property (copy, nonatomic) NSString *city;
RF_ATTRIBUTE(RFXMLSerializable, serializationKey = @"nm:age", isTagAttribute = YES);
@property (assign, nonatomic) int age;

RF_ATTRIBUTE(RFXMLSerializable, serializationKey = @"xmlns:nm", isTagAttribute = YES);
@property (assign, nonatomic) NSString *nm;

RF_ATTRIBUTE(RFXMLSerializableCollection, collectionClass = [RFXMLSerializationTestObject class], itemTag = @"child")
@property (copy, nonatomic) NSArray *children;

@property (copy, nonatomic) NSString *dog;

RF_ATTRIBUTE(RFXMLSerializableCollection, collectionClass = [NSString class], itemTag = @"rocket")
@property (copy, nonatomic) NSArray *rockets;

@end
