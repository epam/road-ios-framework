//
//  RFAttributedXMLCoder.h
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


#import "RFAttributedXMLCoder.h"
#import <ROAD/ROADReflection.h>

#import "RFSerializationAssistant.h"
#import "RFXMLSerializable.h"
#import "RFXMLSerializableCollection.h"

#include <libxml/parser.h>


char *RFAttributedXMLCoderTagForClass(Class aClass);


char *RFAttributedXMLCoderTagForClass(Class aClass) {
    char *result = NULL;
    
    if ([aClass isSubclassOfClass:[NSArray class]]) result = "array";
    else if ([aClass isSubclassOfClass:[NSDictionary class]]) result = "dictionary";
    else if ([aClass isSubclassOfClass:[NSDate class]]) result = "date";
    else if ([aClass isSubclassOfClass:[NSNumber class]]) result = "number";
    else if ([aClass isSubclassOfClass:[NSString class]]) result = "string";
    else result = "object";

    return result;
}


@interface RFAttributedXMLCoder () {
    xmlDocPtr _xmlDoc;
    NSArray * _xmlDateFormatters;
}
@end


@implementation RFAttributedXMLCoder

- (NSString *)encodeRootObject:(id)rootObject {
    
    xmlNodePtr xmlNode = [self serializeObject:rootObject toXMLNode:NULL precreatedNode:NULL propertyInfo:nil serializationName:nil itemTag:nil];
    _xmlDoc = xmlNewDoc(BAD_CAST "1.0");
    xmlChar *xmlBuff = NULL;
    int xmlBufferSize = 0;

    xmlDocSetRootElement(_xmlDoc, xmlNode);
    xmlDocDumpFormatMemory(_xmlDoc, &xmlBuff, &xmlBufferSize, 1);

    NSString *result = @((char*)xmlBuff);
    
    xmlFree(xmlBuff);
    xmlFreeDoc(_xmlDoc);
    _xmlDoc = NULL;
    
    return result;
}

- (xmlNodePtr)serializeObject:(id)serializedObject toXMLNode:(xmlNodePtr)parentNode precreatedNode:(xmlNodePtr)precreatedNode propertyInfo:(RFPropertyInfo*)propertyInfo serializationName:(NSString *)serializationName itemTag:(NSString *)itemTag {

    Class class = [serializedObject class];
    xmlNodePtr result = precreatedNode ? precreatedNode : [self createXMLNodeWithName:(serializationName ? serializationName : RFSerializationKeyForProperty(propertyInfo)) parent:parentNode objectClass:class];

    // Check if we want CDATA
    if ([class isSubclassOfClass:[NSData class]]) {
        xmlNodePtr cdataPtr = xmlNewCDataBlock(_xmlDoc, [serializedObject bytes], (int)[serializedObject length]);
        xmlAddChild( result, cdataPtr );
    }
    // Try to serialize as a container or object with defined properties. Assume it's simple value otherwise.
    else if (![self serializeObjectAsContainer:serializedObject toNode:result itemTag:itemTag] && ![self serializeObjectAsAttributed:serializedObject toNode:result]) {
        
            NSString *encodedString = RFSerializationEncodeObjectForProperty(serializedObject, propertyInfo, self);
            xmlNodeSetContent(result, BAD_CAST [encodedString UTF8String]);
        }
    
    return result;
}


#pragma mark -
- (xmlNodePtr)createXMLNodeWithName:(NSString *)serializationName parent:(xmlNodePtr)parentNode objectClass:(Class)class {
    
    const char *serializationNameC = ([serializationName length] > 0) ? [serializationName UTF8String] : RFAttributedXMLCoderTagForClass(class);
    NSParameterAssert(serializationNameC != NULL);
    
    return parentNode ? xmlNewChild(parentNode, NULL, BAD_CAST serializationNameC, NULL) : xmlNewNode(NULL, BAD_CAST serializationNameC);
}

- (BOOL)serializeObjectAsContainer:(id)serializedObject toNode:(xmlNodePtr)xmlNode itemTag:(NSString *)itemTag {
    
    Class class = [serializedObject class];

    BOOL isDictionary = [class isSubclassOfClass:[NSDictionary class]];
    BOOL isArray = [class isSubclassOfClass:[NSArray class]];
    BOOL result = isArray || isDictionary;

    if (result) {
        for (id item in serializedObject) {
            NSString *serializationName = [itemTag length] ? itemTag : ((isDictionary && [item isKindOfClass:[NSString class]]) ? item : nil);
            [self serializeObject:isArray ? item : serializedObject[item] toXMLNode:xmlNode precreatedNode:NULL propertyInfo:nil serializationName:serializationName itemTag:nil];
        }
    }
    
    return result;
}

- (BOOL)serializeObjectAsAttributed:(id)serializedObject toNode:(xmlNodePtr)xmlNode {

    NSArray *properties = RFSerializationPropertiesForClass([serializedObject class]);
    BOOL result = ([properties count] > 0);
    
    if (result) {
        for (RFPropertyInfo *property in properties) {

            RFXMLSerializable *xmlAttributes = [property attributeWithType:[RFXMLSerializable class]];
            id propertyObject = [serializedObject valueForKey:property.propertyName];
            
            if (xmlAttributes.isTagAttribute) {
                NSString *encodedString = RFSerializationEncodeObjectForProperty(propertyObject, property, self);
                
                if ([encodedString length]) {
                    xmlNewProp(xmlNode, BAD_CAST [RFSerializationKeyForProperty(property) UTF8String], BAD_CAST [encodedString UTF8String]);
                }
            }
            else {
                RFXMLSerializableCollection *collection = [property attributeWithType:[RFXMLSerializableCollection class]];
                [self serializeObject:propertyObject toXMLNode:xmlNode precreatedNode:collection ? xmlNode : NULL propertyInfo:property serializationName:nil itemTag:collection.itemTag];
            }
        }
    };
    
    return result;
}

@end
