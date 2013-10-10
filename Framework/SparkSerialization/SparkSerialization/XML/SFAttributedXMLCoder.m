//
//  SFAttributedXMLCoder.h
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


#import "SFAttributedXMLCoder.h"
#import <Spark/SparkReflection.h>
#import "SFSerializable.h"
#import "SFSerializationAssistant.h"
#import "SFXMLAttributes.h"

#include <libxml/parser.h>

char *SFAttributedXMLCoderTagForClass(Class aClass)
{
    char *result = NULL;
    
    if ([aClass isSubclassOfClass:[NSArray class]]) result = "array";
    else if ([aClass isSubclassOfClass:[NSDictionary class]]) result = "dictionary";
    else if ([aClass isSubclassOfClass:[NSDate class]]) result = "date";
    else if ([aClass isSubclassOfClass:[NSNumber class]]) result = "number";
    else if ([aClass isSubclassOfClass:[NSString class]]) result = "string";
    else result = "object";

    return result;
}

@interface SFAttributedXMLCoder () {
    NSDateFormatter* _dateFormatter;
}
@end

@implementation SFAttributedXMLCoder

- (id)init {
    
    if (self = [super init]) {
        _dateFormatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

- (NSString *)encodeRootObject:(id)rootObject {
    
    xmlNodePtr xmlNode = [self serializeObject:rootObject toXMLNode:NULL propertyInfo:nil serializationName:nil];
    xmlDocPtr xmlDoc = xmlNewDoc(BAD_CAST "1.0");
    xmlChar *xmlBuff = NULL;
    int xmlBufferSize = 0;

    xmlDocSetRootElement(xmlDoc, xmlNode);
    xmlDocDumpFormatMemory(xmlDoc, &xmlBuff, &xmlBufferSize, 1);

    NSString *result = [NSString stringWithUTF8String:(char*)xmlBuff];
    
    xmlFree(xmlBuff);
    xmlFreeDoc(xmlDoc);
    
    return result;
}

- (xmlNodePtr)serializeObject:(id)serializedObject toXMLNode:(xmlNodePtr)parentNode propertyInfo:(SFPropertyInfo*)propertyInfo serializationName:(NSString *)serializationName {

    xmlNodePtr result = NULL;
    Class class = [serializedObject class];
    
    if (!serializationName) serializationName = SFSerializationKeyForProperty(propertyInfo);
    const char *serializationNameC = ([serializationName length] > 0) ? [serializationName UTF8String] : SFAttributedXMLCoderTagForClass(class);
    NSParameterAssert(serializationNameC != NULL);

    result = parentNode ? xmlNewChild(parentNode, NULL, BAD_CAST serializationNameC, NULL) : xmlNewNode(NULL, BAD_CAST serializationNameC);

    BOOL isDictionary = [class isSubclassOfClass:[NSDictionary class]];
    BOOL isArray = [class isSubclassOfClass:[NSArray class]];

    if (isArray || isDictionary) {
        for (id item in serializedObject) {
            
            NSString *serializationName = (isDictionary && [item isKindOfClass:[NSString class]]) ? item : nil;
            [self serializeObject:isArray ? item : serializedObject[item] toXMLNode:result propertyInfo:nil serializationName:serializationName];
        }
    }
    else {
        NSArray *properties = SFSerializationPropertiesForClass(class);
        
        if ([properties count]) {
            for (SFPropertyInfo *property in properties) {
                SFXMLAttributes *xmlAttributes = [property attributeWithType:[SFXMLAttributes class]];
                
                if (xmlAttributes.isSavedInTag) {
                    NSString *encodedString = SFSerializationEncodeObjectForProperty(serializedObject, property, _dateFormatter);
                    
                    if ([encodedString length]) {
                        xmlNewProp(result, BAD_CAST [SFSerializationKeyForProperty(property) UTF8String], BAD_CAST [encodedString UTF8String]);
                    }
                }
                else {
                    id propertyObject = [serializedObject valueForKey:[property propertyName]];
                    [self serializeObject:propertyObject toXMLNode:result propertyInfo:property serializationName:nil];
                }
            }
        }
        else {
            NSString *encodedObject = SFSerializationEncodeObjectForProperty(serializedObject, propertyInfo, _dateFormatter);
            // tag attributes or value?
            xmlNodeSetContent(result, BAD_CAST [encodedObject UTF8String]);
        }
    }
    
    return result;
}

@end
