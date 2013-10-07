//
//  SFXMLParsingTest.m
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


#import "SFXMLParsingTest.h"
#import "SFXMLElement.h"
#import "SFXMLModelParser.h"
#import "SFEntityElement.h"
#import "SFRelationshipElement.h"

@implementation SFXMLParsingTest {
    NSData *xmlData;
}

- (void)setUp {
    NSMutableString * const xmlString = [[NSMutableString alloc] init];
    [xmlString appendString:@"<ManagedObjectModel>"];
    [xmlString appendString:@"\n\t<Entity>"];
    [xmlString appendString:@"\n\t\t<Name>myEntity</Name>"];
    [xmlString appendString:@"\n\t\t<attributes>"];
    [xmlString appendString:@"\n\t\t\t<int>a</int>"];
    [xmlString appendString:@"\n\t\t\t<int>b</int>"];
    [xmlString appendString:@"\n\t\t\t<float>myFloat</float>"];
    [xmlString appendString:@"\n\t\t\t<string>myString</string>"];
    [xmlString appendString:@"\n\t\t</attributes>"];
    [xmlString appendString:@"\n\t\t<relationship>"];
    [xmlString appendString:@"\n\t\t\t<destination>"];
    [xmlString appendString:@"\n\t\t\t\t<name>otherEntity</name>"];
    [xmlString appendString:@"\n\t\t\t\t<property>album</property>"];
    [xmlString appendString:@"\n\t\t\t</destination>"];
    [xmlString appendString:@"\n\t\t\t<source>"];
    [xmlString appendString:@"\n\t\t\t\t<property>songs</property>"];
    [xmlString appendString:@"\n\t\t\t</source>"];
    [xmlString appendString:@"\n\t\t</relationship>"];
    [xmlString appendString:@"\n\t</entity>"];
    [xmlString appendString:@"\n</managedobjectmodel>"];
    
    xmlData = [xmlString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)tearDown {
    xmlData = nil;
}

- (void)testParsing {
    __block SFXMLElement *rootNode;
    [SFXMLModelParser parseXMLData:xmlData completion:^(SFXMLElement *rootElement, NSError *error) {
        rootNode = rootElement;
        
        SFEntityElement *childElement = [[rootElement children] SF_lastElementIfNotEmpty];
        STAssertTrue([childElement isMemberOfClass:[SFEntityElement class]], @"Wrong element(%@) instead of SFEntityElement", NSStringFromClass([childElement class]));
        
        SFRelationshipElement *relationshipElement = [childElement.relationships SF_lastElementIfNotEmpty];
        STAssertTrue([relationshipElement isMemberOfClass:[SFRelationshipElement class]], @"Wrong element(%@) instead of SFRelationshipElement", NSStringFromClass([relationshipElement class]));
    }];
    
    STAssertNotNil(rootNode, @"Assertion: rootnode is not nil, it is parsed correctly.");
}

@end
