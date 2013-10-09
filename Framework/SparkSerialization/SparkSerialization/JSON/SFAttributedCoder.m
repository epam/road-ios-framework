//
//  SFAnnotatedCoder.m
//  SparkSerialization
//
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
//  Redistributions of source code must retain the above copyright notice, this 
// list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this 
// list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing


#import "SFAttributedCoder.h"
#import <Spark/SparkReflection.h>
#import "SFSerializationAssistant.h"
#import <Spark/SparkLogger.h>
#import "SFSerializable.h"
#import "SFDerived.h"
#import "SFSerializableDate.h"

@implementation SFAttributedCoder {
    NSString * _dateFormat;
    NSMutableDictionary * _dateFormatters;
    id _archive;
}


#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        _archive = [[NSMutableDictionary alloc] init];
        _dateFormatters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark - Encoding

+ (id)encodeRootObject:(id)rootObject {
    NSData *data = [self encodedDataOfRootObject:rootObject];    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *)encodedDataOfRootObject:(id)rootObject {
    id result = [self encodeRootObjectToSerializableObject:rootObject];
    return [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
}

+ (id)encodeRootObjectToSerializableObject:(id)rootObject {
    SFLogInfo(@"Coder(%@ %p) started processing object(%@)", self, self, rootObject);
    SFAttributedCoder *coder = [[self alloc] init];
    [coder encodeRootObject:rootObject];
    SFLogInfo(@"Coder(%@ %p) ended processing", self, self);
    return coder->_archive;
}

- (void)encodeRootObject:(id)rootObject {
    if ([rootObject isKindOfClass:[NSArray class]]) {
        _archive = [self encodeArray:rootObject];
    } else if ([rootObject isKindOfClass:[NSDictionary class]]) {
        _archive = [self encodeDictionary:rootObject];
    }
    else {
        [_archive setObject:NSStringFromClass([rootObject class]) forKey:SFSerializedObjectClassName];
        NSArray *properties;
        @autoreleasepool {            
            Class rootObjectClass = [rootObject class];
            
            if ([rootObjectClass SF_attributeForClassWithAttributeType:[SFSerializable class]]) {
                properties = [[rootObjectClass SF_properties] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SFPropertyInfo *evaluatedObject, NSDictionary *bindings) {
                    return (![evaluatedObject attributeWithType:[SFDerived class]]);
                }]];
            }
            else {
                properties = [rootObjectClass SF_propertiesWithAttributeType:[SFSerializable class]];
            }
            
            
        }        
        @autoreleasepool {
            for (SFPropertyInfo * const aDesc in properties) {
                id value = [rootObject valueForKey:[aDesc propertyName]];
                value = [self encodeValue:value forProperty:aDesc];
                
                NSString *key = [SFSerializationAssistant serializationKeyForProperty:aDesc];
                
                if (value != nil) {
                    [_archive setObject:value forKey:key];
                }
            }
        }    
    }
}

- (id)encodeValue:(id)value forProperty:(SFPropertyInfo *)propertyInfo {
    id encodedValue = nil;
    
    if ([value isKindOfClass:[NSDate class]]) {
        SFSerializableDate *serializableDateAttribute = [propertyInfo.hostClass SF_attributeForProperty:propertyInfo.propertyName withAttributeType:[SFSerializableDate class]];
        
        if (serializableDateAttribute.unixTimestamp) {
            NSDate *date = value;
            encodedValue = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
        }
        else {
            NSString *dateFormat = ([serializableDateAttribute.encodingFormat length] == 0) ? serializableDateAttribute.format: serializableDateAttribute.encodingFormat;
            NSAssert(dateFormat, @"SFSerializableDate must have either defaultValue or encodingFormat specified");
            
            NSDateFormatter *dateFormatter = [self dataFormatterWithFormatString:dateFormat];
            encodedValue = [dateFormatter stringFromDate:value];
        }
    }
    else {
        encodedValue = [self encodeValue:value];
    }
    
    return encodedValue;
}

- (id)encodeValue:(id)aValue {
    id value = aValue;
    
    if ([[value class] SF_attributeForClassWithAttributeType:[SFSerializable class]] || [[[value class] SF_propertiesWithAttributeType:[SFSerializable class]] count] > 0) {
        value = [[self class] encodeRootObjectToSerializableObject:value];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        value = [self encodeArray:value];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        value = [self encodeDictionary:value];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        value = [value description];
    }
    
    return value;
}

- (id)encodeArray:(NSArray *)anArray {
    NSMutableArray *array = [NSMutableArray array];
    
    for (id aValue in anArray) {
        [array addObject:[self encodeValue:aValue]];
    }
    
    return [NSArray arrayWithArray:array];
}

- (id)encodeDictionary:(NSDictionary *)aDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (id aKey in aDict) {
        id aValue = aDict[aKey];
        dict[aKey] = [self encodeValue:aValue];
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


#pragma mark - Support methods

- (NSDateFormatter *)dataFormatterWithFormatString:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [_dateFormatters objectForKey:formatString];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = formatString;
        [_dateFormatters setObject:dateFormatter forKey:formatString];
    }

    return dateFormatter;
}

@end
