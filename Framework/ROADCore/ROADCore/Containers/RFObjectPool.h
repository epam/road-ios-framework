//
//  RFObjectPool.h
//  ROADCore
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


typedef id(^RFObjectPoolInitializerBlock)(id objectCreated, id identifier);

/**
 * Generic object pool solution to provide reusing of objects that are either heavy to create, or are reused frequently.
 */
@interface RFObjectPool : NSObject

/**
 * Creates pool for storing objects of a particular type. If optional defaultObjectInitializer provided, a default objects can be created and set up automatcally. To create a pool for objects of any class use "init".
 * @param class       Class of the objects to be stored in a pool.
 * @param initializerBlock Initializer block for setting up newly created object. Optional.
 * @return New instance of a RFObjectPool.
 */
- (instancetype)initWithClass:(Class)class defaultObjectInitializer:(RFObjectPoolInitializerBlock)initializerBlock;

/**
 * Searches an object previously stored in a pool for key given.
 * @param reuseIdentifier Key of the object being searched.
 * @return Returns object previously stored if exists. Returns nil if object was not found for this key and there is no default object initializer given. If object was not found and default object initializer exists, a new instance of the class given will be created, stored in a poll and returned.
 */
- (id)objectForReuseIdentifier:(id<NSCopying>)reuseIdentifier;

/**
 * Adds or replaces object in a pool for a key specified.
 * @param object Object to be stored in a pool.
 * @param reuseIdentifier    Key for the object to be stored.
 */
- (void)setObject:(id)object forReuseIdentifier:(id<NSCopying>)reuseIdentifier;

/**
 * Removes object for a key specified.
 * @param key Key for the object to be removed.
 */
- (void)removeObjectForKey:(id<NSCopying>)key;

/**
 * Searches an object previously stored in a pool for key given in a modern way.
 * @param key Key of the object being searched.
 * @return Returns object previously stored if exists. Returns nil if object was not found for this key and there is no default object initializer given. If object was not found and default object initializer exists, a new instance of the class given will be created, stored in a poll and returned.
 */
- (id)objectForKeyedSubscript:(id <NSCopying>)key;

/**
 * Adds or replaces object in a pool for a key specified.
 * @param obj Object to be stored in a pool.
 * @param key Key for the object to be stored.
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/**
 * Frees pool memory.
 */
- (void)purge;

@end
