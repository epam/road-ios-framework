//
//  NSObject+SFAttributes.m
//  AttributesPrototype
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

#import "NSObject+SFAttributes.h"
#import "NSObject+SFAttributesInternal.h"
#import <Spark/NSRegularExpression+SparkExtension.h>
#import <Spark/SparkReflection.h>

@interface NSObject(SFAttributesPrivate)
+ (NSArray *)SF_attributesFromCreatorInvocation:(NSInvocation *)attributeCreatorValueInvocation;
+ (id)SF_attributeWithType:(Class)requiredClassOfAttribute from:(NSArray *)attributes;
+ (NSInvocation *)SF_attributeCreatorInvocationForElement:(NSString *)elementName cachedCreatorsDictionary:(NSMutableDictionary *)cachedCreatorsDictionary creatorSelectorNameFormatter:(NSString *(^)(NSString *))creatorSelectorNameFormatter;
@end

@implementation NSObject (SFAttributes)

#pragma mark - Attributes Private API

+ (NSArray *)SF_attributesFromCreatorInvocation:(NSInvocation *)attributeCreatorValueInvocation {
    if (!attributeCreatorValueInvocation) {
        return nil;
    }
    
    [attributeCreatorValueInvocation invoke];
    
    __unsafe_unretained NSArray *result = nil;
    [attributeCreatorValueInvocation getReturnValue:&result];
    
    return result;
}

+ (id)SF_attributeWithType:(Class)requiredClassOfAttribute from:(NSArray *)attributes {
    if ([attributes count] == 0) {
        return nil;
    }
    
    id result = nil;
    
    for (NSObject *attribute in attributes) {
        if ([attribute isKindOfClass:requiredClassOfAttribute]) {
            result = attribute;
            break;
        }
    }
    
    return result;
}

+ (NSInvocation *)SF_attributeCreatorInvocationForElement:(NSString *)elementName cachedCreatorsDictionary:(NSMutableDictionary *)cachedCreatorsDictionary creatorSelectorNameFormatter:(NSString *(^)(NSString *))creatorSelectorNameFormatter {    
    NSInvocation *result = [cachedCreatorsDictionary objectForKey:elementName];
    if (result) {
        return result;
    }
    
    NSString *creatorSelectorName = creatorSelectorNameFormatter(elementName);
    SEL creatorSelector = NSSelectorFromString(creatorSelectorName);
    if (!creatorSelector) {
        return nil;
    }
    
    result = [self SF_invocationForSelector:creatorSelector];
    if (!result) {
        return nil;
    }
    
    [cachedCreatorsDictionary setObject:result forKey:elementName];
    return result;
}

#pragma mark - Attributes Public API

+ (NSArray *)SF_attributesForMethod:(NSString *)methodName {
    NSInvocation *attributeCreatorInvocation = [self SF_attributeCreatorInvocationForElement:methodName cachedCreatorsDictionary:self.SF_attributesFactoriesForMethods creatorSelectorNameFormatter:^NSString *(NSString *methodName) {
        NSUInteger parametersCount = [NSRegularExpression SF_numberOfMatchesToRegex:@":" inString:methodName];
        NSString *methodNameWithoutParameters = [NSRegularExpression SF_stringByReplacingRegex:@":.*" withTemplate:@"" inString:methodName];
        return [NSString stringWithFormat:@"SF_attributes_%@_method_%@_p%d", NSStringFromClass(self), methodNameWithoutParameters, parametersCount];
    }];
    return [self SF_attributesFromCreatorInvocation:attributeCreatorInvocation];
}

+ (NSArray *)SF_attributesForProperty:(NSString *)propertyName {
    NSInvocation *attributeCreatorInvocation = [self SF_attributeCreatorInvocationForElement:propertyName cachedCreatorsDictionary:self.SF_attributesFactoriesForProperties creatorSelectorNameFormatter:^NSString *(NSString *propertyName) {
        return [NSString stringWithFormat:@"SF_attributes_%@_property_%@", NSStringFromClass(self), propertyName];
    }];
    return [self SF_attributesFromCreatorInvocation:attributeCreatorInvocation];
}

+ (NSArray *)SF_attributesForIvar:(NSString *)ivarName {
    NSInvocation *attributeCreatorInvocation = [self SF_attributeCreatorInvocationForElement:ivarName cachedCreatorsDictionary:self.SF_attributesFactoriesForIvars creatorSelectorNameFormatter:^NSString *(NSString *ivarName) {
        return [NSString stringWithFormat:@"SF_attributes_%@_ivar_%@", NSStringFromClass(self), ivarName];
    }];
    return [self SF_attributesFromCreatorInvocation:attributeCreatorInvocation];
}

+ (NSArray *)SF_attributesForClass { return nil; }


+ (id)SF_attributeForMethod:(NSString *)methodName  withAttributeType:(Class)requiredClassOfAttribute {
    NSAssert(requiredClassOfAttribute, @"You must specify class of required attribute");
    return [self SF_attributeWithType:requiredClassOfAttribute from:[self SF_attributesForMethod:methodName]];
}

+ (id)SF_attributeForProperty:(NSString *)propertyName  withAttributeType:(Class)requiredClassOfAttribute {
    NSAssert(requiredClassOfAttribute, @"You must specify class of required attribute");
    return [self SF_attributeWithType:requiredClassOfAttribute from:[self SF_attributesForProperty:propertyName]];
}

+ (id)SF_attributeForIvar:(NSString *)ivarName  withAttributeType:(Class)requiredClassOfAttribute {
    NSAssert(requiredClassOfAttribute, @"You must specify class of required attribute");
    return [self SF_attributeWithType:requiredClassOfAttribute from:[self SF_attributesForIvar:ivarName]];
}

+ (id)SF_attributeForClassWithAttributeType:(Class)requiredClassOfAttribute {
    NSAssert(requiredClassOfAttribute, @"You must specify class of required attribute");
    return [self SF_attributeWithType:requiredClassOfAttribute from:[self SF_attributesForClass]];
}

+ (NSArray *)SF_propertiesWithAttributeType:(Class)requiredClassOfAttribute {
    NSMutableArray *result = [NSMutableArray array];
    
    for (SFPropertyInfo *currentPropertyInfo in [self properties]) {
        if ([currentPropertyInfo attributeWithType:requiredClassOfAttribute]) {
            [result addObject:currentPropertyInfo];
        }
    }
    
    return result;
}

+ (NSArray *)SF_ivarsWithAttributeType:(Class)requiredClassOfAttribute {
    NSMutableArray *result = [NSMutableArray array];
    
    for (SFIvarInfo *currentIvarInfo in [self ivars]) {
        if ([currentIvarInfo attributeWithType:requiredClassOfAttribute]) {
            [result addObject:currentIvarInfo];
        }
    }
    
    return result;
}

+ (NSArray *)SF_methodsWithAttributeType:(Class)requiredClassOfAttribute {
    NSMutableArray *result = [NSMutableArray array];
    
    for (SFMethodInfo *currentMethodInfo in [self methods]) {
        if ([currentMethodInfo attributeWithType:requiredClassOfAttribute]) {
            [result addObject:currentMethodInfo];
        }
    }
    
    return result;
}

#pragma mark -

@end
