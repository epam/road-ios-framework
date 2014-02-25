//
//  RFXMLSerializationTestObject.m
//  ROADSerialization
//
//  Copyright (c) 2014 Epam Systems. All rights reserved.
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

#import "RFXMLSerializationTestObject.h"

@implementation RFXMLSerializationTestObject

+ (id)sampleObject {
    
    RFXMLSerializationTestObject *mary = [[RFXMLSerializationTestObject alloc] init];
    mary.name = @"Mary Doe";
    mary.age = 25;
    mary.city = @"Boyarka";
    
    RFXMLSerializationTestObject *chris = [[RFXMLSerializationTestObject alloc] init];
    chris.name = @"Chris Doe";
    chris.age = 13;
    chris.city = @"Boyarka";
    
    RFXMLSerializationTestObject *john = [[self alloc] init];
    john.name = @"John Doe";
    john.age = 54;
    john.city = @"Boyarka";
    john.children = @[mary, chris];
    
    john.string2 = @"value32";
    
    return john;
}

- (BOOL)isEqual:(id)object {
    
    return [object isMemberOfClass:[self class]] && [self isContentEqual:object];
}

- (BOOL)isContentEqual:(id)object {
    
    BOOL result = NO;

    if ([object isKindOfClass:[self class]]) {

        RFXMLSerializationTestObject *pair = object;
        
        result = (_name == pair.name) || [_name isEqualToString:pair.name];
        result &= (_city == pair.city) || [_city isEqualToString:pair.city];
        result &= (_age == pair.age);
        result &= (_children == pair.children || [_children isEqualToArray:pair.children]);
        result &= (_string2 == pair.string2) || [_string2 isEqualToString:pair.string2];
    }

    return result;
}

- (NSString *)nm {

    return @"http://itunes.apple.com/rss";
}

@end
