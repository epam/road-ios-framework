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

    Class class = [serializedObject class];
    xmlNodePtr result = [self createXMLNodeWithName:(serializationName ? serializationName : SFSerializationKeyForProperty(propertyInfo)) parent:parentNode objectClass:class];

    // Try to serialize as a container or object with defined properties. Assume it's simple value otherwise.
    if (![self serializeObjectAsContainer:serializedObject toNode:result] && ![self serializeObjectAsAttributed:serializedObject toNode:result]) {
        
            NSString *encodedObject = SFSerializationEncodeObjectForProperty(serializedObject, propertyInfo, _dateFormatter);
            xmlNodeSetContent(result, BAD_CAST [encodedObject UTF8String]);
        }
    
    return result;
}


#pragma mark -
- (xmlNodePtr)createXMLNodeWithName:(NSString *)serializationName parent:(xmlNodePtr)parentNode objectClass:(Class)class {
    
    const char *serializationNameC = ([serializationName length] > 0) ? [serializationName UTF8String] : SFAttributedXMLCoderTagForClass(class);
    NSParameterAssert(serializationNameC != NULL);
    
    return parentNode ? xmlNewChild(parentNode, NULL, BAD_CAST serializationNameC, NULL) : xmlNewNode(NULL, BAD_CAST serializationNameC);
}

- (BOOL)serializeObjectAsContainer:(id)serializedObject toNode:(xmlNodePtr)xmlNode {
    
    BOOL result = NO;
    Class class = [serializedObject class];

    BOOL isDictionary = [class isSubclassOfClass:[NSDictionary class]];
    BOOL isArray = [class isSubclassOfClass:[NSArray class]];
    
    if ((result = isArray || isDictionary)) {
        for (id item in serializedObject) {
            
            NSString *serializationName = (isDictionary && [item isKindOfClass:[NSString class]]) ? item : nil;
            [self serializeObject:isArray ? item : serializedObject[item] toXMLNode:xmlNode propertyInfo:nil serializationName:serializationName];
        }
    }
    
    return result;
}

- (BOOL)serializeObjectAsAttributed:(id)serializedObject toNode:(xmlNodePtr)xmlNode {

    BOOL result = NO;
    NSArray *properties = SFSerializationPropertiesForClass([serializedObject class]);
    
    if ((result = [properties count])) {
        for (SFPropertyInfo *property in properties) {
            SFXMLAttributes *xmlAttributes = [property attributeWithType:[SFXMLAttributes class]];
            
            if (xmlAttributes.isSavedInTag) {
                NSString *encodedString = SFSerializationEncodeObjectForProperty(serializedObject, property, _dateFormatter);
                
                if ([encodedString length]) {
                    xmlNewProp(xmlNode, BAD_CAST [SFSerializationKeyForProperty(property) UTF8String], BAD_CAST [encodedString UTF8String]);
                }
            }
            else {
                id propertyObject = [serializedObject valueForKey:[property propertyName]];
                [self serializeObject:propertyObject toXMLNode:xmlNode propertyInfo:property serializationName:nil];
            }
        }
    }
    
    return result;
}
@end
