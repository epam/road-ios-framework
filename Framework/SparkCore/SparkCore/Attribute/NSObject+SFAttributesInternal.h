//
//  NSObject+SFAttributesInternal.h
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

#import <Foundation/Foundation.h>

/**
 This category constains a set of methods which used by generated code.
 
 **No one of this methods should not used by developer directly.**
 
*/

@interface NSObject (SFAttributesInternal)

#pragma mark Internal API
/**
 Creates NSInvocation object for given selector.
 @param selector A selector for NSInvocation object
 @return NSInvocation object for given selector.
 */
+ (NSInvocation *)SF_invocationForSelector:(SEL)selector;

#pragma mark Will be overridden in generated code
/**
 Returns a dictionary which consists from method's names as keys and NSInvocation objects as values.
 NSInvocation object points to a method which creates array of attribute objects declared for method specified in dictionary.
 @return a dictionary which consists from method's names as keys and NSInvocation objects as values. Or nil if methods have no declarations
 */
+ (NSMutableDictionary *)SF_attributesFactoriesForMethods;
/**
 Returns a dictionary which consists from property's names as keys and NSInvocation objects as values.
 NSInvocation object points to a method which creates array of attribute objects declared for property specified in dictionary.
 @return a dictionary which consists from property's names as keys and NSInvocation objects as values. Or nil if properties have no declarations
 */
+ (NSMutableDictionary *)SF_attributesFactoriesForProperties;
/**
 Returns a dictionary which consists from instance variable's names as keys and NSInvocation objects as values.
 NSInvocation object points to a method which creates array of attribute objects declared for instance variable specified in dictionary.
 @return a dictionary which consists from instance variable's names as keys and NSInvocation objects as values. Or nil if instance variables have no declarations
 */
+ (NSMutableDictionary *)SF_attributesFactoriesForIvars;

#pragma mark -

@end
