//
//  SFLogging.h
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

#import "SFLogMessage.h"

@class SFLogWriter;

/**
 Describes the logger service's public interface. All methods, except where specified otherwise, are thread-safe and can be safely use in multithread enviorment.
 */
@protocol SFLogging <NSObject>

@property (nonatomic, assign) SFLogLevel logLevel;

/**
 * Logs specified message in current set of log writers.
 * @param message The message that will be logged.
 */
- (void)logMessage:(SFLogMessage * const)message;
/**
 * Adds new writers to current set of log writers at the end of list. Method is not thread-safe.
 * writer The writer that will be added to current set of log writers
 */
- (void)addWriter:(SFLogWriter * const)writer;
/**
 * Removes specified writer from current set of log writers. Method is not thread-safe.
 * writer The writer that will be added to current set of log writers
 */
- (void)removeWriter:(SFLogWriter * const)writer;

/**
 * Logs new message with specified message text using internal console logger.
 * @param messageText The text of message for intialization message object.
 */
- (void)logInternalErrorMessage:(NSString * const)messageText;
/**
 * Logs new message with predefined log type SFLogLevelInfo and specified message text.
 * @param messageText The text of message for intialization message object.
 */
- (void)logInfoMessage:(NSString * const)messageText;
/**
 * Logs new message with predefined log type SFLogLevelDebug and specified message text.
 * @param messageText The text of message for intialization message object.
 */
- (void)logDebugMessage:(NSString * const)messageText;
/**
 * Logs new message with predefined log type SFLogLevelWarning and specified message text.
 * @param messageText The text of message for intialization message object.
 */
- (void)logWarningMessage:(NSString * const)messageText;
/**
 * Logs new message with predefined log type SFLogLevelError and specified message text.
 * @param messageText The text of message for intialization message object.
 */
- (void)logErrorMessage:(NSString * const)messageText;

/**
 * Logs new message with predefined log type SFLogLevelInfo and specified message text and type.
 * @param messageText The text of message for intialization message object.
 * @param type The type of message for initialization message object.
 */
- (void)logInfoMessage:(NSString * const)messageText type:(NSString *)type;
/**
 * Logs new message with predefined log type SFLogLevelDebug and specified message text and type.
 * @param messageText The text of message for intialization message object.
 * @param type The type of message for initialization message object.
 */
- (void)logDebugMessage:(NSString * const)messageText type:(NSString *)type;
/**
 * Logs new message with predefined log type SFLogLevelWarning and specified message text and type.
 * @param messageText The text of message for intialization message object.
 * @param type The type of message for initialization message object.
 */
- (void)logWarningMessage:(NSString * const)messageText type:(NSString *)type;
/**
 * Logs new message with predefined log type SFLogLevelError and specified message text and type.
 * @param messageText The text of message for intialization message object.
 * @param type The type of message for initialization message object.
 */
- (void)logErrorMessage:(NSString * const)messageText type:(NSString *)type;

@optional
/**
 * Returns current log writers.
 * @return The current array of log writers for logging.
 */
- (NSArray *)writers;
/**
 * Sets new array of log writers.
 * @param arrayOfWriters The new array of log writers. Method is not thread-safe.
 */
- (void)setWriters:(NSArray * const)arrayOfWriters;

@end
