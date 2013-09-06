//
//  SFPropertyInfo.h
//  SparkReflection
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


/**
 Contains information about a declared property.
 */
@interface SFPropertyInfo : NSObject

/**
 The property's name.
 */
@property (copy, nonatomic) NSString *propertyName;

/**
 The name of the host class.
 */
@property (copy, nonatomic) NSString *className;

/**
 The type of the host class.
 */
@property (assign, nonatomic) Class hostClass;

/**
 The name of the class or variable type of the property declaration.
 */
@property (copy, nonatomic) NSString *attributeClassName;

/**
 The name of the setter method.
 */
@property (copy, nonatomic) NSString *setterName;

/**
 The name of the getter method.
 */
@property (copy, nonatomic) NSString *getterName;

/**
 Boolean property telling whether the property's implementatin is done via the @dynamic directive.
 */
@property (nonatomic, getter = isDynamic) BOOL dynamic;

/**
 Boolean property telling whether the property is weak.
 */
@property (nonatomic, getter = isWeak) BOOL weak;

/**
 Boolean property telling whether the property is nonatomic.
 */
@property (nonatomic, getter = isNonatomic) BOOL nonatomic;

/**
 Boolean property telling whether the property is strong.
 */
@property (nonatomic, getter = isStrong) BOOL strong;

/**
 Boolean property telling whether the property is readonly.
 */
@property (nonatomic, getter = isReadonly) BOOL readonly;

/**
 Boolean property telling whether the property is copying.
 */
@property (nonatomic, getter = isCopied) BOOL copied;

/**
 Boolean property telling whether the property is pointing to an object instead of a primitive value.
 */
@property (nonatomic, getter = isObject) BOOL object;

/**
 The declared class of the property if applicable.
 For primitive types this is Nil.
 */
@property (nonatomic, unsafe_unretained) Class attributeClass;

/**
 Returns an array of info objects for the given class.
 @param aClass The class to fetch the property infos for.
 @result The array of filtered results.
 */
+ (NSArray * const)propertiesForClass:(__unsafe_unretained Class const)aClass;

/**
 Returns an array of info objects for the given class filtered with the predicate.
 @param aClass The class to fetch the infos for.
 @param aPredicate The predicate to apply before returning the results.
 @result The array of filtered results.
 */
+ (NSArray *)propertiesForClass:(__unsafe_unretained Class const)aClass withPredicate:(NSPredicate * const)aPredicate;

/**
 Fetches the specific info object corresponding to the property named for the given class.
 @param name The name of the property field.
 @param aClass The class to fetch the result for.
 @result The info object.
 */
+ (SFPropertyInfo *)propertyNamed:(NSString *)name forClass:(__unsafe_unretained Class const)aClass;

@end
