//
//  NSObject+RFMemberVariableReflection.h
//  ROADCore
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing


#import <Foundation/Foundation.h>
#import "RFIvarInfo.h"

/**
 Category to retrieve member variable info objects from either a class or an instance of a class.
 */
@interface NSObject (RFMemberVariableReflection)

/**
 Returns the info object corresponding to the instance variable of the given name.
 @param name The name of the ivar.
 @result The info object.
 */
+ (RFIvarInfo *)RF_ivarNamed:(NSString *)name;

/**
 Returns all info objects corresponding to the instance variable of the given name.
 @result The ivar info objects.
 */
+ (NSArray *)RF_ivars;

/**
 Returns the info object corresponding to the instance variable of the given name. Invoked on an instance of a class.
 @param name The name of the ivar.
 @result The info object.
 */
- (RFIvarInfo *)RF_ivarNamed:(NSString *)name;

/**
 Returns all info objects corresponding to the instance variable of the given name. Invoked on an instance of a class.
 @result The ivar info objects.
 */
- (NSArray *)RF_ivars;

@end
