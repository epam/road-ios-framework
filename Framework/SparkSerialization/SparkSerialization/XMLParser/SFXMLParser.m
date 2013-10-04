//
//  SFXMLParser.m
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


#import "SFXMLParser.h"
#import <Spark/SparkLogger.h>

#import "SFXMLParsing.h"
#import "SFXMLElement.h"
#import "SFXMLSpecificParser.h"

@implementation SFXMLParser {
    SFObjectPool * _pool;
    NSMutableArray * _parserStack;
    SFXMLElement * _rootElement;
}

+ (void)parseXMLData:(NSData * const)xmlData completion:(parseHandler)completionBlock {
    SFXMLParser * const parserDelegate = [[self alloc] init];
    NSXMLParser * const theParser = [[NSXMLParser alloc] initWithData:xmlData];
    theParser.delegate = parserDelegate;
    [theParser parse];
    completionBlock(parserDelegate->_rootElement, [theParser parserError]);
}

- (void)initialize {
    [super initialize];
    _parserStack = [[NSMutableArray alloc] init];
    _pool = [[SFObjectPool alloc] init];
    _pool.delegate = self;
}

- (void)registerParserClassNamed:(NSString * const)aParserClassName forElementName:(NSString * const)elementName {
    SFLogDebug(@"Parser(%@) are registered on element with name: %@", aParserClassName, elementName);
    [_pool registerClassNamed:aParserClassName forIdentifier:elementName];
}

- (id<SFXMLParsing>)parserForElementName:(NSString * const)elementName {
    id<SFXMLParsing> parser = [_pool objectForIdentifier:elementName];
    
    if (parser == nil && [self canUseDefaultParser]) {
        [_pool registerClassNamed:NSStringFromClass([SFXMLSpecificParser class]) forIdentifier:elementName];
        parser = [_pool objectForIdentifier:elementName];
    }
    
    return parser;
}

- (id<SFXMLParsing>)currentDelegate {
    return [_parserStack SF_lastElementIfNotEmpty];
}

- (BOOL)canUseDefaultParser {
    return YES;
}

#pragma mark - Pool delegate methods

- (void)pool:(SFObjectPool *const)pool didInstantiateObject:(const id<SFXMLParsing>)anObject forIdentifier:(NSString *const)anIdentifier {
    [anObject setParent:[self currentDelegate]];
}

- (void)pool:(SFObjectPool *const)pool didLendObject:(const id<SFXMLParsing>)anObject forIdentifier:(NSString *const)anIdentifier {
    [anObject setParent:[self currentDelegate]];
}


#pragma mark - Parsing delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    id<SFXMLParsing> aParser = [self parserForElementName:elementName];
    [_parserStack addObject:aParser];
    [aParser parser:parser didStartElement:elementName namespaceURI:namespaceURI qualifiedName:qName attributes:attributeDict];
    
    if (_rootElement == nil) {
        _rootElement = [aParser element];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [[self currentDelegate] parser:parser foundCharacters:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    [[self currentDelegate] parser:parser didEndElement:elementName namespaceURI:namespaceURI qualifiedName:qName];
    [_parserStack removeLastObject];
}

@end
