//
//  SourceCodePreprocessor.m
//  AttributesResearchLab
//
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

#import "SourceCodePreprocessor.h"
#import "NSString+ExtendedAPI.h"
#import "SourceCodeHelper.h"
#import "NSRegularExpression+ExtendedAPI.h"

@implementation SourceCodePreprocessor

+ (PreprocessedSourceCode *)prepareCodeForParsingWithoutImports:(NSString *)sourceCode {
    if ([NSString isNilOrEmpty:sourceCode]) {
        return nil;
    }
    
    PreprocessedSourceCode *result = [PreprocessedSourceCode new];
    result.sourceCode = [NSMutableString stringWithString:sourceCode];
    
    [self processStringParamsInCode:result];
    [self removeComments:result];
    [self removeImports:result];
    [self removeIncludes:result];
    [self processArrayBlocksInCode:result];
    [self processCodeBlocksInCode:result];

    [self normalizeText:result];
    
    return result;
}

+ (PreprocessedSourceCode *)prepareCodeForParsingWithImports:(NSString *)sourceCode {
    if ([NSString isNilOrEmpty:sourceCode]) {
        return nil;
    }
    
    PreprocessedSourceCode *result = [PreprocessedSourceCode new];
    result.sourceCode = [NSMutableString stringWithString:sourceCode];
    
    [self processStringParamsInCode:result];
    [self removeComments:result];
    [self removeIncludes:result];
    [self processArrayBlocksInCode:result];
    [self processCodeBlocksInCode:result];
    
    [self normalizeText:result];
    
    return result;
}


+ (PreprocessedSourceCode *)prepareCodeForInjecting:(NSString *)sourceCode {
    if ([NSString isNilOrEmpty:sourceCode]) {
        return nil;
    }
    
    PreprocessedSourceCode *result = [PreprocessedSourceCode new];
    result.sourceCode = [NSMutableString stringWithString:sourceCode];
    
    [self processStringParamsInCode:result];
    [self processCommentsInCode:result];
    
    return result;
}

+ (void)processStringParamsInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    [self processBlockMatchedRegex:@"(?<!')\"((\\\\\")*[^\"\\r\\n]*(\\\\\")*)*\"'{0}" withDataType:MetaMarkerDataTypeString inCodeInfo:sourceCodeInfo];
}

+ (void)processBlockMatchedRegex:(NSString *)blockRegex withDataType:(MetaMarkerDataType)dataType inCodeInfo:(PreprocessedSourceCode *)sourceCodeInfo {
    if ([NSString isNilOrEmpty:sourceCodeInfo.sourceCode]) {
        return;
    }
    
    NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    NSRegularExpression *regex = [NSRegularExpression regexFromString:blockRegex];
    
    for (;;) {
        
        NSRange blockRange = [regex rangeOfFirstMatchInString:sourceCodeInfo.sourceCode options:0 range:NSMakeRange(0, [sourceCodeInfo.sourceCode length])];
        
        if (NSEqualRanges(blockRange, notFoundRange)) {
            break;
        }
        
        NSString *metaMarker = [sourceCodeInfo.metaMarkers addData:[sourceCodeInfo.sourceCode substringWithRange:blockRange] withType:dataType];
        [sourceCodeInfo.sourceCode replaceCharactersInRange:blockRange withString:metaMarker];
    }
}

+ (void)removeComments:(PreprocessedSourceCode *)sourceCodeInfo {
    [self removeMultiLineComments:sourceCodeInfo];
    [self removeSingleLineComments:sourceCodeInfo];
}

+ (void)removeMultiLineComments:(PreprocessedSourceCode *)sourceCodeInfo {
    NSMutableString *result = (NSMutableString *)sourceCodeInfo.sourceCode;
    
    for (;;) {
        NSRange commentBlockRange = [self firstMultiLineCommentInString:result];
        
        if (commentBlockRange.length == 0) {
            break;
        }
        
        [result replaceCharactersInRange:commentBlockRange withString:@""];
    }
}

+ (NSRange)firstMultiLineCommentInString:(NSString *)sourceString {    
    NSInteger resultBlockStart = -1;
    NSInteger resultBlockEnd = -1;
    
    NSUInteger stringLength = [sourceString length];
    
    for (NSUInteger charIndex = 0; charIndex < stringLength; charIndex ++) {
        unichar currentChar = [sourceString characterAtIndex:charIndex];
        
        if (currentChar == '/' && resultBlockStart == -1) {
            NSUInteger nextCharIndex = charIndex + 1;
            
            if (nextCharIndex < stringLength && [sourceString characterAtIndex:nextCharIndex] == '*') {
                resultBlockStart = charIndex;
                charIndex = nextCharIndex;
            }
            
            continue;
        }
        
        if (currentChar == '*' && resultBlockStart > -1) {
            NSUInteger nextCharIndex = charIndex + 1;
            
            if (nextCharIndex < stringLength && [sourceString characterAtIndex:nextCharIndex] == '/') {
                resultBlockEnd = nextCharIndex;
                break;
            }
            
            continue;
        }
    }
    
    if (resultBlockStart == -1) {
        return NSMakeRange(0, 0);
    }
    
    return NSMakeRange(resultBlockStart, (resultBlockEnd - resultBlockStart) + 1);
}

+ (void)removeSingleLineComments:(PreprocessedSourceCode *)sourceCodeInfo {   
    [NSRegularExpression replaceRegex:@"//.*" withTemplate:@"" inString:sourceCodeInfo.sourceCode];
}

+ (void)removeImports:(PreprocessedSourceCode *)sourceCodeInfo {   
    [NSRegularExpression replaceRegex:@"#import .*" withTemplate:@"" inString:sourceCodeInfo.sourceCode];
}

+ (void)removeIncludes:(PreprocessedSourceCode *)sourceCodeInfo {
    [NSRegularExpression replaceRegex:@"#include .*" withTemplate:@"" inString:sourceCodeInfo.sourceCode];
}

+ (void)processArrayBlocksInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    [self processBlocksInCode:sourceCodeInfo blockOpener:'[' blockCloser:']' dataType:MetaMarkerDataTypeArray];
}

+ (void)processBlocksInCode:(PreprocessedSourceCode *)sourceCodeInfo blockOpener:(unichar)blockOpener blockCloser:(unichar)blockCloser dataType:(MetaMarkerDataType)dataType {
    for (;;) {
        NSRange blockRange = [SourceCodeHelper firstBlockInString:sourceCodeInfo.sourceCode blockOpener:blockOpener blockCloser:blockCloser];
        
        if (blockRange.length == 0) {
            break;
        }
        
        NSString *metaMarker = [sourceCodeInfo.metaMarkers addData:[sourceCodeInfo.sourceCode substringWithRange:blockRange] withType:dataType];
        [sourceCodeInfo.sourceCode replaceCharactersInRange:blockRange withString:metaMarker];
    }
}

+ (void)processCodeBlocksInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    [self processBlocksInCode:sourceCodeInfo blockOpener:'{' blockCloser:'}' dataType:MetaMarkerDataTypeCode];
}

+ (void)processParamsBlocksInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    [self processBlocksInCode:sourceCodeInfo blockOpener:'(' blockCloser:')' dataType:MetaMarkerDataTypeParams];
}

+ (void)normalizeText:(PreprocessedSourceCode *)sourceCodeInfo {
    //remove line markers and tabs   
    [NSRegularExpression replaceRegex:@"[\r\n\t]" withTemplate:@" " inString:sourceCodeInfo.sourceCode];
    
    //remove unneeded spaces    
    [NSRegularExpression replaceRegex:@"[ ]+" withTemplate:@" " inString:sourceCodeInfo.sourceCode];
}

+ (void)processCommentsInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    [self processMultiLineCommentsInCode:sourceCodeInfo];
    [self processSingleLineCommentsInCode:sourceCodeInfo];
}

+ (void)processMultiLineCommentsInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    for (;;) {
        NSRange blockRange = [self firstMultiLineCommentInString:sourceCodeInfo.sourceCode];
        
        if (blockRange.length == 0) {
            break;
        }
        
        NSString *metaMarker = [sourceCodeInfo.metaMarkers addData:[sourceCodeInfo.sourceCode substringWithRange:blockRange] withType:MetaMarkerDataTypeMultiLineComments];
        [sourceCodeInfo.sourceCode replaceCharactersInRange:blockRange withString:metaMarker];
    }
}

+ (void)processSingleLineCommentsInCode:(PreprocessedSourceCode *)sourceCodeInfo {
    [self processBlockMatchedRegex:@"//.*" withDataType:MetaMarkerDataTypeSingleLineComments inCodeInfo:sourceCodeInfo];
}

+ (void)expandMetaMarkers:(PreprocessedSourceCode *)sourceCodeInfo singlePass:(BOOL)singlePass {
    if ([sourceCodeInfo.metaMarkers count] == 0) {
        return;
    }
    
    NSMutableString *result = (NSMutableString *)sourceCodeInfo.sourceCode;
    NSRegularExpression *regex = [MetaMarkersContainer metaMarkersRegex];

    NSRange notFoundRange = NSMakeRange(NSNotFound, 0);
    NSUInteger startIndex = 0;
    
    NSMutableDictionary *workingMetaMarkers = [NSMutableDictionary dictionaryWithDictionary:[sourceCodeInfo.metaMarkers dictionary]];
    
    for (;;) {
        
        NSUInteger effectiveLength = [result length] - startIndex;
        if (effectiveLength < 1) {
            break;
        }
        
        NSRange rangeOfFirstMatch = [regex rangeOfFirstMatchInString:result options:0 range:NSMakeRange(startIndex, effectiveLength)];
        
        if (NSEqualRanges(rangeOfFirstMatch, notFoundRange)) {
            break;
        }
        
        if (singlePass == YES) {
            startIndex = rangeOfFirstMatch.location + 1;
        }
        
        NSString *metaMarker = [result substringWithRange:rangeOfFirstMatch];
        NSString *valueForMetaMarker = [workingMetaMarkers objectForKey:metaMarker];
        [workingMetaMarkers removeObjectForKey:metaMarker];
        
        
        if (valueForMetaMarker == nil) {
            continue;
        }
        
        [result replaceCharactersInRange:rangeOfFirstMatch withString:valueForMetaMarker];
        
        if ([workingMetaMarkers count] == 0) {
            break;
        }
    }
}

@end
