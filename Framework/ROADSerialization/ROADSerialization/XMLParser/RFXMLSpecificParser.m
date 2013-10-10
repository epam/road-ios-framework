//
//  RFXMLSpecificParser.m
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


#import "RFXMLSpecificParser.h"
#import "RFXMLElement.h"
#import <ROAD/ROADReflection.h>
#import <ROAD/ROADLogger.h>

static NSString * const kRFElementName = @"element";

@implementation RFXMLSpecificParser {
    NSMutableArray *children;
}

- (void)initialize {
    [super initialize];
    children = [[NSMutableArray alloc] init];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [self allocateElement];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [_parent childDidFinishParsing:self];
    [self repool];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    [self allocateElement];
    RFLogInfo(@"Parser(%p) found element with name: %@", parser, elementName);
    _element.name = elementName;
    NSMutableDictionary * const attributeMutableDictionary = [[NSMutableDictionary alloc] init];

    // transforming key names to all-lowercase
    for (NSString * const aKey in attributeDict) {
        NSString * const aValue = attributeDict[aKey];
        NSString * const newKey = [aKey lowercaseString];
        attributeMutableDictionary[newKey] = aValue;
    }
    
    _element.attributes = [NSDictionary dictionaryWithDictionary:attributeMutableDictionary];
    [_parent.element addChild:_element];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [_element appendString:string];
}

- (void)addChild:(const id<RFXMLParsing>)aChild {
    [children addObject:aChild];
}

- (NSArray *)children {
    return [NSArray arrayWithArray:children];
}

- (void)childDidFinishParsing:(const id<RFXMLParsing>)aChild {
}

- (void)allocateElement {
    RFPropertyInfo * const prop = [self RF_propertyNamed:kRFElementName];
    __unsafe_unretained const Class elementClass = prop.typeClass;
    _element = [[elementClass alloc] init];
}

@end
