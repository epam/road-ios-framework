//
//  SFPooledObject.h
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

@class SFObjectPool;

/**
 Protocol to implement for pooled object.
 */
@protocol SFPooledObject <NSObject>

/**
 The resuse identifier of the object. Managed by the SFObjectPool class.
 */
@property (copy, nonatomic) NSString *poolReuseIdentifier;

/**
 The object pool the implementing object is bound to. Convenience weak reference used in conjunction with the repool method, to invoke the pool's -repoolObject: method.
 If this method can be invoked with a different solution, then using this property is optional. Setting this property is the responsibility of the object pool itself.
 */
@property (weak, nonatomic) SFObjectPool *pool;

/**
 Invoke this method when you are done with the object and allow the pool to reclaim this instance.
 */
- (oneway void)repool;

@optional
/**
 Invoked by the object pool when the object is about to be reused by the pool. Optional method.
 */
- (void)prepareForReuse;

@end
