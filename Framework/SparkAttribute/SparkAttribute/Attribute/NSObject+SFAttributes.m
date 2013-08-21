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

@implementation NSObject (SFAttributes)

#pragma mark - Attributes API stubs

//will be overridden by annotated class

+ (NSDictionary *)attributesFactoriesForInstanceMethods { return nil; }
+ (NSDictionary *)attributesFactoriesForProperties { return nil; }
+ (NSDictionary *)attributesFactoriesForClassProperties { return nil; }
+ (NSDictionary *)attributesFactoriesForFields { return nil; }
+ (NSArray *)attributesForClass { return nil; }

#pragma mark - Attributes API

+ (NSMutableDictionary *)mutableAttributesFactoriesFrom:(NSDictionary *)attributesFactories {
    
    if (attributesFactories == nil) {
        return [NSMutableDictionary dictionary];
    }
    
    if ([attributesFactories isKindOfClass:[NSMutableDictionary class]]) {
        return (NSMutableDictionary *)attributesFactories;
    }
    
    return [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)attributesFactories];
}

+ (NSInvocation *)invocationForSelector:(SEL)selector {
    NSMethodSignature *methodSig = [self methodSignatureForSelector:selector];
    if (methodSig == nil) {
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    
    return invocation;
}

+ (NSArray *)attributesFor:(NSString *)nameOf inAttributeCreatorsDictionary:(NSDictionary *)attributeCreatorsDictionary {   
    return [self attributesFor:nameOf inAttributeCreatorsDictionary:attributeCreatorsDictionary withType:nil];
}

+ (NSArray *)attributesFor:(NSString *)nameOf inAttributeCreatorsDictionary:(NSDictionary *)attributeCreatorsDictionary withType:(Class)requiredClassOfAttribute {
    if (nameOf == nil) {
        return nil;
    }
    
    if (attributeCreatorsDictionary == nil) {
        return nil;
    }
    
    NSInvocation *attributeCreatorValueInvocation = [attributeCreatorsDictionary objectForKey:nameOf];
    if (attributeCreatorValueInvocation== nil) {
        return nil;
    }
    
    NSArray *result = nil;
    
    [attributeCreatorValueInvocation invoke];
    [attributeCreatorValueInvocation getReturnValue:&result];
    if (result == nil) {
        return nil;
    }
    
    CFBridgingRetain(result);
    
    return [self attributesWithType:requiredClassOfAttribute from:result];
}

+ (NSArray *)attributesWithType:(Class)requiredClassOfAttribute from:(NSArray *)attributesList {
    if (attributesList == nil || [attributesList count] == 0) {
        return nil;
    }
    
    if (requiredClassOfAttribute == nil) {
        return attributesList;
    }
    
    if ([attributesList count] == 1 && [[attributesList lastObject] isKindOfClass:requiredClassOfAttribute]) {
        return attributesList;
    }
    
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSObject *attribute in attributesList) {
        if ([attribute isKindOfClass:requiredClassOfAttribute]) {
            [result addObject:attribute];
        }
    }
    
    return result;
}

+ (NSArray *)attributesForInstanceMethod:(NSString *)nameOf withType:(Class)requiredClassOfAttribute {
    return [self attributesFor:nameOf inAttributeCreatorsDictionary:[self attributesFactoriesForInstanceMethods] withType:requiredClassOfAttribute];
}

+ (NSArray *)attributesForProperty:(NSString *)nameOf withType:(Class)requiredClassOfAttribute {
    return [self attributesFor:nameOf inAttributeCreatorsDictionary:[self attributesFactoriesForProperties] withType:requiredClassOfAttribute];
}

+ (NSArray *)attributesForField:(NSString *)nameOf withType:(Class)requiredClassOfAttribute {
    return [self attributesFor:nameOf inAttributeCreatorsDictionary:[self attributesFactoriesForFields] withType:requiredClassOfAttribute];
}

#pragma mark -

@end
