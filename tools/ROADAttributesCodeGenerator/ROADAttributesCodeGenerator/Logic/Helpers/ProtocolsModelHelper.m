//
//  ProtocolsModelHelper.m
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

#import "ProtocolsModelHelper.h"
#import "NSString+ExtendedAPI.h"

#import "ProtocolModel.h"
#import "MethodModel.h"
#import "PropertyModel.h"

@implementation ProtocolsModelHelper

+ (void)mergeProtocolsModel:(NSMutableArray *)protocolsModel1 withProtocolsModel:(NSMutableArray *)protocolsModel2 {
    if (protocolsModel1 == nil || protocolsModel2 == nil) {
        return;
    }
    
    for (ProtocolModel *currentProtocolModel2 in protocolsModel2) {
        [self mergeProtocolsModel:protocolsModel1 withProtocolModel:currentProtocolModel2];
    }
}

+ (void)mergeProtocolsModel:(NSMutableArray *)protocolsModel1 withProtocolModel:(ProtocolModel *)protocolModelToMerge {
    if (protocolsModel1 == nil || protocolModelToMerge == nil) {
        return;
    }
    
    ProtocolModel *currentProtocolModel1 = [self findProtocolByName:protocolModelToMerge.name inModel:protocolsModel1];
    
    if (currentProtocolModel1 == nil) {
        [protocolsModel1 addObject:protocolModelToMerge];
        return;
    }
    
    [currentProtocolModel1.attributeModels addAttributeModelsFromContainer:protocolModelToMerge.attributeModels];
    [currentProtocolModel1.filesToImport addObjectsFromArray:protocolModelToMerge.filesToImport];
    [currentProtocolModel1.filesToImport addObject:@"<ROAD/ROADCore.h>"];
    
    [self mergePropertiesToProtocolModel:currentProtocolModel1 fromProtocolModel:protocolModelToMerge];
    [self mergeMethodsToProtocolModel:currentProtocolModel1 fromProtocolModel:protocolModelToMerge];
}

+ (ProtocolModel *)findProtocolByName:(NSString *)name inModel:(NSMutableArray *)protocolsModel {
    for (ProtocolModel *currentProtocolModel in protocolsModel) {
        if ([currentProtocolModel.name isEqualToString:name]) {
            return currentProtocolModel;
        }
    }
    
    return nil;
}

+ (void)mergeMethodsToProtocolModel:(ProtocolModel *)toModel fromProtocolModel:(ProtocolModel *)fromModel {
    
    for (MethodModel *currentMethodModel2 in fromModel.methodsList) {
        
        MethodModel *currentMethodModel1 = [self findMethodByName:currentMethodModel2.name andParametersCount:currentMethodModel2.parametersCount inModel:toModel.methodsList];
        
        if (currentMethodModel1 == nil) {
            
            currentMethodModel2.holder = toModel;
            [toModel.methodsList addObject:currentMethodModel2];
            
            continue;
        }
        
        [currentMethodModel1.attributeModels addAttributeModelsFromContainer:currentMethodModel2.attributeModels];
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

+ (void)mergePropertiesToProtocolModel:(ProtocolModel *)toModel fromProtocolModel:(ProtocolModel *)fromModel {
    
    for (PropertyModel *currentPropertyModel2 in fromModel.propertiesList) {
        
        PropertyModel *currentPropertyModel1 = [self findPropertyByName:currentPropertyModel2.name inModel:toModel.propertiesList];
        
        if (currentPropertyModel1 == nil) {
            
            currentPropertyModel2.holder = toModel;
            [toModel.propertiesList addObject:currentPropertyModel2];
            
            continue;
        }
        
        [currentPropertyModel1.attributeModels addAttributeModelsFromContainer:currentPropertyModel2.attributeModels];
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
