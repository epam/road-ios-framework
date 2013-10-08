//
//  SFAttributedXMLCoder.m
//  SparkSerialization
//
//  Created by Oleh Sannikov on 26.09.13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

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
