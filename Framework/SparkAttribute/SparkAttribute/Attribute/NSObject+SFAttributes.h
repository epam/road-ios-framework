//
//  NSObject+SFAttributes.h
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

#import <Foundation/Foundation.h>

/**
 This category constains a set of methods which provides access to attributes declared by macros SF_ATTRIBUTE
 */
@interface NSObject (SFAttributes)

/**
 The method returns an array of attributes declared for method.
 
 @param methodName Name of method whose attributes are needed.

 @return An array of attributes.
*/
+ (NSArray *)SF_attributesForMethod:(NSString *)methodName;

/**
 The method returns an array of attributes declared for property.
 
 @param propertyName Name of property whose attributes are needed.
 
 @return An array of attributes.
*/
+ (NSArray *)SF_attributesForProperty:(NSString *)propertyName;

/**
 The method returns an array of attributes declared for instance variable.
 
 @param ivarName Name of instance variable whose attributes are needed.
 
 @return An array of attributes.
*/
+ (NSArray *)SF_attributesForIvar:(NSString *)ivarName;

/**
 The method returns an array of attributes declared for class.

 @return An array of attributes.
*/
+ (NSArray *)SF_attributesForClass;

/**
 The method performs search for attribute of required class in array of attributes declared for method.
 
 @param methodName Name of method.
 @param requiredClassOfAttribute Class of required attribute. 
 
 @return An object of attribute. Or nil if attribute was not found.
 */
+ (id)SF_attributeForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute;

/**
 The method performs search for attribute of required class in array of attributes declared for property.
 
 @param propertyName Name of property.
 @param requiredClassOfAttribute Class of required attribute.
 
 @return An object of attribute. Or nil if attribute was not found.
 */
+ (id)SF_attributeForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute;

/**
 The method performs search for attribute of required class in array of attributes declared for instance variable.
 
 @param ivarName Name of instance variable.
 @param requiredClassOfAttribute Class of required attribute.
 
 @return An object of attribute. Or nil if attribute was not found.
 */
+ (id)SF_attributeForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute;

/**
 The method performs search for attribute of required class in array of attributes declared for class.
 
 @param requiredClassOfAttribute Class of required attribute.
 
 @return An object of attribute. Or nil if attribute was not found.
 */
+ (id)SF_attributeForClassWithAttributeType:(Class)requiredClassOfAttribute;

/**
 The method checks whether attribute of required class has been declared for method.

 @param methodName Name of method.
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method searches for any attribute.
 
 @return YES if attribute exist. Or NO if attribute was not found.
 */
+ (BOOL)SF_hasAttributesForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute;

/**
 The method checks whether attribute of required class has been declared for property.
 
 @param propertyName Name of property.
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method searches for any attribute.
 
 @return YES if attribute exist. Or NO if attribute was not found.
 */
+ (BOOL)SF_hasAttributesForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute;

/**
 The method checks whether attribute of required class has been declared for instance variable.
 
 @param ivarName Name of instance variable.
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method searches for any attribute.
 
 @return YES if attribute exist. Or NO if attribute was not found.
 */
+ (BOOL)SF_hasAttributesForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute;

/**
 The method checks whether attribute of required class has been declared for class.
 
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method searches for any attribute.
 
 @return YES if attribute exist. Or NO if attribute was not found.
 */
+ (BOOL)SF_hasAttributesForClassWithAttributeType:(Class)requiredClassOfAttribute;

/**
 The method returns an array of object's properties where was declared attribute of required class.
 
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method gathers properties with any attribute.
 
 @return An array of properties.
 */
+ (NSArray *)SF_propertiesWithAttributeType:(Class)requiredClassOfAttribute;

/**
 The method returns an array of object's instance variables where was declared attribute of required class.
 
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method gathers instance variables with any attribute.
 
 @return An array of instance variables.
 */
+ (NSArray *)SF_ivarsWithAttributeType:(Class)requiredClassOfAttribute;

/**
 The method returns an array of object's methods where was declared attribute of required class.
 
 @param requiredClassOfAttribute Class of required attribute. If this variable is nil, method gathers methods with any attribute.
 
 @return An array of methods.
 */
+ (NSArray *)SF_methodsWithAttributeType:(Class)requiredClassOfAttribute;

@end
