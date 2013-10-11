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
#import <ROAD/NSRegularExpression+RFROADExtension.h>
#import <ROAD/ROADReflection.h>
#import <ROAD/ROADLogger.h>
#import "RFXMLAttributes.h"
#import "RFSerializableDate.h"
#import "RFSerializable.h"
#import "RFDerived.h"
#import "RFXMLSerializationContext.h"
#import "RFSerializableCollection.h"
#import "RFSerializationAssistant.h"

#define kRFAttributedXMLDecoderDefaultContainerClass [NSArray class]

@interface RFAttributedXMLDecoder () <NSXMLParserDelegate> {
    NSXMLParser *_parser;
    RFXMLSerializationContext *_context;
    Class _rootNodeClass;
    
    NSNumberFormatter *_numberFormatter;
    NSDateFormatter *_dateFormatter;
    
    void (^completionHandler)(id rootObject, NSError *error);
    id _result;
}
@end

@implementation RFAttributedXMLDecoder

- (id)decodeData:(NSData *)xmlData withRootObjectClass:(Class)rootObjectClass {
    
    _result = nil;
    _context = [RFXMLSerializationContext new];
    _rootNodeClass = rootObjectClass;
    
    _parser = [[NSXMLParser alloc] initWithData:xmlData];
    _parser.delegate = self;
    
    [_parser parse];
    
    return _result;
}

#pragma marl - Parser Delegate
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    _parser = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    _parser = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    _context.elementSkipped = NO;
    
    // Check if container creation was delayed and return expected elementClass for current element in it
    Class elementClass = [self addContainerForElementWithNameIfNeeded:elementName];

    [_context saveContext];
    _context.simpleValue = YES; // assume that element is simple value by default
 
    if (!_context.elementSkipped) {
        
        //  top element
        if (!_result && !_context.elementName) {
            elementClass = _rootNodeClass;
        }
        
        NSArray *properties = RFSerializationPropertiesForClass(elementClass);
        NSDictionary *lazyProperties = [self processProperties:properties withElementAttributes:attributeDict andCreateElementIfNeeded:elementClass];
        
        _context.currentNodeProperty = [properties count] ? nil : _context.properties[elementName];
        _context.currentNodeClass = [properties count] ? Nil : kRFAttributedXMLDecoderDefaultContainerClass;
        _context.properties = [lazyProperties count] ? lazyProperties : nil;
        _context.elementName = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    NSString* contextElementName = _context.elementName;
    id element = _context.currentNode;
    BOOL isElementSkipped = _context.isElementSkipped;
    BOOL isSimpleValue = _context.isSimpleValue;

    [_context restoreContext];

    if (!isElementSkipped && !isSimpleValue) {
        NSParameterAssert (contextElementName == elementName);

        NSString* propertyName = [_context.properties[elementName] propertyName];
        [self setCurrentNodeValue:element forKey:propertyName ? propertyName : elementName];
    }
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
- (void)setCurrentNodeValue:(id)value forKey:(NSString *)key {
    
    id node = _context.currentNode;
    
    if ([node isKindOfClass:[NSArray class]]) {
        [node addObject:value];
    }
    else if ([node isKindOfClass:[NSDictionary class]]) {
        [node setObject:value forKey:key];
    }
    else {
        [node setValue:value forKey:key];
    }
    
//    RFLogDebug(@"RFAttributedXMLDecoder: setsValue:%@ forKey:%@", value, key);
}

- (id)convertString:(NSString *)string forProperty:(RFPropertyInfo *)property {
    
    id result = string;
    RFSerializableDate *dateAttribute = nil;
    NSString *attributeClassName = property.typeName;

    if ([attributeClassName isEqualToString:@"NSNumber"] || [attributeClassName isEqualToString:@"c"]) {

        if (!_numberFormatter) {
            _numberFormatter = [NSNumberFormatter new];
            [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        }
        
        result = [_numberFormatter numberFromString:string];
    }
    else if ([attributeClassName isEqualToString:@"NSDate"] || (dateAttribute = [property attributeWithType:[RFSerializableDate class]])) {
        
        if (dateAttribute.unixTimestamp) {
            result = [NSDate dateWithTimeIntervalSince1970:[string intValue]];
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
            
            RFLogWarning(@"RFAttributedXMLDecoder: Skipped missing property '%@'", elementName);
            _context.elementSkipped = YES;
        }
        result = elementProperty.typeClass;
    }

    return result;
}

- (NSDictionary *)processProperties:(NSArray *)properties withElementAttributes:(NSDictionary *)attributeDict andCreateElementIfNeeded:(Class)elementClass {
    
    NSMutableDictionary *lazyProperties = [NSMutableDictionary new];
    
    // Then property is a custom object and we want to init it now
    if ([properties count]) {
        
        id newElement = [[elementClass alloc] init];
        _context.currentNode = newElement;
        _context.simpleValue = NO;
        
        if (!_result) {
            _result = _context.currentNode;
        }
        
        for (RFPropertyInfo *property in properties) {
            
            RFXMLAttributes *xmlAttributes = [property attributeWithType:[RFXMLAttributes class]];
            NSString* serializationKey = RFSerializationKeyForProperty(property);
            
            if (xmlAttributes.isSavedInTag) {
                id decodedValue = [self convertString:attributeDict[serializationKey] forProperty:property];
                [_context.currentNode setValue:decodedValue forKey:property.propertyName];
            }
            else {
                lazyProperties[serializationKey] = property;
            }
        }
    }
    return [NSDictionary dictionaryWithDictionary:lazyProperties];
}

@end

