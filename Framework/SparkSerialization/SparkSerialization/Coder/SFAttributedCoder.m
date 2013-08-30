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


#import "SFAttributedCoder.h"
#import <Spark/SparkReflection.h>
#import "SFSerializationAssistant.h"
#import <Spark/SparkLogger.h>
#import "SFSerializable.h"
#import "SFDerived.h"
#import "SFSerializableDate.h"

@interface SFAttributedCoder ()
@property (strong, nonatomic) id archive;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation SFAttributedCoder

- (id)init {
    self = [super init];
    
    if (self) {
        _archive = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

+ (id)encodeRootObject:(id const)rootObject {
    NSData * const data = [self encodeRootObjectToData:rootObject];
    NSString * const json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

+ (NSData *)encodeRootObjectToData:(const id)rootObject {
    id const result = [self encodeRootObjectToSerializableObject:rootObject];
    NSData * const data = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
    return data;
}

+ (id)encodeRootObjectToSerializableObject:(id const)rootObject {
    SFLogInfo(@"Coder(%@ %p) started processing object(%@)", self, self, rootObject);
    id decoder = [[self alloc] init];
    [decoder encodeRootObject:rootObject];
    SFLogInfo(@"Coder(%@ %p) ended processing", self, self);
    return [decoder archive];
}

- (void)encodeRootObject:(id const)rootObject {
    if ([rootObject isKindOfClass:[NSArray class]]) {
        self.archive = [self encodeArray:rootObject];
    } else if ([rootObject isKindOfClass:[NSDictionary class]]) {
        self.archive = [self encodeDictionary:rootObject];
    }
    else {
        [self.archive setObject:NSStringFromClass([rootObject class]) forKey:SFSerializedObjectClassName];
        NSArray *properties;
        @autoreleasepool {            
            Class rootObjectClass = [rootObject class];
            
            if ([rootObjectClass hasAttributesForClassWithAttributeType:[SFSerializable class]]) {
                properties = [[rootObjectClass properties] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SFPropertyInfo *evaluatedObject, NSDictionary *bindings) {
                    return ![evaluatedObject.hostClass hasAttributesForProperty:evaluatedObject.propertyName withAttributeType:[SFDerived class]];
                }]];
            }
            else {
                properties = [rootObjectClass propertiesWithAttributeType:[SFSerializable class]];
            }
            
            
        }        
        @autoreleasepool {
            for (SFPropertyInfo * const aDesc in properties) {
                id value = [rootObject valueForKey:[aDesc propertyName]];
                value = [self encodeValue:value forProperty:aDesc];
                
                NSString *key = [SFSerializationAssistant serializationKeyForProperty:aDesc];
                
                if (value != nil) {
                    [self.archive setObject:value forKey:key];
                }
            }
        }    
    }
}


- (id)encodeValue:(id const)aValue forProperty:(SFPropertyInfo *)propertyInfo {
    id value = aValue;
    id encodedValue = nil;
    
    if ([value isKindOfClass:[NSDate class]]) {
        SFSerializableDate *serializableDateAttribute = (SFSerializableDate *)[propertyInfo.hostClass lastAttributeForProperty:propertyInfo.propertyName withAttributeType:[SFSerializableDate class]];
        
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

- (id)encodeValue:(id const)aValue {
    id value = aValue;
    
    if ([[value class] hasAttributesForClassWithAttributeType:[SFSerializable class]] || [[[value class] propertiesWithAttributeType:[SFSerializable class]] count] > 0) {
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

- (id)encodeArray:(NSArray * const)anArray {
    NSMutableArray *array = [NSMutableArray array];
    
    for (id aValue in anArray) {
        [array addObject:[self encodeValue:aValue]];
    }
    
    return [NSArray arrayWithArray:array];
}

- (id)encodeDictionary:(NSDictionary * const)aDict {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (id aKey in aDict) {
        id aValue = aDict[aKey];
        [dict setObject:[self encodeValue:aValue] forKey:aKey];
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}


#pragma mark - Support methods

- (NSDateFormatter *)dataFormatterWithFormatString:(NSString *)formatString {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    
    if (![formatString isEqualToString:_dateFormatter.dateFormat]) {
        _dateFormatter.dateFormat = formatString;
    }
    
    return _dateFormatter;
}

@end
