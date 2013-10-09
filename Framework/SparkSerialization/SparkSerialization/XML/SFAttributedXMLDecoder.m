//
//  SFAttributedXMLDecoder.h
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


#import "SFAttributedXMLDecoder.h"
#import <Spark/NSRegularExpression+SFSparkExtension.h>
#import <Spark/SparkReflection.h>
#import <Spark/SparkLogger.h>
#import "SFXMLAttributes.h"
#import "SFSerializableDate.h"
#import "SFSerializable.h"
#import "SFDerived.h"
#import "SFXMLSerializationContext.h"
#import "SFSerializableCollection.h"

@interface SFAttributedXMLDecoder () <NSXMLParserDelegate> {
    NSXMLParser *_parser;
    SFXMLSerializationContext *_context;
    Class _rootNodeClass;
    
    NSNumberFormatter *_numberFormatter;
    NSDateFormatter *_dateFormatter;
    
    void (^completionHandler)(id rootObject, NSError *error);
    id _result;
}
@end

@implementation SFAttributedXMLDecoder

- (void)decodeData:(NSData *)xmlData withRootObjectClass:(Class)rootObjectClass completionBlock:(void (^)(id rootObject, NSError *error))completionBlock {
    
    NSParameterAssert(!self.isParsing);
    
    completionHandler = completionBlock;
    
    _result = nil;
    _context = [SFXMLSerializationContext new];
    _rootNodeClass = rootObjectClass;
    
    _parser = [[NSXMLParser alloc] initWithData:xmlData];
    _parser.delegate = self;
    
    [_parser parse];
}

- (BOOL)isParsing {

    return (_parser != nil);
}

#pragma marl - Parser Delegate
- (void)parserDidEndDocument:(NSXMLParser *)parser {

    _parser = nil;
    completionHandler(_result, nil);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    _parser = nil;
    completionHandler(_result, parseError);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    Class elementClass = nil;
    _context.elementSkipped = NO;
    
    // Check for container and/or it's delayed creation
    BOOL isInArray = NO;
    BOOL isInDictionary = NO;
    if (!_context.properties) {
        
        SFSerializableCollection *collectionAttribute = nil;

        if (_context.currentNodeProperty) {
            
            //  We want to stay abstract which concrete class was requested
            _context.currentNode = [[[_context.currentNodeProperty.typeClass alloc] init] mutableCopy];
            collectionAttribute = [_context.currentNodeProperty attributeWithType:[SFSerializableCollection class]];
            _context.currentNodeProperty = nil;
        }
        
        // Find out the kind;
        isInArray = [_context.currentNode isKindOfClass:[NSArray class]];
        isInDictionary = [_context.currentNode isKindOfClass:[NSDictionary class]];
        
        elementClass = collectionAttribute.collectionClass ? collectionAttribute.collectionClass : [NSDictionary class];
    }
    else {
        
        SFPropertyInfo *elementProperty = _context.properties[elementName];
        if (!elementProperty) {
            
            SFLogWarning(@"SFAttributedXMLDecoder: Skipped missing property '%@'", elementName);
            _context.elementSkipped = YES;
        }
        elementClass = elementProperty.typeClass;
    }

    [_context saveContext];

    if (!_context.elementSkipped) {
        
        if (!_result) {
            elementClass = _rootNodeClass;
        }
        
        NSMutableDictionary *lazyProperties = [NSMutableDictionary new];
        NSArray *properties = [self propertiesForClass:elementClass];
        
        // Then property is a custom object and we want to init it now
        if ([properties count]) {
            
            id newElement = [[elementClass alloc] init];
            
            if (isInArray) {
                [_context.currentNode addObject:newElement];
            }
            else if (isInDictionary) {
                [_context.currentNode setObject:newElement forKey:elementName];
            }

            _context.currentNode = newElement;
            if (!_result) {
                _result = _context.currentNode;
            }
            
            for (SFPropertyInfo *property in properties) {
                
                SFXMLAttributes *xmlAttributes = [property attributeWithType:[SFXMLAttributes class]];
                
                if (xmlAttributes.isSavedInTag) {
                    id decodedValue = [self convertString:attributeDict[property.propertyName] forProperty:property];
                    [_context.currentNode setValue:decodedValue forKey:property.propertyName];
                }
                else {
                    lazyProperties[property.propertyName] = property;
                }
            }
        }

        _context.currentNodeProperty = [properties count] ? nil : _context.properties[elementName];
        _context.properties = [lazyProperties count] ? [NSDictionary dictionaryWithDictionary:lazyProperties] : nil;
        _context.elementName = elementName;
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    [_context restoreContext];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if (!_context.elementSkipped && [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0) {

        SFPropertyInfo *property = _context.currentNodeProperty;
        [self setCurrentNodeValue:[self convertString:string forProperty:property] forKey:property.propertyName ? property.propertyName : _context.elementName];
    }
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock {

    if (!_context.elementSkipped) {
        SFPropertyInfo *property = _context.currentNodeProperty;
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
    
    SFLogDebug(@"SFAttributedXMLDecoder: setsValue:%@ forKey:%@", value, key);
}

- (NSArray*)propertiesForClass:(Class)class {
    
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

- (id)convertString:(NSString *)string forProperty:(SFPropertyInfo *)property {
    
    id result = string;
    SFSerializableDate *dateAttribute = nil;
    NSString *attributeClassName = property.typeName;

    if ([attributeClassName isEqualToString:@"NSNumber"] || [attributeClassName isEqualToString:@"c"]) {

        if (!_numberFormatter) {
            _numberFormatter = [NSNumberFormatter new];
            [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        }
        
        result = [_numberFormatter numberFromString:string];
    }
    else if ([attributeClassName isEqualToString:@"NSDate"] || (dateAttribute = [property attributeWithType:[SFSerializableDate class]])) {
        
        if (dateAttribute.unixTimestamp) {
            result = [NSDate dateWithTimeIntervalSince1970:[string intValue]];
        }
        else {
            
            NSString *dateFormat = ([dateAttribute.decodingFormat length] == 0) ? dateAttribute.format : dateAttribute.decodingFormat;
            NSAssert(dateFormat, @"SFSerializableDate must have either format or encodingFormat specified");

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

@end

