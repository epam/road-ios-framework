//
//  NLChain.h
//  NetLog-Listener
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
 Represents nested (chained) collections ordered into a hierarchy.
 */
@interface NLChain : NSObject

/**
 A unique identifier for the given container.
 */
@property (copy, nonatomic) NSString *containerIdentifier;

/**
 Designated initializer.
 */
- (id)initWithIdentifier:(NSString *)anIdentifier;

/**
 Adds a new NLChain collection as a nested collection with the given identifier.
 */
- (NLChain *)childContainerWithIdentifier:(NSString *)anIdentifier;

/**
 Adds an object to the chained hierarchy by looking for the collection with the specified identifier.
 If no such collection is found, a new one is added at the end of the hierarchy with the id given and stores the object in the new collection.
 */
- (void)addObject:(id)object forIdentifier:(NSString *)anIdentifier;

/**
 Returns the array of objects from the collection with the specified identifier and all other objects from its child hierarchy in a cumulative manner.
 */
- (NSArray *)objectsForIdentifier:(NSString *)anIdentifier;

/**
 Removes all objects from the collection with the identifier in the hierarchy and from its child collections.
 */
- (void)removeAllObjectsForIdentifier:(NSString *)anIdentifier;

#pragma mark - Class methods

/**
 Convenience constructor to create an entire hierarchy of nested collections based on the id array. The hierarchy will follow the order of ids in the array.
 */
+ (NSArray *)chainHierarchyForIdentifiers:(NSArray *)arrayOfIds;

@end
