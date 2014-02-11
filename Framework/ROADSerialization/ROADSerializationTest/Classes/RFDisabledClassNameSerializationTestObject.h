//
//  RFDisabledClassNameSerializationTestObject.h
//  ROADSerialization
//
//  Created by Sandor Gazdag on 1/23/14.
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ROADSerialization.h"
#import "RFSerializable.h"


RF_ATTRIBUTE(RFSerializable, classNameSerializationDisabled = YES)
@interface RFDisabledClassNameSerializationTestObject : NSObject

RF_ATTRIBUTE(RFSerializable, serializationKey = @"string1")
@property (nonatomic, strong) NSString *string1;

RF_ATTRIBUTE(RFSerializable, serializationKey = @"string2")
@property (nonatomic, strong) NSString *string2;

+ (RFDisabledClassNameSerializationTestObject *)sampleObject;

@end
