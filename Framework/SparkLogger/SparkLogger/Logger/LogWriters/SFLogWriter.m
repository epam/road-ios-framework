//
//  SFLogWriter.m
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

#import "SFLogWriter.h"

#import "SFFileLogWriter.h"
#import "SFConsoleLogWriter.h"
#import "SFLogMessage.h"
#import "SFLogFilter.h"
#import "SFLogFormatter.h"

#if (TARGET_OS_IPHONE)
#import <UIKit/UIKit.h>
#elif (TARGET_OS_MAC)
#import <AppKit/NSApplication.h>
#endif

@implementation SFLogWriter {
    NSMutableSet *_filters;
}

#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        _filters = [[NSMutableSet alloc] init];
        _queueSize = 1;
        _messageQueue = [[NSMutableArray alloc] initWithCapacity:_queueSize];
        _queue = dispatch_queue_create(NULL, DISPATCH_QUEUE_SERIAL);
#if (TARGET_OS_IPHONE)
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logQueueBeforeExit) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logQueueBeforeExit) name:UIApplicationWillTerminateNotification object:nil];
#elif (TARGET_OS_MAC)
        // Data saving strategy according to
        // https://developer.apple.com/library/mac/#documentation/General/Conceptual/MOSXAppProgrammingGuide/CoreAppDesign/CoreAppDesign.html#//apple_ref/doc/uid/TP40010543-CH3-SW27
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logQueueBeforeExit) name:NSApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logQueueBeforeExit) name:NSApplicationWillTerminateNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logQueueBeforeExit) name:NSApplicationWillHideNotification object:nil];
#endif
    }
    return self;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Main functionality

- (void)addFilter:(SFLogFilter *const)aFilter {
    dispatch_async(self.queue, ^{
       [_filters addObject:aFilter];
    });
}

- (void)removeFilter:(SFLogFilter *const)aFilter {
    dispatch_async(self.queue, ^{
        [_filters removeObject:aFilter];
    });
}

- (BOOL)hasMessagePassedFilters:(SFLogMessage *const)message {
    __block BOOL hasPassedTest = YES;
    dispatch_sync(self.queue, ^{
        for (SFLogFilter * const aFilter in _filters) {
            hasPassedTest = hasPassedTest && [aFilter hasMessagePassedTest:message];
        }
    });
    return hasPassedTest;
}

- (void)logValidMessage:(SFLogMessage * const)aMessage {
    @throw [NSException exceptionWithName:@"AbstractMethodInvocationException"
                                   reason:@"Override method in subclasses, invoke this method on concrete subclasses."
                                 userInfo:nil];
}

- (void)enqueueValidMessage:(SFLogMessage * const)aMessage {
    dispatch_sync(self.queue, ^{
        [self.messageQueue addObject:aMessage];
    });

    if ([self.messageQueue count] >= self.queueSize) {
        [self logQueue];
    }
}

- (void)logQueue {
    @throw [NSException exceptionWithName:@"AbstractMethodInvocationException"
                                   reason:@"Override method in subclasses, invoke this method on concrete subclasses."
                                 userInfo:nil];
}

- (void)logQueueBeforeExit {
#if (TARGET_OS_IPHONE)
    __block UIBackgroundTaskIdentifier tastIdentifier = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        [[UIApplication sharedApplication] endBackgroundTask:tastIdentifier];
        tastIdentifier = UIBackgroundTaskInvalid;
    }];
    [self logQueue];
    [[UIApplication sharedApplication] endBackgroundTask:tastIdentifier];
#elif (TARGET_OS_MAC)
    [self logQueue];
#endif
}

- (NSString *)formattedMessage:(SFLogMessage *const)aMessage {
    return [self.formatter formatMessage:aMessage];
}

- (SFLogFormatter *)formatter {
    if (!_formatter) {
        _formatter = [SFLogFormatter plainFormatter];
    }
    
    return _formatter;
}

+ (SFLogWriter *)fileWriterWithPath:(NSString * const)path {
    return [SFFileLogWriter writerWithPath:path];
}

+ (SFLogWriter *)plainConsoleWriter {
    return [SFConsoleLogWriter plainConsoleWriter];
}

@end
