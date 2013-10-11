//
//  RFStreamDelegate.m
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

#import "RFStreamDelegate.h"

@implementation RFStreamDelegate {
    
    NSOutputStream *stream;
    NSMutableSet *bufferedData;
    NSThread *thread;
    BOOL isCancelled;
}

@synthesize hasSpaceAvailable;

// Initiates a background thread for broadcasting and sets up the message buffer.
- (id)initWithOutputStream:(NSOutputStream *)aStream {
    
    self = [super init];
    
    if (self) {
        
        stream = aStream;
        thread = [[NSThread alloc] initWithTarget:self
                                         selector:@selector(startBroadcasting)
                                           object:nil];
        thread.name = [NSString stringWithFormat:@"Logging thread for stream %@", stream];
        bufferedData = [NSMutableSet set];
    }
    return self;
}

// Starts the broadcasting, schedules the stream in the current background thread's runloop.
- (void)startBroadcasting {
    
    [stream setDelegate:self];
    [stream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [stream open];
    
    [self keepThreadAlive];
}

// Keeps the logging thread alive until it is stopped
- (void)keepThreadAlive {
    
    while (!isCancelled) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [self processStoredBuffers];
    }
    
    if (isCancelled) {
        
        stream.delegate = nil;
        [stream close];
        [stream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
}

- (void)stop {
    isCancelled = YES;
}

- (void)start {
    isCancelled = NO;
    [thread start];
}

// Adds a datapacked to the local buffer and attempts to write it to the stream.
- (void)addData:(NSData *)packet {
    
    @synchronized (bufferedData) {
        [bufferedData addObject:packet];
    }
}

// Checks if the stream has space available and if so it attempts to write the entire data buffer into it
- (void)processStoredBuffers {
    
    if (hasSpaceAvailable) {
        
        for (NSData *aBuffer in [bufferedData copy]) {
            
            [stream write:(const uint8_t *)[aBuffer bytes] maxLength:[aBuffer length]];
        }
    }
    
    @synchronized(bufferedData) {
        [bufferedData removeAllObjects];
    }
}

- (void)finishWithError:(NSError *)error {
    
}

- (NSOutputStream *)stream {
    
    return stream;
}

- (void)dealloc {
    if (!isCancelled) {
        [self stop];
    }
}

#pragma mark - Stream delegate method

// Stream delegate callback method
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {
    
    hasSpaceAvailable = NO;
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted: {
            // do nothing
        } break;
        case NSStreamEventHasBytesAvailable: {
            assert(NO);
        } break;
        case NSStreamEventHasSpaceAvailable: {
            hasSpaceAvailable = YES;
            [self processStoredBuffers];
        } break;
        case NSStreamEventErrorOccurred: {
            assert([aStream streamError] != nil);
            [self finishWithError:[aStream streamError]];
        } break;
        case NSStreamEventEndEncountered: {
            assert(NO);
        } break;
        default: {
            assert(NO);
        } break;
    }
}

@end
