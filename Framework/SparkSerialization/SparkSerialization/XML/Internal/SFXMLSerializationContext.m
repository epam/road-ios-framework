//
//  SFXMLSerializationContext.h
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


#import "SFXMLSerializationContext.h"

static NSString const* kCurrentNode = @"currentNode";
static NSString const* kProperties = @"properties";
static NSString const* kCurrentNodeProperty = @"currentNodeProperty";
static NSString const* kElementName = @"elementName";
static NSString const* kElementSkipped = @"elementSkipped";

@interface SFXMLSerializationContext () {
    NSMutableArray *_stack;
}
@end

@implementation SFXMLSerializationContext

- (void)saveContext
{
    if (!_stack) _stack = [[NSMutableArray alloc] init];
    
    if (_currentNode && _properties && _currentNodeProperty && kElementName) {
        
        [_stack addObject:@{kCurrentNode : _currentNode, kProperties : _properties, kCurrentNodeProperty : _currentNodeProperty, kElementName : _elementName, kElementSkipped : @(_elementSkipped)}];
    }
    else {
        
        NSMutableDictionary *newRecord = [[NSMutableDictionary alloc] initWithCapacity:4];
        
        if (_currentNode) newRecord[kCurrentNode] = _currentNode;
        if (_properties) newRecord[kProperties] = _properties;
        if (_currentNodeProperty) newRecord[kCurrentNodeProperty] = _currentNodeProperty;
        if (_elementName) newRecord[kElementName] = _elementName;

        newRecord[kElementSkipped] = @(_elementSkipped);
        
        [_stack addObject:[newRecord copy]];
    }
}

- (void)restoreContext {
    
    NSDictionary *record = [_stack count] ? [_stack lastObject] : nil;

    _currentNode = record[kCurrentNode];
    _currentNodeProperty = record[kCurrentNodeProperty];
    _properties = record[kProperties];
    _elementName = record[kElementName];
    _elementSkipped = [record[kElementSkipped] boolValue];
    
    [_stack removeLastObject];
}

@end
