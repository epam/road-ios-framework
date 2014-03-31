//
//  RFMutableObject.m
//  ROADCore
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


#import <objc/runtime.h>

#import <ROAD/ROADReflection.h>
#import "RFDynamicObject.h"


static const char * const RFMutableObjectSetterEncoding = "v@:@";
static const char * const RFMutableObjectGetterEncoding = "@@:";


@interface RFDynamicObject ()

/**
 * Creates a setter accessor name from the given string by attaching a set- prefix and a : postfix to the receiver's content.
 * @result The setter name.
 */
+ (NSString *)RF_stringByTransformingToSetterAccessor:(NSString *)string;

/**
 * Creates a getter accessor name from the receiver with the assumption it is a setter accessor method's name.
 * @result The getter name.
 */
+ (NSString *)RF_stringByTransformingToGetterAccessor:(NSString *)string;

@end


@implementation RFDynamicObject


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dynamicPropertyValues = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)valueForUndefinedKey:(NSString *)key {
    return _dynamicPropertyValues[key];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value == nil) {
        [_dynamicPropertyValues removeObjectForKey:key];
    }
    else {
        _dynamicPropertyValues[key] = value;
    }
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL result = YES;
    NSString * const getterName = [self RF_stringByTransformingToGetterAccessor:NSStringFromSelector(sel)];
    RFPropertyInfo * const desc = [self RF_propertyNamed:getterName];
    
    if ([desc isDynamic]) {
        SEL getter = sel_registerName([getterName cStringUsingEncoding:NSUTF8StringEncoding]);
        NSString * const setterName = [self RF_stringByTransformingToSetterAccessor:getterName];
        SEL setter = sel_registerName([setterName cStringUsingEncoding:NSUTF8StringEncoding]);
        
        const char *getterEncoding = RFMutableObjectGetterEncoding;
        IMP implementation = [self instanceMethodForSelector:@selector(genericValueGetter)];
        class_addMethod(self, getter, implementation, getterEncoding);
        
        const char *setterEncoding = RFMutableObjectSetterEncoding;
        implementation = [self instanceMethodForSelector:@selector(setGenericValueSetter:)];
        class_addMethod(self, setter, implementation, setterEncoding);
    }
    else {
        result = [super resolveInstanceMethod:sel];
    }
    
    return result;
}

- (void)setGenericValueSetter:(id)value {
    NSString * const key = [[self class] RF_stringByTransformingToGetterAccessor:NSStringFromSelector(_cmd)];
    [self setValue:value forUndefinedKey:key];
}

- (id)genericValueGetter {
    NSString * const key = NSStringFromSelector(_cmd);
    return [self valueForUndefinedKey:key];
}


static NSString * const kRFSetterNameFormat = @"set%@:";
static NSString * const kRFSetterPrefix = @"set";
static NSString * const kRFBooleanGetterPrefix = @"is";
static NSString * const kRFCaseTransformationFormat = @"%@%@%@";


#pragma mark - RFAccessorUtilities

+ (NSString *)RF_stringByTransformingToSetterAccessor:(NSString *)string {
    return [NSString stringWithFormat:kRFSetterNameFormat, [self RF_stringWithUpperCaseFirstCharacter:string]];
}

+ (NSString *)RF_stringByTransformingToGetterAccessor:(NSString *)string {
    NSString *result;
    
    if ([string hasPrefix:kRFSetterPrefix]) {
        result = [self RF_stringWithLowerCaseFirstCharacter:[string substringWithRange:NSMakeRange([kRFSetterPrefix length], [string length] - ([kRFSetterPrefix length] + 1))]];
    }
    else if ([string hasPrefix:kRFBooleanGetterPrefix]) {
        result = [self RF_stringWithLowerCaseFirstCharacter:[string substringWithRange:NSMakeRange([kRFBooleanGetterPrefix length], [string length] - ([kRFBooleanGetterPrefix length] + 1))]];
    }
    return result;
}

// Creates a string from the receiver by transforming its first letter character into upper case
+ (NSString *)RF_stringWithUpperCaseFirstCharacter:(NSString *)string {
    NSRange const range = [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    NSString * const subString = [[string substringWithRange:range] uppercaseString];
    NSString * const firstPart = [string substringToIndex:range.location];
    NSString * const lastPart = [string substringFromIndex:range.location + range.length];
    
    NSString * const result = [NSString stringWithFormat:kRFCaseTransformationFormat, firstPart, subString, lastPart];
    return result;
}

// Creates a string from the receiver by transforming its first letter character into lower case
+ (NSString *)RF_stringWithLowerCaseFirstCharacter:(NSString *)string {
    NSRange const range = [string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]];
    NSString * const subString = [[string substringWithRange:range] lowercaseString];
    NSString * const firstPart = [string substringToIndex:range.location];
    NSString * const lastPart = [string substringFromIndex:range.location + range.length];
    
    NSString * const result = [NSString stringWithFormat:kRFCaseTransformationFormat, firstPart, subString, lastPart];
    return result;
}


@end
