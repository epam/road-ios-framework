//
//  ClassesModelHelper.m
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

#import "ClassesModelHelper.h"
#import "NSString+ExtendedAPI.h"

#import "ClassModel.h"
#import "MethodModel.h"
#import "FieldModel.h"
#import "PropertyModel.h"

@implementation ClassesModelHelper

+ (void)mergeClassesModel:(NSMutableArray *)classesModel1 withClassesModel:(NSMutableArray *)classesModel2 {
    if (classesModel1 == nil || classesModel2 == nil) {
        return;
    }
    
    for (ClassModel *currentClassModel2 in classesModel2) {
        [self mergeClassesModel:classesModel1 withClassModel:currentClassModel2];
    }
}

+ (void)mergeClassesModel:(NSMutableArray *)classesModel1 withClassModel:(ClassModel *)classModelToMerge {
    if (classesModel1 == nil || classModelToMerge == nil) {
        return;
    }
    
    ClassModel *currentClassModel1 = [self findClassByName:classModelToMerge.name inModel:classesModel1];
    
    if (currentClassModel1 == nil) {
        [classesModel1 addObject:classModelToMerge];
        return;
    }
    
    [currentClassModel1.attributeModels addObjectsFromArray:classModelToMerge.attributeModels];
    [currentClassModel1.filesToImport addObjectsFromArray:classModelToMerge.filesToImport];
    
    [self mergeFieldsToClassModel:currentClassModel1 fromClassModel:classModelToMerge];
    [self mergePropertiesToClassModel:currentClassModel1 fromClassModel:classModelToMerge];
    [self mergeMethodsToClassModel:currentClassModel1 fromClassModel:classModelToMerge];
}

+ (ClassModel *)findClassByName:(NSString *)name inModel:(NSMutableArray *)classesModel {
    for (ClassModel *currentClassModel in classesModel) {
        if ([currentClassModel.name isEqualToString:name]) {
            return currentClassModel;
        }
    }
    
    return nil;
}

+ (void)mergeMethodsToClassModel:(ClassModel *)toModel fromClassModel:(ClassModel *)fromModel {
    
    for (MethodModel *currentMethodModel2 in fromModel.methodsList) {
        
        MethodModel *currentMethodModel1 = [self findMethodByName:currentMethodModel2.name andParametersCount:currentMethodModel2.parametersCount inModel:toModel.methodsList];
        
        if (currentMethodModel1 == nil) {
            
            currentMethodModel2.holder = toModel;
            [toModel.methodsList addObject:currentMethodModel2];
            
            continue;
        }
        
        [currentMethodModel1.attributeModels addObjectsFromArray:currentMethodModel2.attributeModels];
    }
}

+ (MethodModel *)findMethodByName:(NSString *)name andParametersCount:(NSUInteger)parametersCount inModel:(NSMutableArray *)methodsModel {
    for (MethodModel *currentMethodModel in methodsModel) {
        if (![currentMethodModel.name isEqualToString:name]) {
            continue;
        }
        
        if (currentMethodModel.parametersCount == parametersCount) {
            return currentMethodModel;
        }
    }
    
    return nil;
}

+ (void)mergeFieldsToClassModel:(ClassModel *)toModel fromClassModel:(ClassModel *)fromModel {
    
    for (FieldModel *currentFieldModel2 in fromModel.fieldsList) {
        
        FieldModel *currentFieldModel1 = [self findFieldByName:currentFieldModel2.name inModel:toModel.fieldsList];
        
        if (currentFieldModel1 == nil) {
            
            currentFieldModel2.holder = toModel;
            [toModel.fieldsList addObject:currentFieldModel2];
            
            continue;
        }
        
        [currentFieldModel1.attributeModels addObjectsFromArray:currentFieldModel2.attributeModels];
    }
}

+ (FieldModel *)findFieldByName:(NSString *)name inModel:(NSMutableArray *)fieldsModel {
    for (FieldModel *currentFieldModel in fieldsModel) {
        if ([currentFieldModel.name isEqualToString:name]) {
            return currentFieldModel;
        }
    }
    
    return nil;
}

+ (void)mergePropertiesToClassModel:(ClassModel *)toModel fromClassModel:(ClassModel *)fromModel {

    for (PropertyModel *currentPropertyModel2 in fromModel.propertiesList) {
        
        PropertyModel *currentPropertyModel1 = [self findPropertyByName:currentPropertyModel2.name inModel:toModel.propertiesList];
        
        if (currentPropertyModel1 == nil) {
            
            currentPropertyModel2.holder = toModel;
            [toModel.propertiesList addObject:currentPropertyModel2];
            
            continue;
        }
        
        [currentPropertyModel1.attributeModels addObjectsFromArray:currentPropertyModel2.attributeModels];
    }
}

+ (PropertyModel *)findPropertyByName:(NSString *)name inModel:(NSMutableArray *)propertiesModel {
    for (PropertyModel *currentPropertyModel in propertiesModel) {
        if ([currentPropertyModel.name isEqualToString:name]) {
            return currentPropertyModel;
        }
    }
    
    return nil;
}

@end
