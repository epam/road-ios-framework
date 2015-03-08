//
//  RFAnnotatedCoder.m
//  ROADSerialization
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


#import <ROAD/ROADReflection.h>
#import <ROAD/ROADCore.h>
#import "RFAttributedCoder.h"

#import "RFSerializationLog.h"
#import "RFSerializable.h"
#import "RFDerived.h"
#import "RFSerializableDate.h"
#import "RFSerializationCustomHandler.h"
#import "RFJSONSerializationHandling.h"
#import "RFSerializableBoolean.h"
#import "RFBooleanTranslator.h"
#import "RFSerializationAssistant.h"


@implementation RFAttributedCoder {
    NSString * _dateFormat;
    id _archive;
    NSString * _currentPath;
    RFObjectPool* _dateFormattersPool;
}


#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        _archive = [[NSMutableDictionary alloc] init];
        _dateFormattersPool = RFCreateDateFormatterPool();
    }
    
    return self;
}


#pragma mark - Encoding

+ (NSData *)encodedDataOfRootObject:(id)rootObject {
    return [self encodedDataOfRootObject:rootObject options:NSJSONWritingPrettyPrinted | NSJSONReadingAllowFragments error:nil];
}

+ (NSData *)encodedDataOfRootObject:(id)rootObject options:(NSJSONWritingOptions)options error:(NSError * __autoreleasing *)error {
    id serializableObject = [self encodeRootObjectToSerializableObject:rootObject];
    NSError *internalError = nil;
    id result = [NSJSONSerialization dataWithJSONObject:serializableObject options:options error:&internalError];
    if (internalError) {
        *error = internalError;
        RFSCLogError(@"ROADSerialization: Error when encoding object %@ :\n%@", rootObject, error);
    }

    return result;
}

+ (id)encodeRootObject:(id)rootObject options:(NSJSONWritingOptions)options error:(NSError *__autoreleasing *)error {
    NSData *data = [self encodedDataOfRootObject:rootObject options:options error:error];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)encodeRootObject:(id)rootObject {
    NSData *data = [self encodedDataOfRootObject:rootObject];    
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (id)encodeRootObjectToSerializableObject:(id)rootObject {
    RFSCLogInfo(@"Coder(%@ %p) started processing object(%@)", self, self, rootObject);
    
    RFAttributedCoder *coder = [[self alloc] init];
    coder->_archive = [coder encodeRootObject:rootObject];
    
    RFSCLogInfo(@"Coder(%@ %p) ended processing", self, self);
    
    return coder->_archive;
}

- (id)encodeRootObject:(id)rootObject {
    id archive;
    
    if ([rootObject isKindOfClass:[NSArray class]]) {
        archive = [self encodeArray:rootObject customHandlerAttribute:nil];
    }
    else if ([rootObject isKindOfClass:[NSDictionary class]]) {
        archive = [self encodeDictionary:rootObject customHandlerAttribute:nil];
    }
    else {
        RFSerializationCustomHandler *customHandlerAttribute = [[rootObject class] RF_attributeForClassWithAttributeType:[RFSerializationCustomHandler class]];
        if (customHandlerAttribute.handlerClass && customHandlerAttribute.key.length == 0) {
            archive = RFCustomSerialization(rootObject, customHandlerAttribute);
        }
        else {
            archive = [[NSMutableDictionary alloc] init];
            RFSerializable *serializableAttribute = [[rootObject class] RF_attributeForClassWithAttributeType:[RFSerializable class]];
            if (serializableAttribute && !serializableAttribute.classNameSerializationDisabled) {
                archive[RFSerializedObjectClassName] = NSStringFromClass([rootObject class]);
            }
            NSArray *properties = RFSerializationPropertiesForClass([rootObject class]);

            @autoreleasepool {
                [self fillDictionary:archive withProperties:properties rootObject:rootObject customHandlerAttribute:customHandlerAttribute];
            }
        }
    }
    
    return archive;
}

- (void)fillDictionary:(NSMutableDictionary *)archive withProperties:(NSArray *)properties rootObject:(id)rootObject customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    for (RFPropertyInfo * const aDesc in properties) {
        NSString *propertyName = [aDesc propertyName];
        id value = [rootObject valueForKey:propertyName];
        id encodedValue;
        
        if ([customHandlerAttribute.key isEqualToString:propertyName]) {
            encodedValue = RFCustomSerialization(value, customHandlerAttribute);
        }
        else {
            RFSerializationCustomHandler *propertyCustomHandlerAttribute = [aDesc attributeWithType:[RFSerializationCustomHandler class]];
            if (propertyCustomHandlerAttribute.handlerClass && propertyCustomHandlerAttribute.key.length == 0) {
                encodedValue = RFCustomSerialization(value, propertyCustomHandlerAttribute);
            }
            else {
                encodedValue = [self encodeValue:value forProperty:aDesc customHandlerAttribute:propertyCustomHandlerAttribute];
            }
            
        }
        
        NSString *key = RFSerializationKeyForProperty(aDesc);
        if (encodedValue != nil) {
            archive[key] = encodedValue;
        }
    }
}

- (id)encodeValue:(id)value forProperty:(RFPropertyInfo *)propertyInfo customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    id encodedValue = nil;

    // Custom preprocessing. Does not replace default handling
    if (customHandlerAttribute.encodingPreprocessor) {
        value = customHandlerAttribute.encodingPreprocessor(value);
    }

    if ([value isKindOfClass:[NSDate class]]) {
        encodedValue = RFSerializationEncodeDateForProperty(value, propertyInfo, _dateFormattersPool);
    }
    else if ([propertyInfo attributeWithType:[RFSerializableBoolean class]]) {
        encodedValue = [RFBooleanTranslator encodeTranslatableValue:value forProperty:propertyInfo];
    }
    else {
        encodedValue = [self encodeValue:value customHandlerAttribute:customHandlerAttribute];
    }
    
    return encodedValue;
}

- (id)encodeValue:(id)value customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    id encodedValue;
    
    if ([[value class] RF_attributeForClassWithAttributeType:[RFSerializable class]] || [[[value class] RF_propertiesWithAttributeType:[RFSerializable class]] count] > 0) {
        encodedValue = [self encodeRootObject:value];
    }
    else if ([value isKindOfClass:[NSArray class]]) {
        encodedValue = [self encodeArray:value customHandlerAttribute:customHandlerAttribute];
    }
    else if ([value isKindOfClass:[NSDictionary class]]) {
        encodedValue = [self encodeDictionary:value customHandlerAttribute:customHandlerAttribute];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        encodedValue = [value description];
    }
    else {
        encodedValue = value;
    }
    
    return encodedValue;
}

- (id)encodeArray:(NSArray *)anArray customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    NSMutableArray *array = [NSMutableArray array];
    
    for (id aValue in anArray) {
        [array addObject:[self encodeValue:aValue customHandlerAttribute:customHandlerAttribute]];
    }
    
    return [NSArray arrayWithArray:array];
}

- (id)encodeDictionary:(NSDictionary *)aDict customHandlerAttribute:(RFSerializationCustomHandler *)customHandlerAttribute {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (id aKey in aDict) {
        id aValue = aDict[aKey];
        if ([customHandlerAttribute.key isEqualToString:aKey]) {
            dict[aKey] = RFCustomSerialization(aValue, customHandlerAttribute);
        }
        else {
            dict[aKey] = [self encodeValue:aValue customHandlerAttribute:customHandlerAttribute];
        }
    }
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
