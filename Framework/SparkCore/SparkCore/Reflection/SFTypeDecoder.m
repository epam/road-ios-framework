//
//  SFEncodingMapper.m
//  SparkReflection
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


#import "SFTypeDecoder.h"

static NSString * const kSFEncodingMapFile = @"SFEncoding";
static NSString * const kSFPlistExtension = @"plist";
static NSString * const kSFPointerFormat = @"%@ *";
static NSString * const kSFArrayFormat = @"%@[]";
static NSString * const kSFBitfieldFormat = @"bitfield(%@)";
static NSString * const kSFUnionFormat = @"union %@";
static NSString * const kSFStructFormat = @"struct %@";
static NSString * const kSFFixedArrayFormat = @"%@[%ld]";
static NSDictionary *kSFMapDictionary;

static NSString * const kSFObjectTypeEncoding = @"@\"";
static NSString * const kSFArrayEncoding = @"[]";
static NSString * const kSFBitFieldEncoding = @"b";
static NSString * const kSFStructEncoding = @"{}";
static NSString * const kSFUnionEncoding = @"()";
static NSString * const kSFAssignmentOperator = @"=";
static NSString * const kSFPointerToTypeEncoding = @"^";
static NSString * const kSFDereferenceOperator = @"*";

@interface SFTypeDecoder ()

+ (NSCharacterSet *)SF_pointerCharacterSet;
+ (NSCharacterSet *)SF_objectTypeEncodingCharacterSet;
+ (NSCharacterSet *)SF_valueTypePointerEncodingCharacterSet;
+ (NSCharacterSet *)SF_structEncodingCharacterSet;
+ (NSCharacterSet *)SF_unionEncodingCharacterSet;
+ (NSCharacterSet *)SF_bitFieldEncodingCharacterSet;
+ (NSCharacterSet *)SF_arrayEncodingCharacterSet;
+ (NSCharacterSet *)SF_fixedArrayEncodingCharacterSet;
+ (BOOL)SF_isPrefix:(NSCharacterSet *)prefixSet inString:(NSString *)string;

@end

@implementation SFTypeDecoder

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * const path = [[NSBundle bundleForClass:self] pathForResource:kSFEncodingMapFile ofType:kSFPlistExtension];
        kSFMapDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    });
}

+ (NSString *)nameFromTypeEncoding:(NSString *)encoding {
    NSString *result;
    
    if ([encoding length] == 1) {
        result = kSFMapDictionary[encoding];
    }
    else if ([self SF_isPrefix:[self SF_objectTypeEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kSFPointerFormat, [encoding stringByTrimmingCharactersInSet:[self SF_objectTypeEncodingCharacterSet]]];
    }
    else if ([self SF_isPrefix:[self SF_valueTypePointerEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kSFPointerFormat, [self nameFromTypeEncoding:[encoding stringByTrimmingCharactersInSet:[self SF_valueTypePointerEncodingCharacterSet]]]];
    }
    else if ([self SF_isPrefix:[self SF_arrayEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kSFArrayFormat, [self nameFromTypeEncoding:[encoding stringByTrimmingCharactersInSet:[self SF_arrayEncodingCharacterSet]]]];
    }
    else if ([self SF_isPrefix:[self SF_bitFieldEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kSFBitfieldFormat, [encoding stringByTrimmingCharactersInSet:[self SF_bitFieldEncodingCharacterSet]]];
    }
    else if ([self SF_isPrefix:[self SF_structEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kSFStructFormat, [encoding stringByTrimmingCharactersInSet:[self SF_structEncodingCharacterSet]]];
    }
    else if ([self SF_isPrefix:[self SF_unionEncodingCharacterSet] inString:encoding]) {
        result = [NSString stringWithFormat:kSFUnionFormat, [encoding stringByTrimmingCharactersInSet:[self SF_unionEncodingCharacterSet]]];
    }
    else if ([self SF_isPrefix:[NSCharacterSet decimalDigitCharacterSet] inString:encoding] && [encoding rangeOfCharacterFromSet:[self SF_valueTypePointerEncodingCharacterSet]].location != NSNotFound) {
        // in case the encoding is a fixed size c-style array, then the numbers preceding the '^' sign is the length of it
        // the long casts are required for the %ld format specifier, which in turn is needed for the mac-compatibility, where NSInteger is long instead of int.
        NSInteger arraySize = 0;
        [[NSScanner scannerWithString:encoding] scanInteger:&arraySize];
        NSString * const typeEncoding = [encoding stringByTrimmingCharactersInSet:[self SF_fixedArrayEncodingCharacterSet]];
        NSString * const type = [self nameFromTypeEncoding:typeEncoding];
        result = [NSString stringWithFormat:kSFFixedArrayFormat, type, (long)arraySize];
    }
    
    if ([result length] == 0) {
        // in case no match is found, a fail-safe solution is to keep the encoding itself
        result = [encoding copy];
    }
    
    return result;
}

+ (NSCharacterSet *)SF_pointerCharacterSet {
    NSMutableCharacterSet * const set = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [set addCharactersInString:kSFDereferenceOperator];
    return set;
}

+ (NSCharacterSet *)SF_objectTypeEncodingCharacterSet {
    NSMutableCharacterSet * const set = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
    [set addCharactersInString:kSFObjectTypeEncoding];
    return set;
}

+ (NSCharacterSet *)SF_valueTypePointerEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kSFPointerToTypeEncoding];
}

+ (NSCharacterSet *)SF_structEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kSFStructEncoding];
}

+ (NSCharacterSet *)SF_unionEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kSFUnionEncoding];
}

+ (NSCharacterSet *)SF_bitFieldEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kSFBitFieldEncoding];
}

+ (NSCharacterSet *)SF_arrayEncodingCharacterSet {
    return [NSCharacterSet characterSetWithCharactersInString:kSFArrayEncoding];
}

+ (NSCharacterSet *)SF_fixedArrayEncodingCharacterSet {
    NSMutableCharacterSet * const set = [NSMutableCharacterSet decimalDigitCharacterSet];
    [set addCharactersInString:kSFPointerToTypeEncoding];
    return set;
}

+ (BOOL)SF_isPrefix:(NSCharacterSet *)prefixSet inString:(NSString *)string {
    NSAssert([string length] > 0, @"Assertion: string (%@) is not empty and is not nil.", string);
    return [string rangeOfCharacterFromSet:prefixSet options:NSLiteralSearch range:NSMakeRange(0, 1)].location != NSNotFound;
}


+ (BOOL)SF_isPrimitiveType:(NSString *)typeEncoding {
    return (![typeEncoding hasPrefix:@"@"]);
}

+ (NSString *)SF_classNameFromTypeName:(NSString *)typeName {
    return [typeName stringByTrimmingCharactersInSet:[self SF_pointerCharacterSet]];
}

@end
