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
#include <libxml/parser.h>
#import "SFSerializable.h"
#import <Spark/SparkReflection.h>

static char* kSFAttributedXMLDefaultTagArray = "array";
static char* kSFAttributedXMLDefaultTagDictionary = "dictionary";
static char* kSFAttributedXMLDefaultTagNumber = "number";
static char* kSFAttributedXMLDefaultTagDate = "date";

char* SFAttributedXMLCoderTagForClass(Class aClass)
{
    char* result = NULL;
    
    if ([aClass isSubclassOfClass:[NSArray class]])
        result = kSFAttributedXMLDefaultTagArray;
    else if ([aClass isSubclassOfClass:[NSDictionary class]])
        result = kSFAttributedXMLDefaultTagDictionary;
    else if ([aClass isSubclassOfClass:[NSDate class]])
        result = kSFAttributedXMLDefaultTagDate;
    else if ([aClass isSubclassOfClass:[NSNumber class]])
        result = kSFAttributedXMLDefaultTagNumber;
    
    return result;
}

@implementation SFAttributedXMLCoder

- (NSString*)encodeRootObject:(id)rootObject
{
    xmlNodePtr xmlNode = [self serializeObject:rootObject toXMLNode:NULL propertyInfo:nil];
    xmlDocPtr xmlDoc = xmlNewDoc(BAD_CAST "1.0");
    xmlChar *xmlBuff = NULL;
    int xmlBufferSize = 0;

    xmlDocSetRootElement(xmlDoc, xmlNode);
    xmlDocDumpFormatMemory(xmlDoc, &xmlBuff, &xmlBufferSize, 1);

    NSString* result = [NSString stringWithUTF8String:(char*)xmlBuff];
    
    xmlFree(xmlBuff);
    xmlFreeDoc(xmlDoc);
    
    return result;
}

- (xmlNodePtr)serializeObject:(id)object toXMLNode:(xmlNodePtr)parentNode propertyInfo:(SFPropertyInfo*)propertyInfo
{
//    NSParameterAssert((parentNode && !propertyInfo) || (!parentNode && propertyInfo));
    
    xmlNodePtr result = NULL;
    
    Class class = [object class];
    BOOL isDictionary = [class isSubclassOfClass:[NSDictionary class]];
    BOOL isContainer = isDictionary || [class isSubclassOfClass:[NSArray class]];

    if (isContainer)
    {
        if (!parentNode)
        {
            const char* nodeName = SFAttributedXMLCoderTagForClass(class);
            result = parentNode = xmlNewNode(NULL, BAD_CAST nodeName);
            propertyInfo = nil;
        }
        
        for (id child in object)
        {
            if (isDictionary)
                [self serializeObject:child toXMLNode:parentNode propertyInfo:NULL];
        }

    }
    
//    NSArray* serializableProperties = [objClass SF_attributeForClassWithAttributeType:[SFSerializable class]];
    return result;
}

#pragma mark -
#if 0

- (xmlNodePtr)xmlTreeWithRootObject:(id)root
{
    const char* nodeName = [root isKindOfClass:[NSArray class]] ? kSFAttributedXMLDefaultArrayTag : ([root isKindOfClass:[NSDictionary class]] ? kSFAttributedXMLDefaultDictionaryTag : NULL);
    
    xmlNodePtr node = nodeName ? xmlNewNode(NULL, BAD_CAST nodeName) : NULL;

    if (node)
    {
        [self serializeContainer:root toXMLNode:node];
    }
    else
        node = [self serializeObject:root toXMLNode:node];
    
    return node;
}

- (xmlNodePtr)serializeObject:(id)object toXMLNode:(BOOL)toXMLNode storeAsAttribute:(BOOL)storeAsAttribute
{
    Class objClass = [object class];
    NSString* serializationKey = [objClass SF_attributeForClassWithAttributeType:[SFSerializable class]];
    NSString* serializedValue = nil;
    
    if ([objClass isSubclassOfClass:[NSValue class]])
    {
        serializedValue = [object stringValue];
        
        
        
    }
    
    
}

- (void)serializeContainer:(id)container toXMLNode:(xmlNodePtr)node
{
}


    //    xmlNodeSetContent(node, BAD_CAST "content");

    if ([rootObject isKindOfClass:[NSArray class]])
    {
        self.archive = [self encodeArray:rootObject];
    } else if ([rootObject isKindOfClass:[NSDictionary class]]) {
        self.archive = [self encodeDictionary:rootObject];
    }
    else {
        [self.archive setObject:NSStringFromClass([rootObject class]) forKey:SFSerializedObjectClassName];
        NSArray *properties;
        @autoreleasepool {
            Class rootObjectClass = [rootObject class];
            
            if ([rootObjectClass SF_attributeForClassWithAttributeType:[SFSerializable class]]) {
                properties = [[rootObjectClass SF_properties] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SFPropertyInfo *evaluatedObject, NSDictionary *bindings) {
                    return (![evaluatedObject attributeWithType:[SFDerived class]]);
                }]];
            }
            else {
                properties = [rootObjectClass SF_propertiesWithAttributeType:[SFSerializable class]];
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
        
    return node;
}
#endif


@end
