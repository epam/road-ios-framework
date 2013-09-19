//
//  SFStreamWriter.m
//  SparkLogger
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

#import "SFStreamWriter.h"
#import "SFStreamDelegate.h"

#include <zlib.h>

@implementation SFStreamWriter {
    
    uint32_t            trailer;
    uint64_t            header;
    NSMutableSet        *streamDelegates;
}

- (id)initWithServices:(NSSet *)services {
    
    self = [super init];
    
    if (self) {
        
        streamDelegates = [NSMutableSet set];
        
        for (NSNetService *aService in services) {

            [self addService:aService];
        }
    }
    return self;
}

// Assembles the data packet from an archived log message and distributes it among all established connections
- (void)writeData:(NSData *)data {

    header = OSSwapHostToBigInt64([data length]);
    NSMutableData *buffer = [NSMutableData dataWithLength:0];
    [buffer appendBytes:&header length:sizeof(header)];
    [buffer appendData:data];
    
    uLong crc = crc32(0L, [data bytes], (uInt)[data length]);
    trailer = OSSwapHostToBigInt32((uint32_t)crc);
    [buffer appendBytes:&trailer length:sizeof(trailer)];
    
    for (SFStreamDelegate *aDelegate in streamDelegates) {
        
        [aDelegate addData:buffer];
    }
}

- (void)removeService:(NSNetService *)service {
    
    NSOutputStream *stream = nil;
    [service getInputStream:nil outputStream:&stream];
    SFStreamDelegate *delegateToRemove = nil;
    
    for (SFStreamDelegate *aDelegate in streamDelegates) {
        
        if ([[aDelegate stream] isEqual:stream]) {
            
            delegateToRemove = aDelegate;
        }
    }
    
    if (delegateToRemove) {

        [delegateToRemove stop];
        [streamDelegates removeObject:delegateToRemove];
    }
}

- (void)addService:(NSNetService *)service {
    
    NSOutputStream *stream = nil;
    if ([service getInputStream:nil outputStream:&stream]) {
        
        SFStreamDelegate *aDelegate = [[SFStreamDelegate alloc] initWithOutputStream:stream];
        [streamDelegates addObject:aDelegate];
        [aDelegate start];
    }
}

- (void)dealloc {
    
    for (SFStreamDelegate *aDelegate in streamDelegates) {
        
        [aDelegate stop];
    }
}

@end