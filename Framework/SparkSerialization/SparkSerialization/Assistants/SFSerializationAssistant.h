//
//  SFSerializationAssistant.h
//  SparkSerialization
//
//  Created by Igor Chesnokov on 8/29/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Spark/SparkReflection.h>

@interface SFSerializationAssistant : NSObject

+ (NSString *)serializationKeyForProperty:(SFPropertyInfo *)propertyInfo;
+ (NSString *)collectionItemClassNameForProperty:(SFPropertyInfo *)propertyInfo;

@end
