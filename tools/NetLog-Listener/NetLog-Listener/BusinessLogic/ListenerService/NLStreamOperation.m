//
//  NLStreamOperation.m
//  NetLog-Listener
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


#import "NLStreamOperation.h"
#import "NLLogMessageWrapper.h"
#import "ACLogMessage.h"
#include <sys/socket.h>
#include <netinet/in.h>
#include <zlib.h>

NSString * const kNLIsExecturing = @"isExecuting";
NSString * const kNLIsFinished = @"isFinished";

typedef enum {
    kOperationStatusInitialized, 
    kOperationStatusExecuting, 
    kOperationStatusFinished
} OperationStatus;

typedef enum {
    kReceiveStatusStart, 
    kReceiveStatusHeader, 
    kReceiveStatusBody, 
    kReceiveStatusTrailer
} ReceiveStatus;

enum {
    kReceiveBufferSize = 32768
};

@interface NLStreamOperation () <NSStreamDelegate>

@property (copy, nonatomic) NSString *connectionUniqueId;

- (void)finishReading;

- (void)processHeaderBuffer;

- (void)setupNextReceiveBuffer;

- (void)processBodyBuffer;

- (void)prepareForClose;

- (void)didReceiveData;

- (void)reset;

@end

@implementation NLStreamOperation {
    NSMutableData *buffer;
    NSMutableData *dataReceived;
    NSUInteger bufferOffset;
    ReceiveStatus receiveStatus;
    uLong crc;
    uint64_t dataLength;
    uint64_t dataOffset;
    NSInputStream *inputStream;
    OperationStatus operationStatus;
}

@synthesize delegate;
@synthesize connectionUniqueId;

#pragma mark -
#pragma mark Lifecycle
#pragma mark -

- (id)initWithInputStream:(NSInputStream *)anInputStream {
    self = [super init];
    
    if (self) {
        inputStream = anInputStream;
        receiveStatus = kReceiveStatusStart;
        [self setOperationStatus:kOperationStatusInitialized];
    }
    
    return self;
}

#pragma mark -
#pragma mark Class extensions
#pragma mark -

- (void)setOperationStatus:(OperationStatus)newStatus {
    [self willChangeValueForKey:kNLIsExecturing];
    [self willChangeValueForKey:kNLIsFinished];
    
    operationStatus = newStatus;
    
    [self didChangeValueForKey:kNLIsExecturing];
    [self didChangeValueForKey:kNLIsFinished];
}

- (void)reset {
    buffer = [[NSMutableData alloc] initWithCapacity:kReceiveBufferSize];
    dataReceived = [[NSMutableData alloc] init];
    
    receiveStatus = kReceiveStatusStart;
    [self setOperationStatus:kOperationStatusExecuting];
    
    bufferOffset = 0;
    crc = 0;
    dataLength = 0;
    dataOffset = 0;
}

- (void)finishReading {
    buffer = nil;
    dataReceived = nil;
    inputStream = nil;
    [self setOperationStatus:kOperationStatusFinished];
    bufferOffset = 0;
    crc = 0;
    dataLength = 0;
    dataOffset = 0;
}

- (void)prepareForClose {

    if (inputStream != nil) {
        
        inputStream.delegate = nil;
        [inputStream removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        [inputStream close];
        inputStream = nil;
    }
    
    [delegate streamOperation:self willCloseConnectionWithUniqueId:connectionUniqueId];    
    [self finishReading];
}

- (void)processHeaderBuffer {
    
    assert([buffer length] == sizeof(uint64_t));
    dataLength = OSSwapBigToHostInt64(*(const uint64_t *) [buffer bytes]);
}

- (void)setupNextReceiveBuffer {
    
    if (dataOffset < dataLength) {
        
        off_t bytesRemaining = dataLength - dataOffset;
        
        if (bytesRemaining > (off_t) kReceiveBufferSize) {
            bytesRemaining = kReceiveBufferSize;
        }
        
        [buffer setLength:(NSUInteger) bytesRemaining];
        
        receiveStatus = kReceiveStatusBody;
    }
    else {
        [buffer setLength:sizeof(uint32_t)];
        receiveStatus = kReceiveStatusTrailer;
    }
}

- (void)processBodyBuffer {
    
    crc = crc32(crc, [buffer bytes], (uInt) [buffer length]);
    [dataReceived appendBytes:[buffer bytes] length:[buffer length]];
    dataOffset += [buffer length];
}

- (void)processTrailerBuffer {
    uint32_t crcReceived;
    
    assert([buffer length] == sizeof(uint32_t));
    
    crcReceived = OSSwapBigToHostInt32(*(const uint32_t *) [buffer bytes]);
    
    // in case of a crc error we simply drop the packet
    if (crcReceived == crc) {
        [self didReceiveData];
    }
    
    [self reset];
}

- (void)didReceiveData {    
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:dataReceived];
    NLLogMessageWrapper *unarchivedMessage = [unarchiver decodeObject];
    
    if ([connectionUniqueId length] == 0) {
        self.connectionUniqueId = unarchivedMessage.uniqueId;
    }
    
    [delegate finishedReadingLogMessage:unarchivedMessage];
}

#pragma mark -
#pragma mark Overrides
#pragma mark -

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return operationStatus == kOperationStatusExecuting;
}

- (BOOL)isFinished {
    return operationStatus == kOperationStatusFinished;
}

- (void)start {
    if (![self isCancelled]) {
        buffer = [[NSMutableData alloc] initWithCapacity:kReceiveBufferSize];
        dataReceived = [[NSMutableData alloc] init];
        
        receiveStatus = kReceiveStatusStart;
        [self setOperationStatus:kOperationStatusExecuting];
        
        assert(buffer != nil);
        assert(receiveStatus == kReceiveStatusStart);
        assert(bufferOffset == 0);
        assert(crc == 0);
        assert([NSThread currentThread] != [NSThread mainThread]);
        assert([NSRunLoop currentRunLoop] != [NSRunLoop mainRunLoop]);
        
        inputStream.delegate = self;
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
            
        [self main];
    }
    else {
        [self finishReading];
    }
}

- (void)main {
    
    while (![self isCancelled] && ![self isFinished]) {
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        }
    }
}

- (void)cancel {
    
    [self prepareForClose];
    [super cancel];
}

#pragma mark -
#pragma mark NSStreamDelegate
#pragma mark -

- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode {

    assert(aStream == inputStream);
    
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
            break;
        case NSStreamEventHasSpaceAvailable:
            assert(NO);
            break;
        case NSStreamEventHasBytesAvailable: {
            NSInteger bytesRead;
            
            if (receiveStatus == kReceiveStatusStart) {
                assert(bufferOffset == 0);
                [buffer setLength:sizeof(uint64_t)];
                receiveStatus = kReceiveStatusHeader;
            }
            
            assert(bufferOffset < [buffer length]);
            
            bytesRead = [inputStream read:((uint8_t *) [buffer mutableBytes]) + bufferOffset maxLength:[buffer length] - bufferOffset];
            
            if (bytesRead < 0) {
                assert([inputStream streamError] != nil);
                [self reset];
            } else if (bytesRead == 0) {
                [self reset];
            } else {
                assert(bytesRead > 0);
                
                bufferOffset += bytesRead;
                
                if (bufferOffset == [buffer length]) {
                    bufferOffset = 0;
                    
                    switch (receiveStatus) {
                        case kReceiveStatusStart:
                            assert(NO);
                            break;
                        case kReceiveStatusHeader:
                            [self processHeaderBuffer];
                            [self setupNextReceiveBuffer];
                            break;
                        case kReceiveStatusBody: {
                            [self processBodyBuffer];
                            
                            if (![self isFinished]) {
                                [self setupNextReceiveBuffer];
                            }
                        } break;
                        case kReceiveStatusTrailer:
                            [self processTrailerBuffer];
                            break;
                    }
                }
            }
        } break;
        case NSStreamEventErrorOccurred:
            assert([inputStream streamError] != nil);
            [self reset];
            break;
        case NSStreamEventEndEncountered:
            [self prepareForClose];
            break;
        default:
            assert(NO);
            break;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Operation for stream: %@", inputStream];
}

@end
