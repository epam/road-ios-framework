//
//  AttributesParser.m
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

#import "HeaderSectionParser.h"
#import "CodeParseState.h"
#import "SourceCodeHelper.h"
#import "CodeParseState.h"
#import "NSRegularExpression+ExtendedAPI.h"
#import "SourceCodePreprocessor.h"
#import "NSString+ExtendedAPI.h"

#import "AttributeDataParser.h"
#import "ClassParser.h"
#import "PropertyParser.h"
#import "MethodParser.h"
#import "FieldParser.h"

@implementation HeaderSectionParser

+ (void)parseSourceCode:(NSString *)sourceCode into:(ClassModelsContainer *)classModelsContainer skipImports:(BOOL)skipImports {
    if ([NSString isNilOrEmpty:sourceCode] || classModelsContainer == nil) {
        return;
    }
    
    PreprocessedSourceCode *sourceCodeInfo = (skipImports) ? [SourceCodePreprocessor prepareCodeForParsingWithoutImports:sourceCode] : [SourceCodePreprocessor prepareCodeForParsingWithImports:sourceCode];
    CodeParseState *parseState = [CodeParseState new];
    parseState.foundClassesList = classModelsContainer;
    parseState.sourceCodeInfo = sourceCodeInfo;
    parseState.workCodeBuffer = [NSMutableString stringWithString:sourceCodeInfo.sourceCode];
    
    for (;;) {
        NSString *keyWord = [self extractKeyWordFromBuffer:parseState.workCodeBuffer];
        
        if (keyWord == nil) {
            break;
        }
        
        [self processKeyWord:keyWord withCodeParseState:parseState];
    }
}

NSRegularExpression *keyWordRegex = nil;
+ (NSString *)extractKeyWordFromBuffer:(NSMutableString *)workCodeBuffer {
    if (keyWordRegex == nil) {
        keyWordRegex = [NSRegularExpression regexFromString:@"([-+][ \t]*\\([^\\(\\)]+\\)){0,1}[%@A-Za-z0-9_]+"];
    }
    
    NSString *result = [SourceCodeHelper extractElement:keyWordRegex fromBuffer:workCodeBuffer];
    return result;
}

+ (void)processKeyWord:(NSString *)keyWord withCodeParseState:(CodeParseState *)parseState {
    if ([keyWord isEqualToString:@"SF_ATTRIBUTE"]) {
        [self processAttributeWithCodeParseState:parseState];
        return;
    }
    
    if (parseState.isFieldMode) {
        [self processFieldWithCodeParseState:parseState];
        return;
    }
    
    if ([keyWord isEqualToString:@"@interface"]) {
        [self processClassDefinitionBeginWithCodeParseState:parseState];
        return;
    }

    if ([keyWord isEqualToString:@"@implementation"]) {
        [self processClassImplementationBeginWithCodeParseState:parseState];
        return;
    }
    
    if ([keyWord isEqualToString:@"@end"]) {
        [self processClassDefinitionEndWithCodeParseState:parseState];
        return;
    }
    
    if ([keyWord isEqualToString:@"@property"]) {
        [self processPropertyWithCodeParseState:parseState];
        return;
    }
    
    if ([keyWord hasPrefix:@"-"] || [keyWord hasPrefix:@"+"]) {
        [self processMethodWithCodeParseState:parseState andKeyword:keyWord];
        return;
    }
    
    if ([keyWord hasPrefix:@"%"]) {
        [self processFieldsBlockWithCodeParseState:parseState andKeyword:keyWord];
        return;
    }
    
    if ([keyWord isEqualToString:@"import"]) {
        [self processImportWithCodeParseState:parseState];
        return;
    }
}

+ (void)processAttributeWithCodeParseState:(CodeParseState *)parseState {
   [parseState.currentAttributesList addObject:[AttributeDataParser parseFrom:parseState]];
}

+ (void)processClassDefinitionBeginWithCodeParseState:(CodeParseState *)parseState {
    ClassModel *parsedClass = [ClassParser parseFrom:parseState];
    
    parsedClass.attributeModels = parseState.currentAttributesList;
    parseState.currentAttributesList = [NSMutableArray array];
    
    [parsedClass.filesToImport addObjectsFromArray:parseState.currentImportFilesList];
    parseState.currentImportFilesList = [NSMutableArray array];
    
    parseState.currentClass = parsedClass;    
}

+ (void)processClassImplementationBeginWithCodeParseState:(CodeParseState *)parseState {
    ClassModel *parsedClass = [ClassParser parseFrom:parseState];
       
    [parsedClass.filesToImport addObjectsFromArray:parseState.currentImportFilesList];
    parseState.currentImportFilesList = [NSMutableArray array];
    
    [parseState.foundClassesList addClassModel:parsedClass];
}

+ (void)processClassDefinitionEndWithCodeParseState:(CodeParseState *)parseState {
    if (parseState.currentClass == nil) {
        return;
    }

    [parseState.foundClassesList addClassModel:parseState.currentClass];
    parseState.currentClass = nil;
}

+ (void)processPropertyWithCodeParseState:(CodeParseState *)parseState {
    PropertyModel *parsedProperty = [PropertyParser parseFrom:parseState];
    
    parsedProperty.attributeModels = parseState.currentAttributesList;
    parseState.currentAttributesList = [NSMutableArray array];
    
    if (parseState.currentClass == nil) {
        return;
    }
    
    parsedProperty.holder = parseState.currentClass;
    [parseState.currentClass.propertiesList addObject:parsedProperty];
}

+ (void)processMethodWithCodeParseState:(CodeParseState *)parseState andKeyword:(NSString *)keyWord {
    MethodModel *parsedMethod = [MethodParser parseFrom:parseState forKeyWord:keyWord];
    
    parsedMethod.attributeModels = parseState.currentAttributesList;
    parseState.currentAttributesList = [NSMutableArray array];
    
    if (parseState.currentClass == nil) {
        return;
    }
    
    parsedMethod.holder = parseState.currentClass;
    [parseState.currentClass.methodsList addObject:parsedMethod];
}

+ (void)processFieldsBlockWithCodeParseState:(CodeParseState *)parseState andKeyword:(NSString *)keyWord {
    if (![MetaMarkersContainer isMetaMarker:keyWord hasType:MetaMarkerDataTypeCode]) {
        return;
    }
    
    NSString *fieldsBlock = [parseState.sourceCodeInfo.metaMarkers dataForMetaMarker:keyWord];
    if (fieldsBlock == nil) {
        return;
    }
    
    PreprocessedSourceCode *fieldsCodeInfo = [PreprocessedSourceCode new];
    fieldsCodeInfo.sourceCode = [NSMutableString stringWithString:fieldsBlock];
    [SourceCodePreprocessor normalizeText:fieldsCodeInfo];
    
    NSMutableString *mainWorkCodeBuffer = parseState.workCodeBuffer;
    
    parseState.workCodeBuffer = fieldsCodeInfo.sourceCode;
    parseState.isFieldMode = YES;
    
    for (;;) {
        NSString *keyWord = [self extractKeyWordFromBuffer:parseState.workCodeBuffer];
        
        if (keyWord == nil) {
            break;
        }
        
        [self processKeyWord:keyWord withCodeParseState:parseState];
    }
    
    parseState.workCodeBuffer = mainWorkCodeBuffer;
    parseState.isFieldMode = NO;
}

+ (void)processFieldWithCodeParseState:(CodeParseState *)parseState {
    if (parseState.currentClass == nil) {
        return;
    }
    
    FieldModel *parsedField = [FieldParser parseFrom:parseState];
        
    parsedField.attributeModels = parseState.currentAttributesList;
    parseState.currentAttributesList = [NSMutableArray array];
    
    parsedField.holder = parseState.currentClass;
    [parseState.currentClass.fieldsList addObject:parsedField];
}


NSRegularExpression *importFileRegex = nil;   
+ (void)processImportWithCodeParseState:(CodeParseState *)parseState {
    if (parseState.currentClass != nil) {
        return;
    }
    
    if (importFileRegex == nil) {
        importFileRegex = [NSRegularExpression regexFromString:@"[<%][^%<>]+[>%]"];
    }
    
    NSString *importFileMarker = [SourceCodeHelper extractElement:importFileRegex fromBuffer:parseState.workCodeBuffer];
    NSString *importFileName = [importFileMarker hasPrefix:@"<"] ? importFileMarker : [parseState.sourceCodeInfo.metaMarkers dataForMetaMarker:importFileMarker];
    
    [parseState.currentImportFilesList addObject:importFileName];
}

@end
