//
//  ESDEncodingMapper.m
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


#import "ESDEncodingMapper.h"
#import "NSCharacterSet+EncodingCharacterSet.h"

static NSString * const kESDEncodingMapFile = @"ESDEncoding";
static NSString * const kESDPlistExtension = @"plist";
static NSString * const kESDPointerFormat = @"%@ *";
static NSString * const kESDArrayFormat = @"%@[]";
static NSString * const kESDBitfieldFormat = @"bitfield(%@)";
static NSString * const kESDUnionFormat = @"union %@";
static NSString * const kESDStructFormat = @"struct %@";
static NSString * const kESDFixedArrayFormat = @"%@[%ld]";
static NSDictionary *kESDMapDictionary;

@implementation ESDEncodingMapper

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString * const path = [[NSBundle bundleForClass:self] pathForResource:kESDEncodingMapFile ofType:kESDPlistExtension];
        kESDMapDictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    });
}

+ (NSString *)nameFromTypeEncoding:(NSString *)encoding {
    NSString *result;

    if ([encoding length] == 1) {
        result = kESDMapDictionary[encoding];
    }
    else if ([[NSCharacterSet objectTypeEncodingCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO]) {
        result = [NSString stringWithFormat:kESDPointerFormat, [encoding stringByTrimmingCharactersInSet:[NSCharacterSet objectTypeEncodingCharacterSet]]];
    }
    else if ([[NSCharacterSet valueTypePointerEncodingCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO]) {
        result = [NSString stringWithFormat:kESDPointerFormat, [self nameFromTypeEncoding:[encoding stringByTrimmingCharactersInSet:[NSCharacterSet valueTypePointerEncodingCharacterSet]]]];
    }
    else if ([[NSCharacterSet arrayEncodingCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO]) {
        result = [NSString stringWithFormat:kESDArrayFormat, [self nameFromTypeEncoding:[encoding stringByTrimmingCharactersInSet:[NSCharacterSet arrayEncodingCharacterSet]]]];
    }
    else if ([[NSCharacterSet bitFieldEncodingCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO]) {
        result = [NSString stringWithFormat:kESDBitfieldFormat, [encoding stringByTrimmingCharactersInSet:[NSCharacterSet bitFieldEncodingCharacterSet]]];
    }
    else if ([[NSCharacterSet structEncodingCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO]) {
        result = [NSString stringWithFormat:kESDStructFormat, [encoding stringByTrimmingCharactersInSet:[NSCharacterSet structEncodingCharacterSet]]];
    }
    else if ([[NSCharacterSet unionEncodingCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO]) {
        result = [NSString stringWithFormat:kESDUnionFormat, [encoding stringByTrimmingCharactersInSet:[NSCharacterSet unionEncodingCharacterSet]]];
    }
    else if ([[NSCharacterSet decimalDigitCharacterSet] isPrefixInString:encoding shouldTrimWhiteSpace:NO] && [encoding rangeOfCharacterFromSet:[NSCharacterSet valueTypePointerEncodingCharacterSet]].location != NSNotFound) {
        // in case the encoding is a fixed size c-style array, then the numbers preceding the '^' sign is the length of it
        // the long casts are required for the %ld format specifier, which in turn is needed for the mac-compatibility, where NSInteger is long instead of int.
        NSInteger arraySize = 0;
        [[NSScanner scannerWithString:encoding] scanInteger:&arraySize];
        NSString * const typeEncoding = [encoding stringByTrimmingCharactersInSet:[NSCharacterSet fixedArrayEncodingCharacterSet]];
        NSString * const type = [self nameFromTypeEncoding:typeEncoding];
        result = [NSString stringWithFormat:kESDFixedArrayFormat, type, (long)arraySize];
    }
    
    if ([result length] == 0) {
        // in case no match is found, a fail-safe solution is to keep the encoding itself
        result = [encoding copy];
    }
    
    return result;
}

@end