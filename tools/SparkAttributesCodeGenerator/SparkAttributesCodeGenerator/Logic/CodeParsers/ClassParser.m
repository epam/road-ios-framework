//
//  InterfaceParser.m
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

#import "ClassParser.h"
#import "SourceCodeHelper.h"
#import "NSRegularExpression+ExtendedAPI.h"

@implementation ClassParser

+ (ClassModel *)parseFrom:(CodeParseState *)parseState {
    ClassModel *result = [ClassModel new];
    
    NSMutableString *classDeclaration = [NSMutableString stringWithString:[self extractClassDeclarationFromBuffer:parseState.workCodeBuffer]];
    
    result.name = [self extractNameFromBuffer:classDeclaration];
    result.categoryName = [self extractCategoryNameFromBuffer:classDeclaration];
    
    return result;
}

NSRegularExpression *classDeclarationRegex = nil;
+ (NSString *)extractClassDeclarationFromBuffer:(NSMutableString *)workCodeBuffer {
    if (classDeclarationRegex == nil) {
        classDeclarationRegex = [NSRegularExpression regexFromString:@"^[ ]*[A-Za-z0-9_]+(\\((?<!%)[@A-Za-z0-9_]+\\)){0,1}([ ]*\\:[ ]*[A-Za-z0-9_]+[ ]*(\\<[^<>]+\\>){0,1}){0,1}"];
    }
    
    NSString *result = [SourceCodeHelper extractElement:classDeclarationRegex fromBuffer:workCodeBuffer];
    return result;
}

NSRegularExpression *nameRegex = nil;
+ (NSString *)extractNameFromBuffer:(NSMutableString *)workCodeBuffer {
    if (nameRegex == nil) {
        nameRegex = [NSRegularExpression regexFromString:@"(?<!%)[@A-Za-z0-9_]+"];
    }
    
    NSString *result = [SourceCodeHelper extractElement:nameRegex fromBuffer:workCodeBuffer];
    return result;
}

NSRegularExpression *categoryNameRegex = nil;
+ (NSString *)extractCategoryNameFromBuffer:(NSMutableString *)workCodeBuffer {
    if (categoryNameRegex == nil) {
        categoryNameRegex = [NSRegularExpression regexFromString:@"\\((?<!%)[@A-Za-z0-9_]+\\)"];
    }
    
    NSString* foundPart = [SourceCodeHelper extractElement:categoryNameRegex fromBuffer:workCodeBuffer];
    
    if (foundPart == nil) {
        return nil;
    }
    
    NSMutableString *result = [NSMutableString stringWithString:foundPart];
    
    [result replaceOccurrencesOfString:@"(" withString:@"" options:0 range:NSMakeRange(0, [result length])];
    [result replaceOccurrencesOfString:@")" withString:@"" options:0 range:NSMakeRange(0, [result length])];
    
    return result;
}

@end
