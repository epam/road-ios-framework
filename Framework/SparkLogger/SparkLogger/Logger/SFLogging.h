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

#import <Foundation/Foundation.h>
#import "SFLogMessage.h"
#import "SFLogWriter.h"

/**
 Describes the logger service's public interface.
 */
@protocol SFLogging <NSObject>

@property (nonatomic, assign) SFLogLevel logLevel;

- (void)logMessage:(SFLogMessage * const)message;
- (void)addWriter:(SFLogWriter * const)aWriter;
- (void)removeWriter:(SFLogWriter * const)aWriter;

- (void)logInternalErrorMessage:(NSString * const)messageText;
- (void)logInfoMessage:(NSString * const)messageText;
- (void)logWarningMessage:(NSString * const)messageText;
- (void)logErrorMessage:(NSString * const)messageText;
- (void)logDebugMessage:(NSString * const)messageText;

- (void)logInfoMessage:(NSString * const)messageText type:(NSString *)type;
- (void)logWarningMessage:(NSString * const)messageText type:(NSString *)type;
- (void)logErrorMessage:(NSString * const)messageText type:(NSString *)type;
- (void)logDebugMessage:(NSString * const)messageText type:(NSString *)type;

@optional
- (NSArray *)writers;
- (void)setWriters:(NSArray * const)arrayOfWriters;

@end
