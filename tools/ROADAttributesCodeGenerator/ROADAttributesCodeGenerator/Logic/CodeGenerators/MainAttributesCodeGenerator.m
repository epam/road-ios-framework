//
//  AttributesCodeGenerator.m
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

#import "MainAttributesCodeGenerator.h"
#import "NSString+ExtendedAPI.h"
#import "TextFile.h"

#import "ClassAttributesCodeGenerator.h"

NSString *k_generatedFileNameSuffix = @"+RFAttributes.m";
NSString *k_collectorFileName = @"ROADGeneratedAttribute.m";

@implementation MainAttributesCodeGenerator

+ (void)generateFilesForModel:(NSArray *)classesModel inDirectory:(NSString *)directoryPath {
    for (ClassModel *currentClassModel in classesModel) {
        NSString *generatedCode = [ClassAttributesCodeGenerator generateCodeForClassModel:currentClassModel];
        
        if ([NSString isNilOrEmpty:generatedCode]) {
            continue;
        }

        currentClassModel.hasGeneratedCode = YES;
        
        NSString *generatedCodeFileName = [directoryPath stringByAppendingPathComponent:[self attrFileNameForClassModel:currentClassModel]];

        if ([TextFile file:generatedCodeFileName hasNotChangedFrom:generatedCode]) {
            continue;
        }
        
        [TextFile saveText:generatedCode toFile:generatedCodeFileName];
    }
}

+ (NSString *)attrFileNameForClassModel:(ClassModel *)classModel {
    NSString *result = [NSString stringWithFormat:@"%@%@", classModel.name, k_generatedFileNameSuffix];
    return result;
}

+ (BOOL)file:(NSString *)path hasNotChangedFrom:(NSString *)text {
    NSString *previouslySavedCode = [TextFile loadTextFile:text];
    BOOL result = (previouslySavedCode != nil && [previouslySavedCode isEqualToString:text]);
    return result;
}

@end
