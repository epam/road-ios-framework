//
//  RFObjectPool.m
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


#import "RFObjectPool.h"
#import "RFPooledObject.h"

@implementation RFObjectPool {
    NSMutableDictionary *pool;
    NSMutableDictionary *map;
}

- (void)initialize {
    [super initialize];
    pool = [[NSMutableDictionary alloc] init];
    map = [[NSMutableDictionary alloc] init];
}

- (void)registerClassNamed:(NSString *)aClassName forIdentifier:(NSString *)reuseIdentifier {
    __unsafe_unretained const Class aClass = NSClassFromString(aClassName);
    
    if (aClass != Nil) {
        NSString *key = _caseSensitive ? reuseIdentifier : [reuseIdentifier lowercaseString];
        map[key] = NSClassFromString(aClassName);
    }
}

- (id)objectForIdentifier:(NSString *)anIdentifier {
    NSString *key = _caseSensitive ? anIdentifier : [anIdentifier lowercaseString];
    NSMutableSet *objectSet = pool[key];
    id<RFPooledObject> object = nil;
    
    if (objectSet == nil) {
        objectSet = [[NSMutableSet alloc] init];
        pool[key] = objectSet;
    }
    
    id<RFObjectPoolDelegate> strongDelegate = _delegate;
    if ([objectSet count] > 0) {
        object = [objectSet anyObject];
        [objectSet removeObject:object];
        
        if ([object respondsToSelector:@selector(prepareForReuse)]) {
            [object prepareForReuse];
        }
        if ([strongDelegate respondsToSelector:@selector(pool:didLendObject:forIdentifier:)]) {
            [strongDelegate pool:self didLendObject:object forIdentifier:anIdentifier];
        }
    }
    else {
        object = [[map[key] alloc] init];
        [object setPoolReuseIdentifier:key];
        [object setPool:self];
        
        if ([strongDelegate respondsToSelector:@selector(pool:didInstantiateObject:forIdentifier:)]) {
            [strongDelegate pool:self didInstantiateObject:object forIdentifier:anIdentifier];
        }
    }
    
    return object;
}

- (void)repoolObject:(id<RFPooledObject>)anObject {
    NSString * const reuseIdentifier = _caseSensitive ? [anObject poolReuseIdentifier] : [[anObject poolReuseIdentifier] lowercaseString];
    NSMutableSet *objectSet = pool[reuseIdentifier];
    
    if (objectSet == nil) {
        objectSet = [[NSMutableSet alloc] init];
        pool[reuseIdentifier] = objectSet;
    }
    
    id<RFObjectPoolDelegate> strongDelegate = _delegate;
    [objectSet addObject:anObject];
    if ([strongDelegate respondsToSelector:@selector(pool:didRepoolObjectForIdentifier:)]) {
        [strongDelegate pool:self didRepoolObjectForIdentifier:reuseIdentifier];
    }
}

@end
