//
//  RFSerializationTestObject.h
//  ObjCAttrPerformanceTest
//
//  Created by Alexander Dorofeev on 25/09/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#import "RFSerializable.h"
#import "RFSerializableDate.h"
#import "RFSerializableBoolean.h"
#import "RFSerializableCollection.h"
#import "RFDerived.h"


RF_ATTRIBUTE(RFSerializable)
@interface RFSerializationTestObject : NSObject

@property (strong, nonatomic) NSString *string1;

RF_ATTRIBUTE(RFDerived)
@property (copy, nonatomic) NSString *string2;

@property (assign, nonatomic) BOOL boolean;

RF_ATTRIBUTE(RFSerializableBoolean, translationValues = @{ @"true": @YES, @"false": @NO } )
@property (assign, nonatomic) BOOL booleanToTranslateTrue;

RF_ATTRIBUTE(RFSerializableBoolean, translationValues = @{ @"true": @YES, @"false": @NO } )
@property (assign, nonatomic) BOOL booleanToTranslateFalse;

RF_ATTRIBUTE(RFSerializableBoolean, translationValues = @{ @10000: @YES, @20000: @NO } )
@property (assign, nonatomic) BOOL booleanToTranslateTrueFromNumber;

RF_ATTRIBUTE(RFSerializableBoolean, translationValues = @{ @10000: @YES, @20000: @NO } )
@property (assign, nonatomic) BOOL booleanToTranslateFalseFromNumber;

@property (strong, nonatomic) NSArray *strings;

RF_ATTRIBUTE(RFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z")
@property (strong, nonatomic) NSDate *date1;

RF_ATTRIBUTE(RFSerializableDate, format = @"MM.dd.yyyy HH:mm", decodingFormat = @"MM.dd.yyyy HH:mm:ss")
@property (strong, nonatomic) NSDate *date2;

RF_ATTRIBUTE(RFSerializableDate, unixTimestamp = YES)
@property (strong, nonatomic) NSDate *unixTimestamp;

@property (strong, nonatomic) RFSerializationTestObject *child;

RF_ATTRIBUTE(RFSerializableCollection, collectionClass = [RFSerializationTestObject class])
@property (strong, nonatomic) NSArray *subObjects;

RF_ATTRIBUTE(RFSerializableCollection, collectionClass = [RFSerializationTestObject class])
@property (strong, nonatomic) NSDictionary *subDictionary;

@property (nonatomic) int integer;

@property (nonatomic, strong) NSNumber *number;

@property (nonatomic, copy) NSData *cdata;

+ (RFSerializationTestObject *)sampleObject;
+ (RFSerializationTestObject *)bigObject;

@end

