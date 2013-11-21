//
//  RFXMLSerializationTestObject.h
//  ROADSerialization
//
//  Created by Oleh Sannikov on 15.11.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFSerializable.h"
#import "RFXMLCollectionContainer.h"
#import "RFXMLAttributes.h"

RF_ATTRIBUTE(RFSerializable)
RF_ATTRIBUTE(RFXMLCollectionContainer, containerKey = @"children");
@interface RFXMLSerializationTestObject : NSObject

RF_ATTRIBUTE(RFDerived)
@property (copy, nonatomic) NSString *string2;

RF_ATTRIBUTE(RFXMLAttributes, isSavedInTag = YES);
@property (copy, nonatomic) NSString *name;
RF_ATTRIBUTE(RFXMLAttributes, isSavedInTag = YES);
@property (copy, nonatomic) NSString *city;
RF_ATTRIBUTE(RFXMLAttributes, isSavedInTag = YES);
RF_ATTRIBUTE(RFSerializable, serializationKey = @"nm:age")
@property (assign, nonatomic) int age;

RF_ATTRIBUTE(RFSerializableCollection, collectionClass = [RFXMLSerializationTestObject class])
@property (copy, nonatomic) NSArray *children;

+ (RFXMLSerializationTestObject *)sampleObject;

@end
