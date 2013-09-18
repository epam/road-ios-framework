//
//  SFIvarInfo.h
//  SparkCore
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
 Represents an ivar in any given class.
 */
@interface SFIvarInfo : NSObject

/**
 The name of the ivar.
 */
@property (copy, nonatomic) NSString *name;

/**
 The name of the type of the variable.
 */
@property (assign, nonatomic) NSString *variableTypeName;

/**
 Boolean value telling whether the ivar was of primitive (value) type or not.
 */
@property (assign, nonatomic, getter = isPrimitive) BOOL primitive;

/**
 The name of the class to which the ivar belongs to.
 */
@property (copy, nonatomic) NSString *className;

/**
 The type of the host class.
 */
@property (assign, nonatomic) Class hostClass;

/**
 An array of attributes declared for instance variable.
 */
@property (readonly, nonatomic) NSArray *attributes;

/**
 Returns an array of info objects.
 @param aClass The class to return the list of infos to.
 @result An array of info objects.
 */
+ (NSArray *)ivarsOfClass:(__unsafe_unretained Class const)aClass;

/**
 Returns an info objects for the given ivar name.
 @param ivarName The name of the ivar.
 @param aClass The class to which the ivar belongs to.
 @result The info object.
 */
+ (SFIvarInfo *)SF_ivarNamed:(NSString * const)ivarName ofClass:(__unsafe_unretained Class const)aClass;

/**
 The method performs search for attribute of required class in array of attributes declared for instance variable.
 
 @param requiredClassOfAttribute Class of required attribute.
 
 @return An object of attribute. Or nil if attribute was not found.
 */
- (id)attributeWithType:(Class)requiredClassOfAttribute;

@end
