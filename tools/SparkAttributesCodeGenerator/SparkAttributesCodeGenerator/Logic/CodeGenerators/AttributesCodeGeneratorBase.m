//
//  AttributesCodeGeneratorBase.m
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

#import "AttributesCodeGeneratorBase.h"
#import "NSString+ExtendedAPI.h"
#import "NSMutableString+ExtendedAPI.h"
#import "AttributeModel.h"
#import "ClassModel.h"

@implementation AttributesCodeGeneratorBase

+ (NSMutableString *)generateCodeForModelsList:(NSArray *)modelsList {
    NSMutableString *result = [NSMutableString new];
    
    if ([modelsList count] == 0) {
        return result;
    }
    
    for (AnnotatedElementModel *currentModel in modelsList) {
        [result appendLine:[self generateCodeForModel:currentModel]];
    }
    
    if ([result length] > 0) {
        [result appendLine:[self generateFactoryCodeForModelsList:modelsList]];
        [self decorateSectionIn:result];
    }

    return result;
}

+ (NSMutableString *)generateFactoryCodeForModelsList:(NSArray *)modelsList {
    NSMutableString *result = [NSMutableString new];
    
    if ([modelsList count] == 0) {
        return result;
    }
    
    NSString *factoryName = [self factoryName];
    NSString *factoryDictionaryHolderName = [NSString stringWithFormat:@"attributes%@%@Dict", [self modelHolderName:[modelsList lastObject]], [self factoryName]];
    
    [result appendFormat:@"static NSMutableDictionary __weak *%@ = nil;\n", factoryDictionaryHolderName];
    [result appendLine:@"    "];
    [result appendFormat:@"+ (NSDictionary *)attributes%@ {\n", factoryName];
    [result appendFormat:@"    if (%@ != nil) {\n", factoryDictionaryHolderName];
    [result appendFormat:@"        return %@;\n", factoryDictionaryHolderName];
    [result appendLine:@"    }"];
    [result appendLine:@"    "];
    [result appendFormat:@"    NSMutableDictionary *dictionaryHolder = [self mutableAttributesFactoriesFrom:[super attributes%@]];\n", factoryName];
    [result appendLine:@"    "];
    
    for (AnnotatedElementModel *currentModel in modelsList) {
        if ([currentModel.attributeModels.attributeModels count] == 0) {
            continue;
        }
        
        [result appendFormat:@"    [dictionaryHolder setObject:[self invocationForSelector:@selector(%@)] forKey:@\"%@\"];\n", [self listCreatorName:currentModel], currentModel.name];
    }
    
    [result appendFormat:@"    %@ = dictionaryHolder;  \n", factoryDictionaryHolderName];
    [result appendLine:@"    "];
    [result appendFormat:@"    return %@;\n", factoryDictionaryHolderName];
    [result appendLine:@"}"];
    
    return result;
}


+ (NSMutableString *)generateCodeForModel:(AnnotatedElementModel *)model {
    NSMutableString *result = [NSMutableString new];
    
    NSUInteger countOfAttributes = [model.attributeModels.attributeModels count];
    
    if (countOfAttributes == 0) {
        return result;
    }
    
    [self writeMethodBodyTo:result forModel:model];
    
    return result;
}

+ (void)writeMethodBodyTo:(NSMutableString *)result forModel:(AnnotatedElementModel *)model {
    NSString *listHolderName = [self listHolderName:model];
    NSString *listCreatorName = [self listCreatorName:model];
    
    [result appendFormat:@"static NSMutableArray __weak *%@ = nil;\n\n", listHolderName];
    [result appendFormat:@"+ (NSArray *)%@ {\n", listCreatorName];
    [result appendFormat:@"    if (%@ != nil) {\n", listHolderName];
    [result appendFormat:@"        return %@;\n", listHolderName];
    [result appendLine:@"    }"];
    [result appendLine:@"    "];
    [result appendFormat:@"    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:%ld];\n", (unsigned long)[model.attributeModels.attributeModels count]];
    [result appendLine:@"    "];
    [result appendString:[self generateAttributesCreatingBodyForModels:model.attributeModels]];
    [result appendFormat:@"    %@ = attributesArray;\n", listHolderName];
    [result appendLine:@"    "];
    [result appendFormat:@"    return %@;\n", listHolderName];
    [result appendLine:@"}"];
}

+ (NSString *)listHolderName:(AnnotatedElementModel *)model {
    NSString *result = [NSString stringWithFormat:@"sf_attributes_list_%@_%@_%@", [self modelHolderName:model], [self elementType], [self elementName:model]];
    return result;
}

+ (NSString *)modelHolderName:(AnnotatedElementModel *)model {
    ClassModel *holder = (ClassModel *)model.holder;
    NSString *result = [NSString isNilOrEmpty:holder.name] ? @"" : holder.name;
    return result;
}

+ (NSString *)listCreatorName:(AnnotatedElementModel *)model {
    NSString *result = [NSString stringWithFormat:@"sf_attributes_%@_%@_%@", [self modelHolderName:model], [self elementType], [self elementName:model]];
    return result;
}

+ (NSString *)elementName:(AnnotatedElementModel *)model {
    return model.name;
}

+ (NSString *)elementType {
    return @"";
}

+ (NSString *)sectionType {
    return @"";
}

+ (NSString *)factoryName {
    return @"";
}

+ (NSString *)generateAttributesCreatingBodyForModels:(AttributeModelsContainer *)attributeModels {
    NSMutableString *result = [NSMutableString new];
    
    NSUInteger attributeIndex = 1;
    
    for (AttributeModel *currentModel in attributeModels.attributeModels) {
        NSString *attributeVariable = [NSString stringWithFormat:@"attr%ld", (unsigned long)attributeIndex];
        
        [result appendFormat:@"    %@ *%@ = [[%@ alloc] init];\n", currentModel.classType, attributeVariable, currentModel.classType];
        
        for (NSString *currentCustomizer in currentModel.objectCustomizers) {
            [result appendFormat:@"    %@.%@;\n", attributeVariable, currentCustomizer];
        }
        
        [result appendFormat:@"    [attributesArray addObject:%@];\n\n", attributeVariable];
        
        ++attributeIndex;
    }
    
    return result;
}

+ (void)decorateSectionIn:(NSMutableString *)result {
    [result insertString:[NSString stringWithFormat: @"#pragma mark - Fill Attributes generated code (%@ section)\n\n", [self sectionType]] atIndex:0];
    [result appendString:@"\n#pragma mark - \n"];
}

@end
