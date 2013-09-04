//
//  ClassAttributesCodeGenerator.m
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

#import "ClassAttributesCodeGenerator.h"
#import "NSMutableString+ExtendedAPI.h"

#import "MethodsAttributesCodeGenerator.h"
#import "PropertiesAttributesCodeGenerator.h"
#import "FieldsAttributesCodeGenerator.h"

@implementation ClassAttributesCodeGenerator

+ (NSString *)generateCodeForClassModel:(ClassModel *)classModel {
    NSMutableString *result = [NSMutableString new];
    
    [result appendLine:[FieldsAttributesCodeGenerator generateCodeForModelsList:classModel.fieldsList]];
    [result appendLine:[PropertiesAttributesCodeGenerator generateCodeForModelsList:classModel.propertiesList]];
    [result appendLine:[MethodsAttributesCodeGenerator generateCodeForModelsList:classModel.methodsList]];
    
    if ([classModel.attributeModels.attributeModels count] > 0) {
        NSMutableString *classAttrCode = [self generateCodeForModel:classModel];
        
        if ([classAttrCode length] > 0) {
            [self decorateSectionIn:classAttrCode];
            [result appendLine:classAttrCode];
        }
    }
    
    if ([result length] > 0) {
        [self decorateCategoryDefinitionFor:classModel in:result];
    }
    
    return result;
}

+ (void)decorateCategoryDefinitionFor:(ClassModel *)classModel in:(NSMutableString *)result {
    NSMutableString *categoryDefinitionHeader = [NSMutableString new];
    
    for (NSString *fileToImport in classModel.filesToImport) {
        [categoryDefinitionHeader appendFormat:@"#import %@\n", fileToImport];
    }
    
    [categoryDefinitionHeader appendLine:@" "];
    [categoryDefinitionHeader appendFormat:@"@interface %@(SFAttribute)\n", classModel.name];
    [categoryDefinitionHeader appendLine:@" "];
    [categoryDefinitionHeader appendLine:@"@end"];
    [categoryDefinitionHeader appendLine:@" "];
    [categoryDefinitionHeader appendFormat:@"@implementation %@(SFAttribute)\n", classModel.name];
    [categoryDefinitionHeader appendLine:@" "];

    [result insertString:categoryDefinitionHeader atIndex:0];
    [result appendString:@"@end\n"];
}

+ (NSString *)listCreatorName:(AnnotatedElementModel *)model {
    return @"attributesForClass";
}

+ (NSString *)elementType {
    return @"class";
}

+ (NSString *)sectionType {
    return @"Class";
}

@end
