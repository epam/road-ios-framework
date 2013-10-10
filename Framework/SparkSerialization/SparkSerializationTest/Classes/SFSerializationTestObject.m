//
//  SFSerializationTestObject.m
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


#import "SFSerializationTestObject.h"
#import "SFAttributedXMLCoder.h"

static const NSTimeInterval kDateComparisonDelta = 1;

@implementation SFSerializationTestObject

- (BOOL)isEqual:(id)object
{
    BOOL result = (object == self);
    
    do {
        if (result) break;
        
        SFSerializationTestObject *pair = [object isKindOfClass:[self class]] ? object : nil;
        if (!pair) break;

        if (_boolean != pair.boolean) break;
        if (_integer != pair.integer) break;

        if ((_number != pair.number) && ![_number isEqualToNumber:pair.number]) break;

        if ((_string1 != pair.string1) && ![_string1 isEqualToString:pair.string1]) break;
        if ((_string2 != pair.string2) && ![_string2 isEqualToString:pair.string2]) break;
        if ((_date1 != pair.date1) && ([_date1 timeIntervalSinceDate:pair.date1] > kDateComparisonDelta)) break;
        if ((_date2 != pair.date2) && ([_date2 timeIntervalSinceDate:pair.date2] > kDateComparisonDelta)) break;
        if ((_unixTimestamp != pair.unixTimestamp) && ![_unixTimestamp isEqualToDate:pair.unixTimestamp]) break;
        
        if ((_strings != pair.strings) && ![_strings isEqualToArray:pair.strings]) break;

        if ((_subObjects != pair.subObjects) && ![_subObjects isEqualToArray:pair.subObjects]) break;
        if ((_subDictionary != pair.subDictionary) && ![_subDictionary isEqualToDictionary:pair.subDictionary]) break;
        
        result = YES;
        
      } while (0);
    
    return result;
}

- (NSUInteger)hash
{
    return (NSUInteger)self;
}

+ (SFSerializationTestObject*)sampleObject {
    
    SFSerializationTestObject *object3 = [[SFSerializationTestObject alloc] init];
    object3.string1 = @"value31";
    object3.string2 = @"value32";
    object3.integer = 5;
    
    SFSerializationTestObject *object4 = [[SFSerializationTestObject alloc] init];
    object4.string2 = @"value42";
    object4.string1 = @"value41";
    object4.number = @(3);
    
    SFSerializationTestObject *object = [[SFSerializationTestObject alloc] init];
    object.string1 = @"value1";
    object.string2 = @"value2";
    object.strings = @[@"value3", @"value4"];
    object.boolean = YES;
    object.subDictionary = @{@"object3" : object3};
    
    object.child = [[SFSerializationTestObject alloc] init];
    object.child.boolean = NO;
    object.child.string1 = @"value5";
    object.child.string2 = @"value6";
    object.child.strings = @[@"value7", @"value8"];
    object.child.subObjects = @[object3, object4];
    object.child.subDictionary = nil;
    object.date1 = [NSDate date];
    object.date2 = [NSDate dateWithTimeIntervalSinceNow:10000];
    object.unixTimestamp = [NSDate dateWithTimeIntervalSince1970:200000];
    
    return object;
}

@end
