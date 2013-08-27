//
//  NSObject+SFAttributesInternal.h
//  AttributesPrototype
//
//  Created by Igor Chesnokov on 8/27/13.
//  Copyright (c) 2013 Igor Chesnokov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SFAttributesInternal)

#pragma mark Internal API

+ (NSInvocation *)invocationForSelector:(SEL)selector;
+ (NSMutableDictionary *)mutableAttributesFactoriesFrom:(NSDictionary *)attributesFactories;

#pragma mark Will be overridden by annotated class

+ (NSDictionary *)attributesFactoriesForMethods;
+ (NSDictionary *)attributesFactoriesForProperties;
+ (NSDictionary *)attributesFactoriesForIvars;
+ (NSArray *)attributesForClass;

#pragma mark -

@end
