//
//  SFSerializationAssistant.m
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

#import "SFSerializationAssistant.h"
#import <Spark/SparkReflection.h>
#import <Spark/SparkLogger.h>
#import "SFSerializable.h"
#import "SFDerived.h"
#import "SFSerializableCollection.h"
#import "SFSerializableDate.h"

NSString *SFSerializationKeyForProperty(SFPropertyInfo *propertyInfo) {
    
    SFSerializable *serializationAttribute = [propertyInfo attributeWithType:[SFSerializable class]];
    return ([serializationAttribute.serializationKey length] > 0) ? serializationAttribute.serializationKey : propertyInfo.propertyName;
}

NSString *SFSerializationCollectionItemClassNameForProperty(SFPropertyInfo *propertyInfo) {
    
    return NSStringFromClass([[propertyInfo attributeWithType:[SFSerializableCollection class]] collectionClass]);
}

NSArray *SFSerializationPropertiesForClass(Class class) {
    NSArray *result = nil;
    
    @autoreleasepool {
        if ([class SF_attributeForClassWithAttributeType:[SFSerializable class]]) {
            
            result = [[class SF_properties] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SFPropertyInfo *evaluatedObject, NSDictionary *bindings) {
                return (![evaluatedObject attributeWithType:[SFDerived class]]);
            }]];
        }
        else {
            result = [class SF_propertiesWithAttributeType:[SFSerializable class]];
        }
    }
    
    return result;
}

id SFSerializationEncodeObjectForProperty(id object, SFPropertyInfo *propertyInfo, NSDateFormatter* dateFormatter) {
    id result = object;
    
    if ([object isKindOfClass:[NSDate class]]) {

        SFSerializableDate *serializableDateAttribute = [propertyInfo attributeWithType:[SFSerializableDate class]];
        if (!serializableDateAttribute) serializableDateAttribute = [propertyInfo.hostClass SF_attributeForProperty:propertyInfo.propertyName withAttributeType:[SFSerializableDate class]];
        
        if (serializableDateAttribute.unixTimestamp) {
            NSDate *date = object;
            result = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
        }
        else {
            NSString *dateFormat = ([serializableDateAttribute.encodingFormat length] > 0) ? serializableDateAttribute.encodingFormat : serializableDateAttribute.format;
            SFLogDebug(@"SFSerializableDate must have either defaultValue or encodingFormat specified : %@", dateFormat);
            
            if (![dateFormatter.dateFormat isEqualToString:dateFormat]) dateFormatter.dateFormat = dateFormat;
            result = [dateFormat length] ? [dateFormatter stringFromDate:object] : [object description];
        }
    }
    else if (![object isKindOfClass:[NSString class]]) {

        result = [object respondsToSelector:@selector(stringValue)] ? [object stringValue] : [object description];
    }
    
    return result;
}

