//
//  SFXMLParser.h
//  SparkDAO
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


#import <Foundation/Foundation.h>
#import <Spark/SparkCore.h>

@class SFXMLElement;

typedef void (^parseHandler)(SFXMLElement *rootElement, NSError *error);

/**
 Main XML parser delegate object. Distributes the parsing of individual elements to different specialized objects.
 */
@interface SFXMLParser : SFObject <NSXMLParserDelegate, SFObjectPoolDelegate>

/**
 Starts the parsing of an xml data source.
 @param xmlData The data containing the xml document.
 @param completionBlock The completion handler block invoked after the parsing.
 */
+ (void)parseXMLData:(NSData * const)xmlData completion:(parseHandler)completionBlock;

/**
 Registers a class for parsing a given element.
 @param aParserClassName The registered class name.
 @param elementName The element name for the registered class.
 */
- (void)registerParserClassNamed:(NSString * const)aParserClassName forElementName:(NSString * const)elementName;

/**
 Returns wether the parser can have the SFXMLSpecificParser generic base parser to process xml elements for which there are no registered types. The default value returned is YES, you can override it in subclasses.
 @result The boolean value indicating if the specific parser can be used in general cases where there are no registered classes available.
 */
- (BOOL)canUseDefaultParser;

@end
