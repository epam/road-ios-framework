//
//  RFAnnotatedDecoder.m
//  ROADSerialization
//
//  Copyright (c) 2014 Epam Systems. All rights reserved.
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

#import "RFAttributedDecoder.h"
#import <ROAD/ROADReflection.h>
#import <ROAD/ROADLogger.h>

#import "RFSerializable.h"
#import "RFDerived.h"
#import "RFSerializableCollection.h"
#import "NSJSONSerialization+RFJSONStringHandling.h"
#import "RFSerializableDate.h"
#import "RFSerializableBoolean.h"
#import "RFBooleanTranslator.h"
#import "RFSerializationAssistant.h"


@interface RFAttributedDecoder ()

@end


@implementation RFAttributedDecoder {
    NSString * _dateFormat;
    NSMutableDictionary * _dateFormatters;
}


#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        _dateFormatters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark - Decoding

+ (id)decodeJSONString:(NSString *const)jsonString {
    NSDictionary *dict = [NSJSONSerialization RF_JSONObjectWithString:jsonString];
    NSString * const className = dict[RFSerializedObjectClassName];
    return [self decodeJSONString:jsonString withRootClassNamed:className];
}

+ (id)decodeJSONData:(NSData * const)jsonData withSerializtionRoot:(NSString *)serializationRoot rootClassNamed:(NSString * const)rootClassName {
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    id partOfJsonObject = jsonObject;
    if (serializationRoot.length) {
        partOfJsonObject  = [self jsonObjectForKeyPath:serializationRoot atJsonObject:jsonObject];
    }
    
    return [self decodePredeserializedObject:partOfJsonObject withRootClassName:rootClassName];
}

+ (id)decodeJSONString:(NSString *const)jsonString withRootClassNamed:(NSString *const)rootClassName {
    return [self decodeJSONData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] withRootClassNamed:rootClassName];
}

+ (id)decodeJSONData:(NSData * const)jsonData withRootClassNamed:(NSString * const)rootClassName {
    id const jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];

    return [self decodePredeserializedObject:jsonObject withRootClassName:rootClassName];
}

+ (id)decodePredeserializedObject:(id)jsonObject withRootClassName:(NSString * const)rootClassName {
    id result;
    if (rootClassName == nil) {
        result = jsonObject;
    } else {
        RFLogDebug(@"Decoder(%@ %p) started processing object(%@)", self, self, jsonObject);

        id decoder = [[self alloc] init];
        
        if ([jsonObject isKindOfClass:[NSArray class]]) {
            result = [NSMutableArray array];
            
            for (id const anElement in jsonObject) {
                [result addObject:[decoder decodeRootObject:anElement withRootClassNamed:rootClassName]];
            }
        }
        else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            result = [decoder decodeRootObject:jsonObject withRootClassNamed:rootClassName];
        }
        RFLogDebug(@"Decoder(%@ %p) ended processing", self, self);
    }
    
    return result;
}

- (id)decodeJSONDictionary:(NSDictionary * const)jsonDict forProperty:(RFPropertyInfo * const)aDesc {
    NSString * rootClassName;

    RFSerializable *serializableAttribute = [aDesc attributeWithType:[RFSerializable class]];
    if (!serializableAttribute.classNameSerializationDisabled) {
        rootClassName = jsonDict[RFSerializedObjectClassName];
    }

    if ([rootClassName length] == 0) {
        rootClassName = NSStringFromClass(aDesc.typeClass);
    }

    return [self decodeRootObject:jsonDict withRootClassNamed:rootClassName];
}

- (id)decodeRootObject:(NSDictionary * const)jsonDict withRootClassNamed:(NSString * const)rootClassName {
    Class rootObjectClass = NSClassFromString(rootClassName);
    id rootObject = nil;
    
    RFSerializationCustomHandler *customHandlerAttribute = [rootObjectClass RF_attributeForClassWithAttributeType:[RFSerializationCustomHandler class]];
    if (customHandlerAttribute && customHandlerAttribute.key.length == 0) {
        rootObject = RFCustomDeserialization(rootObject, customHandlerAttribute);
    }
    else {
        rootObject = [[rootObjectClass alloc] init];
        
        NSArray *properties = RFSerializationPropertiesForClass(rootObjectClass);
        
        @autoreleasepool {
            for (RFPropertyInfo * const aDesc in properties) {
                [self decodeProperty:aDesc ofObject:rootObject jsonDict:jsonDict handlerAttribute:customHandlerAttribute];
            }
        }
    }
        
    return rootObject;
}

- (void)decodeProperty:(RFPropertyInfo *)property ofObject:(id)object jsonDict:(NSDictionary * const)jsonDict handlerAttribute:(RFSerializationCustomHandler *)handlerAttribute {
    id value = jsonDict[RFSerializationKeyForProperty(property)];
    if (!value) {
        return;
    }

    NSString *propertyName = [property propertyName];
    id result = nil;
    
    if ([handlerAttribute.key isEqualToString:propertyName]) {
        result = RFCustomDeserialization(value, handlerAttribute);
    }
    else {
        RFSerializationCustomHandler *propertyCustomHandlerAttribute = [property attributeWithType:[RFSerializationCustomHandler class]];
        if (propertyCustomHandlerAttribute && propertyCustomHandlerAttribute.key.length == 0) {
            result = RFCustomDeserialization(value, propertyCustomHandlerAttribute);
        }
        else {
            result = [self decodeValue:value forProperty:property customHandlerAttribute:propertyCustomHandlerAttribute];
        }
    }
    if ([self isValueValid:result forProperty:property]) {
        [object setValue:result forKey:propertyName];
    }
}

- (id)decodeValue:(id const)aValue forProperty:(RFPropertyInfo * const)aDesc customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    id value = aValue;
    if ([value isKindOfClass:[NSArray class]]) {
        value = [self decodeArray:value forProperty:aDesc customHandlerAttribute:customHandlerAttribute];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        if ([aDesc.typeClass isSubclassOfClass:[NSDictionary class]]) {
            value = [self decodeDictionary:value forProperty:aDesc customHandlerAttribute:customHandlerAttribute];
        }
        else {
            value = [self decodeJSONDictionary:value forProperty:aDesc];
        }
    }
    else if ([aDesc attributeWithType:[RFSerializableDate class]]
             || [[self class] RF_attributeForClassWithAttributeType:[RFSerializableDate class]]) {
        value = [self decodeDateString:aValue forProperty:aDesc];
    }
    else if ([aDesc attributeWithType:[RFSerializableBoolean class]]) {
        value = [RFBooleanTranslator decodeTranslatableValue:aValue forProperty:aDesc];
    }
    return value;
}

- (id)decodeArray:(NSArray * const)anArray forProperty:(RFPropertyInfo * const)aDesc customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (id aValue in anArray) {
        [array addObject:[self decodeCollectionElement:aValue forProperty:aDesc customHandlerAttribute:customHandlerAttribute]];
    }
    return [array copy];
}

- (id)decodeDictionary:(NSDictionary * const)aDictionary forProperty:(RFPropertyInfo * const)aDesc customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [aDictionary enumerateKeysAndObjectsUsingBlock:^(id aKey, id aValue, BOOL *stop) {
        if ([customHandlerAttribute.key isEqualToString:aKey]) {
            dict[aKey] = RFCustomDeserialization(aValue, customHandlerAttribute);
        }
        else {
            dict[aKey] = [self decodeCollectionElement:aValue forProperty:aDesc customHandlerAttribute:nil];
        }
    }];
    
    return [dict copy];
}

- (id)decodeCollectionElement:(id const)aValue forProperty:(RFPropertyInfo * const)aDesc customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    id value = aValue;
    if ([aValue isKindOfClass:[NSArray class]]) {
        NSMutableArray *subArray = [[NSMutableArray alloc] init];
        
        for (const id aSubValue in aValue) {
            [subArray addObject:[self decodeCollectionElement:aSubValue forProperty:aDesc customHandlerAttribute:customHandlerAttribute]];
        }
        
        value = [subArray copy];
    }
    else if ([aValue isKindOfClass:[NSDictionary class]]) {
        NSString *decodeClassName = RFSerializationCollectionItemClassNameForProperty(aDesc);
        
        RFSerializable *serializableAttribute = [aDesc attributeWithType:[RFSerializable class]];
        if (decodeClassName == nil && !serializableAttribute.classNameSerializationDisabled) {
            decodeClassName = aValue[RFSerializedObjectClassName];
        }
        if ([decodeClassName length] > 0) {
            value = [self decodeRootObject:aValue withRootClassNamed:decodeClassName];
        }
        else {
            value = [self decodeDictionary:aValue forProperty:nil customHandlerAttribute:customHandlerAttribute];
        }
    }  
    return value;
}

- (id)decodeDateString:(id const)value forProperty:(RFPropertyInfo * const)propertyInfo {
    id decodedValue = nil;

    RFSerializableDate *serializableDateAttribute = [propertyInfo attributeWithType:[RFSerializableDate class]];

    if (serializableDateAttribute.unixTimestamp) {
        if ([value isKindOfClass:[NSNumber class]]) {
            NSNumber *interval = value;
            decodedValue = [NSDate dateWithTimeIntervalSince1970:[interval intValue] / serializableDateAttribute.unixTimestampMultiplier];
        }
    }
    else {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *dateFormat = ([serializableDateAttribute.decodingFormat length] == 0) ? serializableDateAttribute.format: serializableDateAttribute.decodingFormat;
            NSAssert(dateFormat, @"RFSerializableDate must have either format or encodingFormat specified");
            
            NSDateFormatter *dateFormatter = [self dateFormatterWithFormatString:dateFormat];
            decodedValue = [dateFormatter dateFromString:value];
        }
    }
    
    return decodedValue;
}


#pragma mark - Support methods

- (NSDateFormatter *)dateFormatterWithFormatString:(NSString *)formatString {
    NSDateFormatter *dateFormatter = _dateFormatters[formatString];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = formatString;
        _dateFormatters[formatString] = dateFormatter;
    }
    
    return dateFormatter;
}

+ (id)jsonObjectForKeyPath:(NSString *)keyPath atJsonObject:(id)jsonObject {
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    
    id nestedJsonObject = jsonObject;
    NSMutableString *currentKeyPath = [[NSMutableString alloc] init];
    
    for (int index = 0; index < [keys count]; index++) {
        NSString *key = keys[index];
        if (currentKeyPath.length) {
            [currentKeyPath appendString:@"."];
        }
        [currentKeyPath appendString:key];
                
        // Check invalid cases: number, string, null or null in array
        if ([nestedJsonObject isKindOfClass:[NSNumber class]]
            || [nestedJsonObject isKindOfClass:[NSString class]]
            || nestedJsonObject == [NSNull null]
            || ([nestedJsonObject isKindOfClass:[NSArray class]] && [nestedJsonObject count] == 1 && nestedJsonObject[0] == [NSNull null])) {
            nestedJsonObject = nil;
            
            RFLogWarning(@"Serialization failed because part ( %@ ) of serialization root ( %@ ) is not founded or equal nil", currentKeyPath, keyPath);
            break;
        }
        else {
            nestedJsonObject = [nestedJsonObject valueForKey:key];
        }
    }
    
    // Last check to remove nulls from result
    if ([nestedJsonObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrayWithoutNulls = [[NSMutableArray alloc] init];
        for (id obj in nestedJsonObject) {
            if (obj != [NSNull null]) {
                [arrayWithoutNulls addObject:obj];
            }
        }
        if ([arrayWithoutNulls count] > 0) {
            nestedJsonObject = arrayWithoutNulls;
        }
        else {
            nestedJsonObject = nil;
            RFLogWarning(@"Serialization failed because part ( %@ ) of serialization root ( %@ ) is not founded or equal nil", currentKeyPath, keyPath);
        }
        
    }
    
    return nestedJsonObject;
}

/**
 Determines if the value is primitive and has the nil or NSNull value to avoid crashes from setting nil or NSNull value to a primitive
 
 @param id the value to be set
 @param RFPropertyInfo the property information where the value should be set
 @return YES if the value can be safely set
 */
- (BOOL)isValueValid:(id const)value forProperty:(RFPropertyInfo *)propertyInfo {
    return ((value && value != [NSNull null]) || ![[propertyInfo typeName] isEqualToString:@"c"]);
}

@end
