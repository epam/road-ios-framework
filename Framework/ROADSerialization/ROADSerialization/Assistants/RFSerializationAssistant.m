//
//  RFSerializationAssistant.m
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
#import "RFSerializationAssistant.h"

#import "RFSerializationLog.h"
#import "RFSerializable.h"
#import "RFDerived.h"
#import "RFSerializableCollection.h"
#import "RFSerializableDate.h"
#import "RFJSONSerializationHandling.h"
#import "RFSerializableBoolean.h"
#import "RFBooleanTranslator.h"


NSString *RFSerializationKeyForProperty(RFPropertyInfo *propertyInfo) {
    
    RFSerializable *serializationAttribute = [propertyInfo attributeWithType:[RFSerializable class]];
    return ([serializationAttribute.serializationKey length] > 0) ? serializationAttribute.serializationKey : propertyInfo.propertyName;
}

NSString *RFSerializationCollectionItemClassNameForProperty(RFPropertyInfo *propertyInfo) {
    
    return NSStringFromClass([[propertyInfo attributeWithType:[RFSerializableCollection class]] collectionClass]);
}

NSArray *RFSerializationPropertiesForClass(Class class) {
    NSArray *result = nil;
    
    @autoreleasepool {
        if ([class RF_attributeForClassWithAttributeType:[RFSerializable class]]) {
            
            result = [[class RF_properties] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(RFPropertyInfo *evaluatedObject, NSDictionary *bindings) {
                return (![evaluatedObject attributeWithType:[RFDerived class]]);
            }]];
        }
        else {
            result = [class RF_propertiesWithAttributeType:[RFSerializable class]];
        }
    }
    
    return result;
}

// NOTE: Used by json and xml serialization
NSString *RFSerializationEncodeDateForProperty(NSDate *object, RFPropertyInfo *propertyInfo, RFObjectPool* dateFormatterPool) {
    NSString *result = nil;
    
    RFSerializableDate *serializableDateAttribute = [propertyInfo attributeWithType:[RFSerializableDate class]];
    if (!serializableDateAttribute) {
        serializableDateAttribute = [propertyInfo.hostClass RF_attributeForProperty:propertyInfo.propertyName withAttributeType:[RFSerializableDate class]];
    }
    
    if (serializableDateAttribute.unixTimestamp) {
        NSDate *date = object;
        result = [NSString stringWithFormat:@"%.0lf", [date timeIntervalSince1970] * serializableDateAttribute.unixTimestampMultiplier];
    }
    else {
        NSString *dateFormat = ([serializableDateAttribute.encodingFormat length] == 0) ? serializableDateAttribute.format : serializableDateAttribute.encodingFormat;
        NSDateFormatter *dateFormatter = dateFormatterPool[dateFormat];
        result = dateFormatter ? [dateFormatter stringFromDate:object] : [object description];
    }

    return result;
}

NSString *RFSerializationEncodeObjectForProperty(id object, RFPropertyInfo *propertyInfo) {
    
    id result = object;
    
    if ([propertyInfo attributeWithType:[RFSerializableBoolean class]]) {
        result = [RFBooleanTranslator encodeTranslatableValue:object forProperty:propertyInfo];
    }
    
    if (![result isKindOfClass:[NSString class]]) {
        result = [object respondsToSelector:@selector(stringValue)] ? [object stringValue] : [object description];
    }
    
    return result;
}

id RFCustomSerialization(id value, RFSerializationCustomHandler *customHandlerAttribute) {
    id encodedValue;
    id<RFJSONSerializationHandling> customSerializationHandler = [[customHandlerAttribute.handlerClass alloc] init];
    if ([customSerializationHandler respondsToSelector:@selector(encodeObject:)]) {
        encodedValue = [customSerializationHandler encodeObject:value];
    }
    else {
        RFSCLogWarn(@"Custom handler - %@ - was assigned, but it does not have appropriate encoding method!", NSStringFromClass(customHandlerAttribute.handlerClass));
    }
    
    return encodedValue;
}

id RFCustomDeserialization(id value, RFSerializationCustomHandler *customHandlerAttribute) {
    id decodedValue;
    id<RFJSONSerializationHandling> customSerializationHandler = [[customHandlerAttribute.handlerClass alloc] init];
    if ([customSerializationHandler respondsToSelector:@selector(decodeObject:)]) {
        decodedValue = [customSerializationHandler decodeObject:value];
    }
    else {
        RFSCLogWarn(@"Custom handler - %@ - was assigned, but it does not have appropriate decoding method!", NSStringFromClass(customHandlerAttribute.handlerClass));
    }
    
    return decodedValue;
}

RFObjectPool* RFCreateDateFormatterPool() {
    return
    [[RFObjectPool alloc] initWithClass:NSDateFormatter.class defaultObjectInitializer:^id(id objectCreated, id identifier) {
        NSCAssert([objectCreated isKindOfClass:NSDateFormatter.class], @"Check if the class of the object created is NSDateFormatter");
        NSCAssert([identifier isKindOfClass:NSString.class], @"Check if the identifier is a NSString");
        
        NSString* formatString = (NSString*)identifier;
        NSDateFormatter* formatter = (NSDateFormatter*)objectCreated;
        formatter.dateFormat = formatString;
        return formatter;
    }];
}
