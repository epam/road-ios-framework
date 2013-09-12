//
//  PropertyDescriptor.h
//  ODataEntityGenerator
//
//  Created by  on 2012.03.06..
//  Copyright (c) 2012 EPAM Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Describes a property of a class
 */
@interface PropertyDescriptor : NSObject

/**
 Name of the property
 */
@property (copy, nonatomic) NSString *name;

/**
 marks whether the property is a nullable property
 */
@property (assign, nonatomic) BOOL nullable;

/**
 the type of the property
 */
@property (copy, nonatomic) NSString* typeName;

/**
 Property is fixed length
 */
@property (assign, nonatomic) int fixedLength;

/**
 Specifies the max length of the property or the length of the associated class collection
 */
@property (assign, nonatomic) int maxLength;

/**
 precision of a number
 */
@property (assign, nonatomic) int precision;

/**
 marks whether a property supports unicode string
 */
@property (assign, nonatomic) BOOL isUnicode;

/**
 marks whether the property is an association with another class
 */
@property (assign, nonatomic) BOOL isAssociationProperty;

/**
 marks whether the property is a collection/array of elements
 */
@property (assign, nonatomic) BOOL isCollection;

/**
 Association name for navigation properties
 */
@property (strong, nonatomic) NSString *association;

@end
