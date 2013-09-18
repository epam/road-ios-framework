//
//  SFObjectPool.h
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
#import "SFObject.h"

@protocol SFPooledObject;
@class SFObjectPool;

/**
 Object pool delegate protocol. Contains notification methods to inform its delegate about pooled object management. All methods in this protocol are optional.
 */
@protocol SFObjectPoolDelegate <NSObject>

@optional
/**
 Informs the delegate that an object was repooled.
 @param pool The pool sending the message.
 @param anIdentifier The identifier for which the object was repooled.
 */
- (void)pool:(SFObjectPool * const)pool didRepoolObjectForIdentifier:(NSString * const)anIdentifier;

/**
 Informs the delegate that a new object was created for an identifier.
 @param pool The pool sending the message.
 @param anObject The newly created object.
 @param anIdentifier The identifier for which the object was created.
 */
- (void)pool:(SFObjectPool * const)pool didInstantiateObject:(id<SFPooledObject> const)anObject forIdentifier:(NSString * const)anIdentifier;

/**
 Informs the delegate that an object was removed from the pool as it was requested.
 @param pool The pool sending the message.
 @param anIdentifier The identifier for which the object was requested.
 @param anObject The newly created object.

 */
- (void)pool:(SFObjectPool * const)pool didLendObject:(id<SFPooledObject> const)anObject forIdentifier:(NSString * const)anIdentifier;

@end

/**
 Generic object pool solution to provide reusing of objects that are either heavy to create, or are reused frequently.
 */
@interface SFObjectPool : SFObject

/**
 The pool's delegate.
 */
@property (weak, nonatomic) id<SFObjectPoolDelegate> delegate;

/**
 Indicates if the reuse identifiers are case sensitive or not.
 */
@property (assign, nonatomic, getter = isCaseSensitive) BOOL caseSensitive;

/**
 Puts an object instance of a registered class back into the object pool.
 @param anObject The object to put back into the appropriate object pool.
 */
- (void)repoolObject:(id<SFPooledObject> const)anObject;

/**
 Returns an object for the specified pool reuse identifier. Note, this also removes the object from the pool until it is repooled, therefore you have to make sure to keep it alive via a strong reference.
 @param anIdentifier The unique pool reuse identifier.
 */
- (id)objectForIdentifier:(NSString * const)anIdentifier;

/**
 Registers a class to be available for pooling.
 @param aClassName The name of the class to be registered.
 @param reuseIdentifier The identifier associated with the given class. Note: the id has to be unique, overriding the same identifier with this method will raise an exception.
 */
- (void)registerClassNamed:(NSString * const)aClassName forIdentifier:(NSString * const)reuseIdentifier;

@end
