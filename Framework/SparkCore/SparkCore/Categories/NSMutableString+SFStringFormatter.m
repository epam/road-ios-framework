//
//  NSMutableString+SFStringFormatter.m
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


#import "NSMutableString+SFStringFormatter.h"

@implementation NSMutableString (SFStringFormatter)

- (void)SF_formatStringUsingValues:(NSDictionary *const)valueDictionary withEscape:(NSString *const)escapeString {
    @autoreleasepool {
        NSString *pattern = [NSString stringWithFormat:@"%@(.*?)%@", escapeString, escapeString];
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
        NSString *subString;
        NSString *aValue;
        NSString * const uniqueString = [[NSProcessInfo processInfo] globallyUniqueString];
        
        NSArray *matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        
        while ([matches count] > 0) {
            NSTextCheckingResult * const aResult = [matches lastObject];
            subString = [[self substringWithRange:aResult.range] stringByReplacingOccurrencesOfString:escapeString withString:@""];
            aValue = valueDictionary[subString];
            
            if ([aValue length] > 0) {
                [self replaceCharactersInRange:aResult.range withString:aValue];
            }
            else {
                [self replaceCharactersInRange:aResult.range withString:uniqueString];
            }
            
            matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        }
        
        pattern = [NSString stringWithFormat:@"\\w+=%@&|&\\w+=%@|\\w+=%@&", uniqueString, uniqueString, uniqueString];
        regexp = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionAllowCommentsAndWhitespace error:nil];
        matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        
        while ([matches count] > 0) {
            [self replaceCharactersInRange:[[matches lastObject] range] withString:@""];
            matches = [regexp matchesInString:self options:0 range:NSMakeRange(0, [self length])];
        }
    }    
}

@end
