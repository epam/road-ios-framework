//
//  RFAttributedXMLDecoder.h
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


#import "RFAttributedXMLDecoder.h"
#import <ROAD/NSRegularExpression+RFExtension.h>
#import <ROAD/ROADReflection.h>

#import "RFSerializationLog.h"
#import "RFXMLSerializable.h"
#import "RFSerializableBoolean.h"
#import "RFSerializableDate.h"
#import "RFDerived.h"
#import "RFXMLSerializationContext.h"
#import "RFSerializableCollection.h"
#import "RFSerializationAssistant.h"
#import "RFXMLSerializableCollection.h"
#import "RFBooleanTranslator.h"

#define kRFAttributedXMLDecoderDefaultContainerClass [NSArray class]

@interface RFAttributedXMLDecoder () <NSXMLParserDelegate> {
    NSXMLParser *_parser;
    RFXMLSerializationContext *_context;
    Class _rootNodeClass;
    
    NSNumberFormatter *_numberFormatter;
    NSDateFormatter *_dateFormatter;
    
    void (^completionHandler)(id rootObject, NSError *error);
    id _result;
    
    NSError *_parseError;
}

@end

@implementation RFAttributedXMLDecoder

- (id)decodeData:(NSData *)xmlData withRootObjectClass:(Class)rootObjectClass error:(NSError * __autoreleasing *)error {
    
    _result = nil;
    _context = [RFXMLSerializationContext new];
    _rootNodeClass = rootObjectClass;
    
    _parser = [[NSXMLParser alloc] initWithData:xmlData];
    _parser.delegate = self;
    _parseError = nil;
    
    [_parser parse];
    
    _parser.delegate = nil;
    _parser = nil;
    
    if (error)
        *error = _parseError;
    
    return _result;
}


#pragma mark - Parser Delegate


- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    _parseError = parseError;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    NSParameterAssert(elementName);

    // Check if there is some virtual tag already open
    if (![_context.currentVirtualTag isEqualToString:_context.itemTags[elementName]]) {
        
        NSString *itemContainerTag = _context.itemTags[elementName];
        
        if (_context.currentVirtualTag) {
            // Close current tag and open new
            NSString *currentVirtualTag = _context.currentVirtualTag;
            _context.currentVirtualTag = nil;
            [self parser:parser didEndElement:currentVirtualTag namespaceURI:namespaceURI qualifiedName:qName];
        }
        
        if (itemContainerTag) {
            // Add virtual tag with the name extracted from serializationContainer attribute
            id itemTags = _context.itemTags;
            [self parser:parser didStartElement:itemContainerTag namespaceURI:namespaceURI qualifiedName:qName attributes:nil];
            _context.currentVirtualTag = itemContainerTag;
            _context.itemTags = itemTags;
        }
    }
    
    _context.elementSkipped = NO;
    
    // Check if container creation was delayed and return expected elementClass for current element in it
    Class elementClass = [self addContainerForElementWithNameIfNeeded:elementName];

    [_context saveContext];
    _context.simpleValue = YES; // assume that element is simple value by default
    _context.currentVirtualTag = nil;
 
    if (!_context.elementSkipped) {
        
        //  top element
        if (!_result && !_context.elementName) elementClass = _rootNodeClass;
        _context.elementName = elementName;

        // Get properties for element Class and process attributeDict, probably containing some of them
        [self processProperties:RFSerializationPropertiesForClass(elementClass) withElementAttributes:attributeDict andCreateElementIfNeeded:elementClass];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSString *contextElementName = _context.elementName;
    id element = _context.currentNode;
    BOOL isElementSkipped = _context.isElementSkipped;
    BOOL isSimpleValue = _context.isSimpleValue;
    NSString *currentVirtualTag = _context.currentVirtualTag;

    [_context restoreContext];

    if (!isElementSkipped && !isSimpleValue) {
        if (!currentVirtualTag) NSParameterAssert(contextElementName == elementName);

        NSString *propertyName = [_context.properties[contextElementName] propertyName];
        [self setCurrentNodeValue:element forKey:propertyName ? propertyName : contextElementName];
    }

    if (currentVirtualTag)
        [self parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!_context.elementSkipped && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {

        RFPropertyInfo *property = _context.currentNodeProperty;
        [self setCurrentNodeValue:[self convertString:string forProperty:property] forKey:property.propertyName ? property.propertyName : _context.elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {

    if (!_context.elementSkipped) {
        RFPropertyInfo *property = _context.currentNodeProperty;
        [self setCurrentNodeValue:CDATABlock forKey:property.propertyName ? property.propertyName : _context.elementName];
    }
}

#pragma mark -
- (void)setCurrentNodeValueToCustomObject:(id)value forKey:(NSString *)key {

    id node = _context.currentNode;
    id existingValue = [node valueForKey:key];
    id newValue = value;
    
    if (existingValue) {
        if ([newValue isKindOfClass:[NSArray class]] && [existingValue isKindOfClass:[NSArray class]]) newValue = [existingValue arrayByAddingObjectsFromArray:newValue];
        else if ([newValue isKindOfClass:[NSDictionary class]] && [existingValue isKindOfClass:[NSDictionary class]]) {
            existingValue = [existingValue mutableCopy];
            [existingValue addEntriesFromDictionary:newValue];
            newValue = [existingValue copy];
        }
        else if ([newValue isKindOfClass:[NSSet class]] && [existingValue isKindOfClass:[NSSet class]]) newValue = [existingValue setByAddingObjectsFromSet:value];
    }
    else if (_context.mutable) newValue = [newValue copy];
    
    if ([self isValueValid:newValue forProperty:_context.currentNodeProperty]) {
        [node setValue:newValue forKey:key];
    }
}

- (void)setCurrentNodeValue:(id)value forKey:(NSString *)key {
    
    id node = _context.currentNode;
    
    if ([node isKindOfClass:[NSArray class]]) {
        [node addObject:value];
    }
    else if ([node isKindOfClass:[NSDictionary class]]) {
        node[key] = value;
    }
    else {
        [self setCurrentNodeValueToCustomObject:value forKey:key];
    }

}

/**
 Determines if the value is primitive and has the nil or NSNull value to avoid crashes from setting nil or NSNull value to a primitive
 
 @param value the value to be set
 @param propertyInfo the property information where the value should be set
 @return YES if the value can be safely set
 */
- (BOOL)isValueValid:(id const)value forProperty:(RFPropertyInfo *)propertyInfo {
    return ((value && value != [NSNull null]) || ![[propertyInfo typeName] isEqualToString:@"c"]);
}

- (NSDate *)dateFromString:(NSString *)string withDateAttribute:(RFSerializableDate *)dateAttribute {
    NSDate *result = nil;
    
    if (dateAttribute.unixTimestamp) {
        result = [NSDate dateWithTimeIntervalSince1970:[string intValue] / dateAttribute.unixTimestampMultiplier];
    }
    else {
        
        NSString *dateFormat = ([dateAttribute.decodingFormat length] == 0) ? dateAttribute.format : dateAttribute.decodingFormat;
        NSAssert(dateFormat, @"RFSerializableDate must have either format or encodingFormat specified");
        
        if (!_dateFormatter) {
            _dateFormatter = [[NSDateFormatter alloc] init];
        }
        
        if (![dateFormat isEqualToString:_dateFormatter.dateFormat]) {
            _dateFormatter.dateFormat = dateFormat;
        }
        
        result = [_dateFormatter dateFromString:string];
    }
    
    return result;
}

- (id)convertString:(NSString *)string forProperty:(RFPropertyInfo *)property {
    
    id result = string;
    RFSerializableDate *dateAttribute = nil;
    NSString *attributeClassName = property.typeName;

    if ([property attributeWithType:[RFSerializableBoolean class]]) {
        result = [RFBooleanTranslator decodeTranslatableValue:string forProperty:property];
    }
    if ([attributeClassName isEqualToString:@"NSNumber"] || [attributeClassName isEqualToString:@"c"]) {

        if (!_numberFormatter) {
            _numberFormatter = [NSNumberFormatter new];
            [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        }
        
        result = [_numberFormatter numberFromString:string];
    }
    else if ([attributeClassName isEqualToString:@"NSDate"] || (dateAttribute = [property attributeWithType:[RFSerializableDate class]])) {
        
        result = [self dateFromString:string withDateAttribute:dateAttribute];
        
    }
    
    return result;
}

- (Class)addContainerForElementWithNameIfNeeded:(NSString*)elementName {
    Class result = Nil;
    
    if (!_context.properties) {
        
        if (_context.currentNodeClass) {
            
            //  We want to stay abstract which concrete class was requested
            id containerNode = [[[_context.currentNodeProperty.typeClass ? _context.currentNodeProperty.typeClass : _context.currentNodeClass alloc] init] mutableCopy];
            
            _context.currentNode = containerNode;
            _context.simpleValue = NO;
            _context.mutable = YES;
            
            if (!_result) {
                _result = _context.currentNode;
            }
            
            _context.currentNodeClass = Nil;
        }
        
        RFSerializableCollection *collectionAttribute = [_context.currentNodeProperty attributeWithType:[RFSerializableCollection class]];
        result = collectionAttribute.collectionClass;
    }
    else {
        
        RFPropertyInfo *elementProperty = _context.properties[elementName];
        if (!elementProperty) {
            
            RFSCLogWarn(@"RFAttributedXMLDecoder: Skipped missing property '%@'", elementName);
            _context.elementSkipped = YES;
        }
        result = elementProperty.typeClass;
    }

    return result;
}

- (void)processProperty:(RFPropertyInfo *)property withElementAttributes:(NSDictionary *)attributeDict lazyProperties:(NSMutableDictionary * __autoreleasing *)lazyProperties itemTags:(NSMutableDictionary * __autoreleasing *)itemTags {

    RFXMLSerializable *xmlAttributes = [property attributeWithType:[RFXMLSerializable class]];
    NSString *serializationKey = RFSerializationKeyForProperty(property);
    
    if (xmlAttributes.isTagAttribute) {
        id decodedValue = [self convertString:attributeDict[serializationKey] forProperty:property];
        [_context.currentNode setValue:decodedValue forKey:property.propertyName];
    }
    else {
        NSParameterAssert(lazyProperties && itemTags);
        
        if (!*lazyProperties) *lazyProperties = [[NSMutableDictionary alloc] init];
        (*lazyProperties)[serializationKey] = property;
        
        // store tags associated with collections in context for future tag processing
        RFXMLSerializableCollection *collection = [property attributeWithType:[RFXMLSerializableCollection class]];
        if (collection ) {
            if (!*itemTags) *itemTags = [[NSMutableDictionary alloc] init];
            (*itemTags)[collection.itemTag] = serializationKey;
        }
    }
}

- (void)processProperties:(NSArray *)properties withElementAttributes:(NSDictionary *)attributeDict andCreateElementIfNeeded:(Class)elementClass {
    
    // If there are no properties in tag we suppose notation of kind <tag>value</tag>
    _context.currentNodeProperty = [properties count] ? nil : _context.properties[_context.elementName];
    _context.currentNodeClass = [properties count] ? Nil : kRFAttributedXMLDecoderDefaultContainerClass;

    NSMutableDictionary *lazyProperties = nil;
    NSMutableDictionary *itemTags = nil;
    
    // Then property is a custom object and we want to init it now
    if ([properties count]) {

        id newElement = [[elementClass alloc] init];
        _context.currentNode = newElement;
        _context.simpleValue = NO;
        _context.mutable = NO;
        
        if (!_result) _result = _context.currentNode;
        
        for (RFPropertyInfo *property in properties) {
            [self processProperty:property withElementAttributes:attributeDict lazyProperties:&lazyProperties itemTags:&itemTags];
        }

    }

    _context.properties = [lazyProperties count] ? [NSDictionary dictionaryWithDictionary:lazyProperties] : nil;
    _context.itemTags = [itemTags count] ? [NSDictionary dictionaryWithDictionary:itemTags] : nil;

}

@end

