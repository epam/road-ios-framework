//
//  NSObject+SFAttributesInternal.m
//  AttributesPrototype
//
//  Created by Igor Chesnokov on 8/27/13.
//  Copyright (c) 2013 Igor Chesnokov. All rights reserved.
//

#import "NSObject+SFAttributesInternal.h"

@implementation NSObject (SFAttributesInternal)

#pragma mark Will be overridden by annotated class

+ (NSDictionary *)attributesFactoriesForMethods { return nil; }
+ (NSDictionary *)attributesFactoriesForProperties { return nil; }
+ (NSDictionary *)attributesFactoriesForIvars { return nil; }
+ (NSArray *)attributesForClass { return nil; }

#pragma mark Internal API

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

#pragma mark -

@end
