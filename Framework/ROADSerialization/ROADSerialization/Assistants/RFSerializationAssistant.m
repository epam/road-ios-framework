//
//  RFSerializationAssistant.m
//  ROADSerialization
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

#import "RFSerializationAssistant.h"
#import <ROAD/ROADReflection.h>
#import <ROAD/ROADLogger.h>
#import "RFSerializable.h"
#import "RFDerived.h"
#import "RFSerializableCollection.h"
#import "RFSerializableDate.h"

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

id RFSerializationEncodeObjectForProperty(id object, RFPropertyInfo *propertyInfo, NSDateFormatter* dateFormatter) {
    id result = object;
    
    if ([object isKindOfClass:[NSDate class]]) {

        RFSerializableDate *serializableDateAttribute = [propertyInfo attributeWithType:[RFSerializableDate class]];
        if (!serializableDateAttribute) serializableDateAttribute = [propertyInfo.hostClass RF_attributeForProperty:propertyInfo.propertyName withAttributeType:[RFSerializableDate class]];
        
        if (serializableDateAttribute.unixTimestamp) {
            NSDate *date = object;
            result = [NSString stringWithFormat:@"%.0f", [date timeIntervalSince1970]];
        }
        else {
            NSString *dateFormat = ([serializableDateAttribute.encodingFormat length] > 0) ? serializableDateAttribute.encodingFormat : serializableDateAttribute.format;
            RFLogDebug(@"RFSerializableDate must have either defaultValue or encodingFormat specified : %@", dateFormat);
            
            if (![dateFormatter.dateFormat isEqualToString:dateFormat]) dateFormatter.dateFormat = dateFormat;
            result = [dateFormat length] ? [dateFormatter stringFromDate:object] : [object description];
        }
    }
    else if (![object isKindOfClass:[NSString class]]) {

        result = [object respondsToSelector:@selector(stringValue)] ? [object stringValue] : [object description];
    }
    
    return result;
}

