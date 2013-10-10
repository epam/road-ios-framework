//
//  RFObserver.m
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

#import "RFObserver.h"

static NSString * const kRFObserverTargetKeyPath = @"target";

@implementation RFObserver {
    RFKeyValueHandlerBlock _callback;
    void (^_deallocHandler)(void);
}

- (id)initWithTarget:(id const)aTarget keyPath:(NSString *const)aKeyPath handler:(RFKeyValueHandlerBlock)aHandler deallocatonHanlder:(void (^)(void))aDeallocBlock {
    self = [super init];
    
    if (self) {
        _callback = [aHandler copy];
        _deallocHandler = [aDeallocBlock copy];
        _keyPath = [aKeyPath copy];
        [aTarget addObserver:self forKeyPath:aKeyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        [self addObserver:self forKeyPath:kRFObserverTargetKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
        _observationTarget = aTarget;
    }
    
    return self;
}

- (id)initWithTarget:(id const)aTarget keyPath:(NSString *const)aKeyPath handler:(RFKeyValueHandlerBlock)aHandler {
    return [self initWithTarget:aTarget keyPath:aKeyPath handler:aHandler deallocatonHanlder:NULL];
}

+ (RFObserver *)observerForTarget:(id const)aTarget keyPath:(NSString * const)aKeypath handler:(RFKeyValueHandlerBlock)aHandler {
    return [[self alloc] initWithTarget:aTarget keyPath:aKeypath handler:aHandler];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:kRFObserverTargetKeyPath] && [object isEqual:self]) {
        [change[NSKeyValueChangeOldKey] removeObserver:self forKeyPath:_keyPath];
        
        if (change[NSKeyValueChangeNewKey] == nil && _deallocHandler != NULL) {
            _deallocHandler();
        }
        else {
            [change[NSKeyValueChangeNewKey] addObserver:self forKeyPath:_keyPath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
        }
    }
    else {
        _callback(change[NSKeyValueChangeOldKey], change[NSKeyValueChangeNewKey]);
    }
}

- (void)dealloc {
    [_observationTarget removeObserver:self forKeyPath:_keyPath];
    [self removeObserver:self forKeyPath:kRFObserverTargetKeyPath];
}

@end
