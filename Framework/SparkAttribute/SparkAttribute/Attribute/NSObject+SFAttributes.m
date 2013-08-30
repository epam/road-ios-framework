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
#import <Spark/NSObject+PropertyReflection.h>
#import <Spark/NSObject+MethodReflection.h>
#import <Spark/NSObject+MemberVariableReflection.h>


@interface NSObject ()
+ (NSArray *)attributesWithType:(Class)requiredClassOfAttribute from:(NSArray *)attributes;
+ (NSArray *)attributesFor:(NSString *)annotatedElementName inAttributeCreatorsDictionary:(NSDictionary *)attributeCreatorsDictionary withAttributeType:(Class)requiredClassOfAttribute;
@end


@implementation NSObject (SFAttributes)

#pragma mark - Attributes API

+ (NSArray *)attributesFor:(NSString *)annotatedElementName inAttributeCreatorsDictionary:(NSDictionary *)attributeCreatorsDictionary withAttributeType:(Class)requiredClassOfAttribute {
    assert([annotatedElementName length] > 0);
    
    if (attributeCreatorsDictionary == nil) {
        return nil;
    }
    
    NSInvocation *attributeCreatorValueInvocation = [attributeCreatorsDictionary objectForKey:annotatedElementName];
    if (attributeCreatorValueInvocation== nil) {
        return nil;
    }
    
    NSArray *result = nil;
    
    [attributeCreatorValueInvocation invoke];
    
    //doesn't increment retains counter of object of result. (using of weak references decreases performance 40 times.)
    [attributeCreatorValueInvocation getReturnValue:&result];
    
    //so we need to increment retains counter manually
    CFBridgingRetain(result);
    
    return [self attributesWithType:requiredClassOfAttribute from:result];
}

+ (NSArray *)attributesWithType:(Class)requiredClassOfAttribute from:(NSArray *)attributes {
    if (attributes == nil || [attributes count] == 0) {
        return nil;
    }
    
    if (requiredClassOfAttribute == nil) {
        return attributes;
    }
    
    if ([attributes count] == 1 && [[attributes lastObject] isKindOfClass:requiredClassOfAttribute]) {
        return attributes;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSObject *attribute in attributes) {
        if ([attribute isKindOfClass:requiredClassOfAttribute]) {
            [result addObject:attribute];
        }
    }
    
    return result;
}

+ (NSArray *)attributesForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute {
    return [self attributesFor:methodName inAttributeCreatorsDictionary:self.attributesFactoriesForMethods withAttributeType:requiredClassOfAttribute];
}

+ (NSArray *)attributesForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute {
    return [self attributesFor:propertyName inAttributeCreatorsDictionary:self.attributesFactoriesForProperties withAttributeType:requiredClassOfAttribute];
}

+ (NSArray *)attributesForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute {
    return [self attributesFor:ivarName inAttributeCreatorsDictionary:self.attributesFactoriesForIvars withAttributeType:requiredClassOfAttribute];
}

+ (NSArray *)attributesForClassWithAttributeType:(Class)requiredClassOfAttribute {
    return [self attributesWithType:requiredClassOfAttribute from:self.attributesForClass];
}

+ (NSObject *)lastAttributeForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute {
    NSArray *attributes = [self attributesForMethod:methodName withAttributeType:requiredClassOfAttribute];
    return ([attributes count] == 0) ? nil : [attributes lastObject];
}

+ (NSObject *)lastAttributeForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute {
    NSArray *attributes = [self attributesForProperty:propertyName withAttributeType:requiredClassOfAttribute];
    return ([attributes count] == 0) ? nil : [attributes lastObject];
}

+ (NSObject *)lastAttributeForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute {
    NSArray *attributes = [self attributesForIvar:ivarName withAttributeType:requiredClassOfAttribute];
    return ([attributes count] == 0) ? nil : [attributes lastObject];
}

+ (NSObject *)lastAttributeForClassWithAttributeType:(Class)requiredClassOfAttribute {
    NSArray *attributes = [self attributesForClassWithAttributeType:requiredClassOfAttribute];
    return ([attributes count] == 0) ? nil : [attributes lastObject];
}

+ (BOOL)hasAttributesForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute {
    return [[self attributesForMethod:methodName withAttributeType:requiredClassOfAttribute] count] > 0;
}

+ (BOOL)hasAttributesForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute {
    return [[self attributesForProperty:propertyName withAttributeType:requiredClassOfAttribute] count] > 0;
}

+ (BOOL)hasAttributesForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute {
    return [[self attributesForIvar:ivarName withAttributeType:requiredClassOfAttribute] count] > 0;
}

+ (BOOL)hasAttributesForClassWithAttributeType:(Class)requiredClassOfAttribute {
    return [[self attributesForClassWithAttributeType:requiredClassOfAttribute] count] > 0;
}

+ (NSArray *)propertiesWithAttributeType:(Class)requiredClassOfAttribute {
    NSMutableArray *result = [NSMutableArray array];
    
    for (SFPropertyInfo *currentPropertyInfo in [self properties]) {
        if ([self hasAttributesForProperty:currentPropertyInfo.propertyName withAttributeType:requiredClassOfAttribute]) {
            [result addObject:currentPropertyInfo];
        }
    }
    
    return result;
}

+ (NSArray *)ivarsWithAttributeType:(Class)requiredClassOfAttribute {
    NSMutableArray *result = [NSMutableArray array];
    
    for (SFIvarInfo *currentIvarInfo in [self ivars]) {
        if ([self hasAttributesForIvar:currentIvarInfo.name withAttributeType:requiredClassOfAttribute]) {
            [result addObject:currentIvarInfo];
        }
    }
    
    return result;
}

+ (NSArray *)methodsWithAttributeType:(Class)requiredClassOfAttribute {
    NSMutableArray *result = [NSMutableArray array];
    
    for (SFMethodInfo *currentMethodInfo in [self methods]) {
        if ([self hasAttributesForMethod:currentMethodInfo.name withAttributeType:requiredClassOfAttribute]) {
            [result addObject:currentMethodInfo];
        }
    }
    
    return result;
}

#pragma mark -

@end
