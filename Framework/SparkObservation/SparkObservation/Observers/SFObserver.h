//
//  SFObserver.h
//  ROADObservation
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

/**
 The handler block type to execute when the observer is triggered. Receives the old and the new value for the observed keypath.
 */
typedef void (^SFKeyValueHandlerBlock)(id oldValue, id newValue);

/**
 Wrapper class for the KVO observer pattern implementation in cocoa.
 */
@interface SFObserver : NSObject

/**
 The observed keypath the observer is subscribed to. Read-only.
 */
@property (copy, nonatomic, readonly) NSString *keyPath;

/**
 The observation target. You are allowed to change this to a new value once the observation has started, in which case the observer will continue to observe the keypath for the new target. Specifying nil will cause the observation to stop, and the deallocation block is invoked if specified.
 */
@property (weak, nonatomic) id observationTarget;

/**
 Convenience initializer.
 @param aTarget The target to observe. Cannot be nil.
 @param aKeyPath The keypath to observe on the target. Cannot be nil.
 @param aHandler The block to invoke when the observer is triggered.
 */
- (id)initWithTarget:(id const)aTarget keyPath:(NSString * const)aKeyPath handler:(SFKeyValueHandlerBlock)aHandler;

/**
 Designated initializer.
 @param aTarget The target to observe. Cannot be nil.
 @param aKeyPath The keypath to observe on the target. Cannot be nil.
 @param aHandler The block to invoke when the observer is triggered.
 @param aDeallocBlock The block to invoke when the target changes to nil (it is either deallocated or the observer is redirected to a nil target).
 */
- (id)initWithTarget:(id const)aTarget keyPath:(NSString * const)aKeyPath handler:(SFKeyValueHandlerBlock)aHandler deallocatonHanlder:(void (^)(void))aDeallocBlock;

/**
 Factory method.
 @param aTarget The target to observe. Cannot be nil.
 @param aKeypath The keypath to observe on the target. Cannot be nil.
 @param aHandler The block to invoke when the observer is triggered.
*/
+ (SFObserver *)observerForTarget:(id const)aTarget keyPath:(NSString * const)aKeypath handler:(SFKeyValueHandlerBlock)aHandler;

@end
