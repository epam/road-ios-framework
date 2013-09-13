//
//  EntityDescription.h
//  ODataEntityGenerator
//
//  Created by  on 2012.03.06..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PropertyDescriptor;

/**
 Describes a class to generate.
 Contains basic information and properties.
 */
@interface EntityDescriptor : NSObject

/**
 the name of the class
 */
@property (copy, nonatomic) NSString *name;

/**
 the name of the entity or complex type
 */
@property (copy, nonatomic) NSString *entitySetName;

/**
 the type of the class to generate
 */
@property (copy, nonatomic) NSString *baseName;

/**
 marks whether the class is an abstract class
 */
@property (assign, nonatomic) BOOL isAbstract;

/**
 collection of properties of the class, instances of PropertyDescriptors
 */
@property (nonatomic, readonly) NSArray *properties;

/**
 Adds a property descriptor to the properties collection
 */
- (void)addProperty:(PropertyDescriptor *)property;

@end
