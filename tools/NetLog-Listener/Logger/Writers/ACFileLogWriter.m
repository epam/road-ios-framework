//
//  ACLoggerFileWriter.m
//  APPA-Core
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


#import "ACFileLogWriter.h"


@implementation ACFileLogWriter {
    NSString *filePath;
    NSFileHandle *aFileHandle;
}

@synthesize atomic;

- (id)initWithFilePath:(NSString *)aPath {
    
    self = [super init];
    
    if (self) {
        
        filePath = aPath;
    }
    
    return self;
}

- (void)logValidMessage:(ACLogMessage *)message {
    
    if (atomic) {
        [self logValidMessageAtomically:message];
    }
    else {
        [self logValidMessageNonatomically:message];
    }
}

- (void)logValidMessageAtomically:(ACLogMessage *)message {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
       
        if (aFileHandle == nil) {
            aFileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        }
        [aFileHandle seekToEndOfFile];
        
        [aFileHandle writeData:[[self formattedMessage:message] dataUsingEncoding:NSUTF8StringEncoding]];
    });
}

- (void)closeFile {
    
    [aFileHandle closeFile];
    aFileHandle = nil;
}

- (void)logValidMessageNonatomically:(ACLogMessage *)message {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSFileHandle *handle;
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO) {
            
            handle = [NSFileHandle fileHandleForWritingAtPath:filePath];
        }
        else {
            
            handle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
            [handle seekToEndOfFile];
        }
        
        [handle writeData:[[self formattedMessage:message] dataUsingEncoding:NSUTF8StringEncoding]];
        [handle closeFile];
    });

}

- (NSString *)filePath {
    
    return filePath;
}

- (void)dealloc {
    [self closeFile];
}

@end
