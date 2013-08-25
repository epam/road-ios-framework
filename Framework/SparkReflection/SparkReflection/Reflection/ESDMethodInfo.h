//
//  ESDMethodInfo.h
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
 Contains information about a declared method of a given class.
 */
@interface ESDMethodInfo : NSObject

/**
 The name of the method.
 */
@property (copy, nonatomic) NSString *name;

/**
 The name of the class the method was declared to be a member of.
 */
@property (copy, nonatomic) NSString *className;

/**
 The number of arguments for the method.
 */
@property (assign, nonatomic) NSUInteger numberOfArguments;

/**
 The string value describing the return value's type.
 */
@property (copy, nonatomic) NSString *returnType;

/**
 Boolean value telling if the method was a class method.
 */
@property (assign, nonatomic, getter = isClassMethod) BOOL classMethod;

/**
 Returns an array of info objects for all the declared methods of the given class.
 @param aClass The class for which to return the method info.
 @result All info objects for the declared methods.
 */
+ (NSArray *)methodsOfClass:(__unsafe_unretained Class const)aClass;

/**
 Returns an info object corresponding to a class method of the given name.
 @param methodName The name of the method.
 @param aClass The class for which to return a method info.
 @result The info object.
 */
+ (ESDMethodInfo *)classMethodNamed:(NSString *)methodName forClass:(__unsafe_unretained Class const)aClass;

/**
 Returns an info object corresponding to an instance method of the given name.
 @param methodName The name of the method.
 @param aClass The class for which to return a method info.
 @result The info object.
 */
+ (ESDMethodInfo *)instanceMethodNamed:(NSString *)methodName forClass:(__unsafe_unretained Class const)aClass;

/**
 The type of the argument at the specified index.
 @param anIndex The index of the argument. If the index is out of range (not between 0 and number of arguments), the method throws an exception.
 @result The type string.
 */
- (NSString *)typeOfArgumentAtIndex:(NSUInteger const)anIndex;

@end
