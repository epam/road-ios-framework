//
//  SFAnnotatedDecoder.m
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


#import "SFAttributedDecoder.h"
#import <Spark/SparkReflection.h>
#import "SFSerializationAssistant.h"
#import <Spark/SparkLogger.h>

#import "SFSerializable.h"
#import "SFDerived.h"
#import "SFSerializableCollection.h"
#import "NSJSONSerialization+SFJSONStringHandling.h"
#import "SFSerializableDate.h"

@interface SFAttributedDecoder ()

@end


@implementation SFAttributedDecoder {
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
    NSDictionary *dict = [NSJSONSerialization SF_JSONObjectWithString:jsonString];
    NSString * const className = dict[SFSerializedObjectClassName];
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
        SFLogDebug(@"Decoder(%@ %p) started processing object(%@)", self, self, jsonObject);

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
        SFLogDebug(@"Decoder(%@ %p) ended processing", self, self);
    }
    
    return result;
}

- (id)decodeJSONDictionary:(NSDictionary * const)jsonDict forProperty:(SFPropertyInfo * const)aDesc {
    NSString * rootClassName;
    
    rootClassName = jsonDict[SFSerializedObjectClassName];

    if ([rootClassName length] == 0) {
        rootClassName = NSStringFromClass(aDesc.attributeClass);
    }

    return [self decodeRootObject:jsonDict withRootClassNamed:rootClassName];
}

- (id)decodeRootObject:(NSDictionary * const)jsonDict withRootClassNamed:(NSString * const)rootClassName {
    id rootObject;
    
    __unsafe_unretained Class const rootObjectClass = NSClassFromString(rootClassName);
    rootObject = [[rootObjectClass alloc] init];
    NSArray *properties;
    @autoreleasepool {
        if ([rootObjectClass SF_attributeForClassWithAttributeType:[SFSerializable class]]) {
            properties = [[rootObjectClass SF_properties] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SFPropertyInfo *evaluatedObject, NSDictionary *bindings) {
                return (![evaluatedObject attributeWithType:[SFDerived class]]);
            }]];
        }
        else {
            properties = [rootObjectClass SF_propertiesWithAttributeType:[SFSerializable class]];
        }
    }

    NSString *aKey;
    @autoreleasepool {
        for (SFPropertyInfo * const aDesc in properties) {
            aKey = [SFSerializationAssistant serializationKeyForProperty:aDesc];
            
            id result = [self decodeValue:jsonDict[aKey] forProperty:aDesc];
            [rootObject setValue:result forKey:[aDesc propertyName]];
        }
    }
    
    return rootObject;
}

- (id)decodeValue:(id const)aValue forProperty:(SFPropertyInfo * const)aDesc {
    id value = aValue;
    if ([value isKindOfClass:[NSArray class]]) {
        value = [self decodeArray:value forProperty:aDesc];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        
        if (![aDesc.attributeClass isSubclassOfClass:[NSDictionary class]]) {
            value = [self decodeJSONDictionary:value forProperty:aDesc];
        }
        else {
            value = [self decodeDictionary:value forProperty:aDesc];
        }
    }
    else if ([aDesc attributeWithType:[SFSerializableDate class]]
             || [[self class] SF_attributeForClassWithAttributeType:[SFSerializableDate class]]) {
        value = [self decodeDateString:aValue forProperty:aDesc];
    }
    return value;
}

- (id)decodeArray:(NSArray * const)anArray forProperty:(SFPropertyInfo * const)aDesc {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [anArray enumerateObjectsUsingBlock:^(id aValue, NSUInteger idx, BOOL *stop) {
        [array addObject:[self decodeCollectionElement:aValue forProperty:aDesc]];
    }];
    return [array copy];
}

- (id)decodeDictionary:(NSDictionary * const)aDictionary forProperty:(SFPropertyInfo * const)aDesc {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [aDictionary enumerateKeysAndObjectsUsingBlock:^(id aKey, id aValue, BOOL *stop) {
        [dict setObject:[self decodeCollectionElement:aValue forProperty:aDesc] forKey:aKey];
    }];
    return [dict copy];
}

- (id)decodeCollectionElement:(id const)aValue forProperty:(SFPropertyInfo * const)aDesc {
    id value = aValue;
    if ([aValue isKindOfClass:[NSArray class]]) {
        NSMutableArray *subArray = [[NSMutableArray alloc] init];
        
        for (const id aSubValue in aValue) {
            [subArray addObject:[self decodeCollectionElement:aSubValue forProperty:aDesc]];
        }
        
        value = [subArray copy];
    }
    else if ([aValue isKindOfClass:[NSDictionary class]]) {
        NSString *decodeClassName = [SFSerializationAssistant collectionItemClassNameForProperty:aDesc];
        
        if (decodeClassName == nil) {
            decodeClassName = aValue[SFSerializedObjectClassName];
        }
        
        if ([decodeClassName length] > 0) {
            value = [self decodeRootObject:aValue withRootClassNamed:decodeClassName];
        }
        else {
            value = [self decodeDictionary:aValue forProperty:nil];
        }
    }  
    return value;
}

- (id)decodeDateString:(id const)value forProperty:(SFPropertyInfo * const)propertyInfo {
    id decodedValue = nil;

    SFSerializableDate *serializableDateAttribute = [propertyInfo.hostClass SF_attributeForProperty:propertyInfo.propertyName withAttributeType:[SFSerializableDate class]];

    if (serializableDateAttribute.unixTimestamp) {
        if (![value isKindOfClass:[NSNumber class]]) {
            decodedValue = nil;
        }
        else {
            NSNumber *interval = value;
            decodedValue = [NSDate dateWithTimeIntervalSince1970:[interval intValue]];
        }
    }
    else {
        if (![value isKindOfClass:[NSString class]]) {
            decodedValue = nil;
        }
        else {
            NSString *dateFormat = ([serializableDateAttribute.decodingFormat length] == 0) ? serializableDateAttribute.format: serializableDateAttribute.decodingFormat;
            NSAssert(dateFormat, @"SFSerializableDate must have either format or encodingFormat specified");
            
            NSDateFormatter *dateFormatter = [self dateFormatterWithFormatString:dateFormat];
            decodedValue = [dateFormatter dateFromString:value];
        }
    }
    
    return decodedValue;
}


#pragma mark - Support methods

- (NSDateFormatter *)dateFormatterWithFormatString:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [_dateFormatters objectForKey:formatString];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = formatString;
        [_dateFormatters setObject:dateFormatter forKey:formatString];
    }
    
    return dateFormatter;
}

+ (id)jsonObjectForKeyPath:(NSString *)keyPath atJsonObject:(id)jsonObject {
    NSArray *keys = [keyPath componentsSeparatedByString:@"."];
    
    id nestedJsonObject = jsonObject;
    BOOL isSuccess = NO;
    NSMutableString *currentKeyPath = [[NSMutableString alloc] init];
    
    for (int index = 0; index < [keys count]; index++) {
        NSString *key = [keys objectAtIndex:index];
        if (currentKeyPath.length) {
            [currentKeyPath appendString:@"."];
        }
        [currentKeyPath appendString:key];
        
        isSuccess = (index == ([keys count] - 1));
        
        // Check invalid cases: number, string, null or null in array
        if ([nestedJsonObject isKindOfClass:[NSNumber class]]
            || [nestedJsonObject isKindOfClass:[NSString class]]
            || nestedJsonObject == [NSNull null]
            || ([nestedJsonObject isKindOfClass:[NSArray class]] && [nestedJsonObject count] == 1 && nestedJsonObject[0] == [NSNull null])) {
            nestedJsonObject = nil;
            
            SFLogWarning(@"Serialization failed because part ( %@ ) of serialization root ( %@ ) is not founded or equal nil", currentKeyPath, keyPath);
            break;
        }
        else {
            nestedJsonObject = [nestedJsonObject valueForKey:key];
        }
    }
    
    return nestedJsonObject;
}

@end
