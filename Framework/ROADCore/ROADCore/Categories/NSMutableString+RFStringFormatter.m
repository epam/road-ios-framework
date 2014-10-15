//
//  NSMutableString+RFStringFormatter.m
//  ROADCore
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


#import "NSMutableString+RFStringFormatter.h"


static NSString * const kRFParameterRegexpFormat = @"%@(.*?)%@";
static NSString * const kRFURLGapRegexpFormat = @"\\w+=&|\\w+=&|&?\\w+=\\s*$";


@implementation NSMutableString (RFStringFormatter)

- (void)RF_formatUsingValues:(NSDictionary *)valueDictionary withEscape:(NSString *)escapeString {
    
    @autoreleasepool {
        NSString *pattern = [NSString stringWithFormat:kRFParameterRegexpFormat, escapeString, escapeString];
        NSError *error = nil;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
        NSAssert(!error, @"%@ %@: Error while generating parameters regexp for pattern", self, NSStringFromSelector(_cmd));
        
        NSArray *matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        
        while ([matches count] > 0) {
            NSTextCheckingResult * const aResult = [matches lastObject];
            NSString *subString = [[self substringWithRange:aResult.range] stringByReplacingOccurrencesOfString:escapeString withString:@""];
            NSString *value = valueDictionary[subString];
            NSAssert(value, @"Value must not be nil.");
            
            if ([value length] > 0) {
                [self replaceCharactersInRange:aResult.range withString:value];
            } else {
                [self replaceCharactersInRange:aResult.range withString:@""];
            }
            
            matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        }
    }
}

- (void)RF_formatAsURLUsingValues:(NSDictionary *)valueDictionary withEscape:(NSString *)escapeString {
    
    [self RF_formatUsingValues:valueDictionary withEscape:escapeString];
    
    @autoreleasepool {
        NSError* error = nil;
        NSRegularExpression* regexp = [NSRegularExpression regularExpressionWithPattern:kRFURLGapRegexpFormat options:NSRegularExpressionAllowCommentsAndWhitespace error:&error];
        NSAssert(!error, @"%@ %@: Error while generating gaps regexp for pattern", self, NSStringFromSelector(_cmd));
        
        NSArray* matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        
        while ([matches count] > 0) {
            [self replaceCharactersInRange:[[matches lastObject] range] withString:@""];
            matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        }
    }
}

- (void)RF_formatStringUsingValues:(NSDictionary *const)valueDictionary withEscape:(NSString *const)escapeString {
    [self RF_formatAsURLUsingValues:valueDictionary withEscape:escapeString];
}

@end
