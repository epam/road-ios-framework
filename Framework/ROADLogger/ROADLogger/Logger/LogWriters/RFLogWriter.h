//
//  RFLogWriter.h
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

#import <Foundation/Foundation.h>

@class RFLogFilter;
@class RFLogMessage;
@class RFLogFormatter;

/**
 * Abstract base class of all log writers, contains all the methods and the necessary implementations to make this class and its subclass function as log writers.
 */
@interface RFLogWriter : NSObject

/**
 * The queue to work on. http://stackoverflow.com/questions/12511976/app-crashes-after-xcode-upgrade-to-4-5-assigning-retained-object-to-unsafe-unre
 */
#if OS_OBJECT_USE_OBJC
@property (nonatomic, strong) dispatch_queue_t queue; // this is for Xcode 4.5 with LLVM 4.1 and iOS 6 SDK
#else
@property (nonatomic, assign) dispatch_queue_t queue; // this is for older Xcodes with older SDKs
#endif


/**
 * Queue size of log messages.
 */
@property (atomic, assign) NSInteger queueSize;

/**
 * Queue of messages that will be logged when size of queue reaches size limit.
 */
@property (nonatomic, strong) NSMutableArray *messageQueue;

/**
 * Adds a filter to the filter list of this writer.
 * @param aFilter The filter to be added.
 */
- (void)addFilter:(RFLogFilter * const)aFilter;

/**
 * Removes a filter from the filter list of this writer.
 * @param aFilter The filter to be removed.
 */
- (void)removeFilter:(RFLogFilter * const)aFilter;

/**
 * Checks a message with list of defined filters.
 * @param aMessage The message to be checked.
 * @result Whether message has passed the filters.
 */
- (BOOL)hasMessagePassedFilters:(RFLogMessage *const)aMessage;

/**
 * Logs a message to this writer. Method has to be implemented in subclasses.
 * @param aMessage The message to be logged.
 */
- (void)logValidMessage:(RFLogMessage * const)aMessage;

/**
 * Enqueues message that passed filters. If queue reaches queueSize limit, it invokes logQueue method.
 * @param aMessage The message to be enqueued
 */
- (void)enqueueValidMessage:(RFLogMessage * const)aMessage;

/**
 * Logs all messages in queue and clear queue
 */
- (void)logQueue;

/**
 * Returns the formatted message from the log message object.
 * @param aMessage The log message to format.
 */
- (NSString *)formattedMessage:(RFLogMessage * const)aMessage;

/**
 * The log formatter property for the specific writer. Optional, in its absence, the bare log message will be logged.
 */
@property (retain, nonatomic) RFLogFormatter *formatter;

/**
 * Returns a file writer for the specified path.
 * @param path The NSString representation of the file path.
 * @result The writer instance.
 */
+ (RFLogWriter *)fileWriterWithPath:(NSString * const)path;

/**
 * Returns a console log writer with plain formatter.
 */
+ (RFLogWriter *)plainConsoleWriter;

@end
