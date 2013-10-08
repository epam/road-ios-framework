//
//  SFFileLogWriter.m
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "SFFileLogWriter.h"

@implementation SFFileLogWriter {
    NSFileHandle *handle;
    NSString *filePath;
}

+ (SFFileLogWriter *)writerWithPath:(NSString * const)path {
    SFFileLogWriter *writer = [[SFFileLogWriter alloc] init];
    writer->filePath = [path copy];
    return writer;
}

- (void)logQueue {
    dispatch_async(self.queue, ^{
        [self openFile];
        [handle seekToEndOfFile];
        
        NSArray *queueCopy = [self.messageQueue copy];
        
        NSMutableString *packet = [NSMutableString string];
        for (SFLogMessage *message in queueCopy) {
            [packet appendFormat:@"%@\n", [self formattedMessage:message]];
        }
        
        [self.messageQueue removeAllObjects];
        
        [handle writeData:[packet dataUsingEncoding:NSUTF8StringEncoding]];
        [self closeFile];
    });
}

- (void)logValidMessage:(SFLogMessage * const)aMessage {
    dispatch_async(self.queue, ^{
        [self openFile];
        [handle seekToEndOfFile];
        NSString * const packet = [self formattedMessage:aMessage];
        [handle writeData:[packet dataUsingEncoding:NSUTF8StringEncoding]];
        [self closeFile];
    });
}

- (void)openFile {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    handle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
}

- (void)closeFile {
    [handle synchronizeFile];
    [handle closeFile];
}

@end
