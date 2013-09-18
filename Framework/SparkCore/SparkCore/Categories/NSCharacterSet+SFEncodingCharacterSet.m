//
//  NSCharacterSet+SFEncodingCharacterSet.m
//  SparkCore
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


#import "NSCharacterSet+SFEncodingCharacterSet.h"

static NSString * const kSFObjectTypeEncoding = @"@\"";
static NSString * const kSFArrayEncoding = @"[]";
static NSString * const kSFBitFieldEncoding = @"b";
static NSString * const kSFStructEncoding = @"{}";
static NSString * const kSFUnionEncoding = @"()";
static NSString * const kSFAssignmentOperator = @"=";
static NSString * const kSFPointerToTypeEncoding = @"^";
static NSString * const kSFDereferenceOperator = @"*";

@implementation NSCharacterSet (SFEncodingCharacterSet)

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

- (BOOL)SF_isPrefixInString:(NSString * const)aString shouldTrimWhiteSpace:(BOOL const)shouldTrimWhiteSpace {
    NSString *stringToExamine = aString;
    
    if (shouldTrimWhiteSpace) {
        stringToExamine = [aString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    
    NSAssert([stringToExamine length] > 0, @"Assertion: string (%@) is not empty and is not nil.", stringToExamine);
    return [stringToExamine rangeOfCharacterFromSet:self options:NSLiteralSearch range:NSMakeRange(0, 1)].location != NSNotFound;
}

@end
