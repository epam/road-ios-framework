//
//  NSCharacterSet+SFEncodingCharacterSet.h
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


#import <Foundation/Foundation.h>

/**
 Factory methods for the NSCharacterSet class.
 */
@interface NSCharacterSet (SFEncodingCharacterSet)

/**
 Character set with newline, whitespaces, and the '*' (dereference operation) character.
 */
+ (NSCharacterSet *)SF_pointerCharacterSet;

/**
 Character set with the newline, whitespace, quote mark ' " ', and at sign '@'.
 */
+ (NSCharacterSet *)SF_objectTypeEncodingCharacterSet;

/**
 Character set with the caret '^' character.
 */
+ (NSCharacterSet *)SF_valueTypePointerEncodingCharacterSet;

/**
 Character set with the struct open-close '{}' encoding characters.
 */
+ (NSCharacterSet *)SF_structEncodingCharacterSet;

/**
 Character set with the union open-close '()' encoding characters
 */
+ (NSCharacterSet *)SF_unionEncodingCharacterSet;

/**
 Character set with the bit field opening encoding character 'b'.
 */
+ (NSCharacterSet *)SF_bitFieldEncodingCharacterSet;

/**
 Character set with the c-style array encoding characters '[]'.
 */
+ (NSCharacterSet *)SF_arrayEncodingCharacterSet;

/**
 Character set with the fixed size static c-style array encoding characters '[...]'. The set itself is composed of decimal numbers and the '^' (caret) sign.
 */
+ (NSCharacterSet *)SF_fixedArrayEncodingCharacterSet;

/**
 Returns whether the string begins, or begins and ends with characters that belong to the character set.
 @param aString The string to examine. Cannot be nil and cannot be of 0 length. If the shouldTrimWhitespace is set to YES, it cannot contain only whitespace and newline characters.
 @param shouldTrimWhitespace Boolean value to tell if whitespaces should be ignored while doing the examination.
 @result The boolean value about the result.
 */
- (BOOL)SF_isPrefixInString:(NSString * const)aString shouldTrimWhiteSpace:(BOOL const)shouldTrimWhitespace;

@end
