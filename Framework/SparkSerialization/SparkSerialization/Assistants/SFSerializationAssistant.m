//
//  SFSerializationAssistant.m
//  SparkSerialization
//
//  Created by Igor Chesnokov on 8/29/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "SFSerializationAssistant.h"
#import "SFSerializable.h"
#import "SFSerializableCollection.h"

@implementation SFSerializationAssistant

+ (NSString *)serializationKeyForProperty:(SFPropertyInfo *)propertyInfo {
    SFSerializable *propertySerializableAttribute = [propertyInfo.hostClass SF_attributeForProperty:propertyInfo.propertyName withAttributeType:[SFSerializable class]];
    
    if ([propertySerializableAttribute.serializationKey length] == 0) {
        return propertyInfo.propertyName;
    }
    
    return propertySerializableAttribute.serializationKey;
}

+ (NSString *)collectionItemClassNameForProperty:(SFPropertyInfo *)propertyInfo {
    SFSerializableCollection *collectionAttribute = [propertyInfo.hostClass SF_attributeForProperty:propertyInfo.propertyName withAttributeType:[SFSerializableCollection class]];
    return (collectionAttribute == nil || collectionAttribute.collectionClass == nil) ? nil : NSStringFromClass(collectionAttribute.collectionClass);
}

@end
