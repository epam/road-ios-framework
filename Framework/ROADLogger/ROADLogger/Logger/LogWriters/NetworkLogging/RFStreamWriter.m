//
//  RFStreamWriter.m
//  ROADLogger
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

#import "RFStreamWriter.h"
#include <zlib.h>

#import "RFStreamDelegate.h"

@implementation RFStreamWriter {
    NSMutableSet *_streamDelegates;
}

- (id)initWithServices:(NSSet *)services {
    
    self = [super init];
    
    if (self) {
        
        _streamDelegates = [NSMutableSet set];
        
        for (NSNetService *aService in services) {

            [self addService:aService];
        }
    }
    return self;
}

// Assembles the data packet from an archived log message and distributes it among all established connections
- (void)writeData:(NSData *)data {
    uint64_t header = OSSwapHostToBigInt64([data length]);
    NSMutableData *buffer = [NSMutableData dataWithLength:0];
    [buffer appendBytes:&header length:sizeof(header)];
    [buffer appendData:data];
    
    uLong crc = crc32(0L, [data bytes], (uInt)[data length]);
    uint32_t trailer = OSSwapHostToBigInt32((uint32_t)crc);
    [buffer appendBytes:&trailer length:sizeof(trailer)];
    
    for (RFStreamDelegate *aDelegate in _streamDelegates) {
        
        [aDelegate addData:buffer];
    }
}

- (void)removeService:(NSNetService *)service {
    
    NSOutputStream *stream = nil;
    [service getInputStream:nil outputStream:&stream];
    RFStreamDelegate *delegateToRemove = nil;
    
    for (RFStreamDelegate *aDelegate in _streamDelegates) {
        
        if ([[aDelegate stream] isEqual:stream]) {
            
            delegateToRemove = aDelegate;
        }
    }
    
    if (delegateToRemove) {

        [delegateToRemove stop];
        [_streamDelegates removeObject:delegateToRemove];
    }
}

- (void)addService:(NSNetService *)service {
    
    NSOutputStream *stream = nil;
    if ([service getInputStream:nil outputStream:&stream]) {
        
        RFStreamDelegate *aDelegate = [[RFStreamDelegate alloc] initWithOutputStream:stream];
        [_streamDelegates addObject:aDelegate];
        [aDelegate start];
    }
}

- (void)dealloc {
    
    for (RFStreamDelegate *aDelegate in _streamDelegates) {
        
        [aDelegate stop];
    }
}

@end