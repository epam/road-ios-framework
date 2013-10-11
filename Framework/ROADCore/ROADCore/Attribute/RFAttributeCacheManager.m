//
//  RFAttributeCacheManager.m
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

#import "RFAttributeCacheManager.h"
#import <UIKit/UIKit.h>

@implementation RFAttributeCacheManager {
    NSMutableDictionary * _sharedCache;
    /**
     The queue to work on. http://stackoverflow.com/questions/12511976/app-crashes-after-xcode-upgrade-to-4-5-assigning-retained-object-to-unsafe-unre
     */
#if OS_OBJECT_USE_OBJC
    dispatch_queue_t _queue; // this is for Xcode 4.5 with LLVM 4.1 and iOS 6 SDK
#else
    dispatch_queue_t _queue; // this is for older Xcodes with older SDKs
#endif
}

+ (NSMutableDictionary *)attributeCache {
    static dispatch_once_t onceToken;
    static id sharedCacheManager = nil;
    dispatch_once(&onceToken, ^{
        sharedCacheManager = [[self alloc] init];
    });
    
    return [sharedCacheManager sharedCache];
}

- (id)init
{
    self = [super init];
    if (self) {
        _queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
        _sharedCache = [[NSMutableDictionary alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRecieveMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (NSMutableDictionary *)sharedCache {
    __block id cache;
    dispatch_sync(_queue, ^{
        cache = _sharedCache;
    });
    
    return cache;
}

- (void)didRecieveMemoryWarning {
    dispatch_sync(_queue, ^{
        [_sharedCache removeAllObjects];
    });
}

@end
