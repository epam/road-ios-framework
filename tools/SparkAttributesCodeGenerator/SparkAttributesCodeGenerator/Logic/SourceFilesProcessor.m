//
//  SourceFileProcessor.m
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

#import "SourceFilesProcessor.h"
#import "TextFile.h"
#import "HeaderSectionParser.h"
#import "NSString+ExtendedAPI.h"
#import "SourceFileHelper.h"
#import "ClassesModelHelper.h"
#import "MainAttributesCodeGenerator.h"
#import "UserSourceCodeConfigurator.h"

@implementation SourceFilesProcessor

+ (void)generateAttributeFactoriesIntoPath:(NSString *)targetPath fromSourceCodePath:(NSString *)sourcesPath {
    ClassModelsContainer *classesInfoContainer = [ClassModelsContainer new];
    
    [self gatherClassesInfoFromSourceCodePath:sourcesPath into:classesInfoContainer];
    [self generateAttributeFactoriesIntoPath:targetPath fromClassModels:classesInfoContainer];
    [self generateCodeCollectorIntoPath:targetPath fromClassModels:classesInfoContainer];
    
    [self removeAbsoletedFactoriesFromPath:(NSString *)targetPath accordingToClassModels:classesInfoContainer];
}

+ (void)gatherClassesInfoFromSourceCodePath:(NSString *)sourcesPath into:(ClassModelsContainer *)classesInfoContainer {
    NSArray *filesToProcess = [SourceFileHelper sourceCodeFilesFromPath:sourcesPath];

    for (NSString *fileToProcess in filesToProcess) {
        [self gatherClassInfoFromSourceFile:fileToProcess into:classesInfoContainer];
    }
}

+ (void)generateAttributeFactoriesIntoPath:(NSString *)targetPath fromClassModels:(ClassModelsContainer *)classesInfoContainer {
    [MainAttributesCodeGenerator generateFilesForModel:classesInfoContainer.classModels inDirectory:targetPath];
}

+ (void)gatherClassInfoFromSourceFile:(NSString *)sourcesPath into:(ClassModelsContainer *)classesInfoContainer {
    [self gatherClassInfoFromFile:sourcesPath into:classesInfoContainer skipImports:NO];
    [self gatherClassInfoFromFile:[SourceFileHelper headerFileNameForSourceFile:sourcesPath] into:classesInfoContainer skipImports:YES];
}

+ (void)gatherClassInfoFromFile:(NSString *)sourcesPath into:(ClassModelsContainer *)classesInfoContainer skipImports:(BOOL)skipImports {
    NSString *sourceCode = [TextFile loadTextFile:sourcesPath];

    if ([NSString isNilOrEmpty:sourceCode]) {
        return;
    }

    [HeaderSectionParser parseSourceCode:sourceCode into:classesInfoContainer skipImports:skipImports];
}

+ (void)generateCodeCollectorIntoPath:(NSString *)targetPath fromClassModels:(ClassModelsContainer *)classesInfoContainer {
    NSMutableString *collectorCode = [NSMutableString new];
    
    [collectorCode appendString:@"#import <Spark/NSObject+SFAttributesInternal.h>\n\n"];
    
    for (ClassModel *currentClassModel in classesInfoContainer.classModels) {
        if (!currentClassModel.hasGeneratedCode) {
            continue;
        }
        
        [collectorCode appendFormat:@"#import \"%@\"\n", [MainAttributesCodeGenerator attrFileNameForClassModel:currentClassModel]];
    }
    
    NSString *collectorFilePath = [targetPath stringByAppendingPathComponent:k_collectorFileName];
    
    if ([TextFile file:collectorFilePath hasNotChangedFrom:collectorCode]) {
        return;
    }
    
    [TextFile saveText:collectorCode toFile:collectorFilePath];
}

+ (void)removeAbsoletedFactoriesFromPath:(NSString *)targetPath accordingToClassModels:(ClassModelsContainer *)classesInfoContainer{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    NSArray *subItems = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:targetPath error:nil];
    
    for (NSString *subItem in subItems) {
        if ([subItem hasPrefix:@"."]) {
            continue;
        }
        
        NSString *subItemPath = [targetPath stringByAppendingPathComponent:subItem];
        
        if ([fileManager fileExistsAtPath:subItemPath isDirectory:&isDirectory] && isDirectory) {
            continue;
        }
        
        if (![subItem hasSuffix:k_generatedFileNameSuffix]) {
            continue;
        }
        
        if ([self isActualFile:subItem accordingToClassModels:classesInfoContainer]) {
            continue;
        }
        
        [fileManager removeItemAtPath:subItemPath error:nil];
    }
}

+ (BOOL)isActualFile:(NSString *)path accordingToClassModels:(ClassModelsContainer *)classesInfoContainer {
    NSString *className = [path stringByReplacingOccurrencesOfString:k_generatedFileNameSuffix withString:@""];
    
    for (ClassModel *currentClassModel in classesInfoContainer.classModels) {
        if (![currentClassModel.name isEqualToString:className]) {
            continue;
        }
        
        return currentClassModel.hasGeneratedCode;
    }
    
    return NO;
}


@end
