//
//  SFSerializableDate.h
//  SparkSerialization
//
//  Created by Yuru Taustahuzau on 7/18/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <Spark/SparkAttributesSupport.h>

/**
 Serialization attribute. Can be used either as a class attribute to set date format for all properties of a class. Can be used as individual property attribute to specify format date for this property or to override general format of date for whole class. Default value specify both encoding and decoding format, for specifying format for concrete direction set this format string to decodingFormat or encodingFormat.
 */
@interface SFSerializableDate : NSObject

@property(nonatomic, strong) NSString *format;

@property(nonatomic, strong) NSString *decodingFormat;
@property(nonatomic, strong) NSString *encodingFormat;

@property(nonatomic, assign) BOOL unixTimestamp;

@end
