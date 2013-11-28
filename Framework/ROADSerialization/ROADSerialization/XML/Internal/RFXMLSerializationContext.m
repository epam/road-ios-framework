//
//  RFXMLSerializationContext.h
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


#import "RFXMLSerializationContext.h"

static NSString const *kCurrentNode = @"currentNode";
static NSString const *kProperties = @"properties";
static NSString const *kCurrentNodeProperty = @"currentNodeProperty";
static NSString const *kElementName = @"elementName";
static NSString const *kElementSkipped = @"elementSkipped";
static NSString const *kSimpleValue = @"simpleValue";
static NSString const *kMutable = @"mutable";
static NSString const *kInSerializationContainer = @"inSerializationContainer";
static NSString const *kCurrentNodeClass = @"Class";
static NSString const *kItemTags = @"itemTags";
static NSString const *kCurrentVirtualTag = @"currentVirtualTag";


@interface RFXMLSerializationContext () {
    NSMutableArray *_stack;
}
@end

@implementation RFXMLSerializationContext

- (void)saveContext
{
    if (!_stack) _stack = [[NSMutableArray alloc] init];
    

    NSMutableDictionary *newRecord = [[NSMutableDictionary alloc] initWithCapacity:8];
    
    if (_currentNode) newRecord[kCurrentNode] = _currentNode;
    if (_properties) newRecord[kProperties] = _properties;
    if (_currentNodeProperty) newRecord[kCurrentNodeProperty] = _currentNodeProperty;
    if (_elementName) newRecord[kElementName] = _elementName;
    if (_currentNodeClass) newRecord[kCurrentNodeClass] = _currentNodeClass;
    if (_itemTags) newRecord[kItemTags] = _itemTags;
    if (_currentVirtualTag) newRecord[kCurrentVirtualTag] = _currentVirtualTag;

    newRecord[kElementSkipped] = @(_elementSkipped);
    newRecord[kSimpleValue] = @(_simpleValue);
    newRecord[kMutable] = @(_mutable);
    
    [_stack addObject:[newRecord copy]];
}

- (void)restoreContext {
    
    NSDictionary *record = [_stack count] ? [_stack lastObject] : nil;

    _currentNode = record[kCurrentNode];
    _currentNodeProperty = record[kCurrentNodeProperty];
    _properties = record[kProperties];
    _elementName = record[kElementName];
    _elementSkipped = [record[kElementSkipped] boolValue];
    _simpleValue = [record[kSimpleValue] boolValue];
    _mutable = [record[kMutable] boolValue];
    _currentNodeClass = record[kCurrentNodeClass];
    _itemTags = record[kItemTags];
    _currentVirtualTag = record[kCurrentVirtualTag];
    
    [_stack removeLastObject];
}

@end
