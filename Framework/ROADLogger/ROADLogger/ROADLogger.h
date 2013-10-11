//
//  ROADLogger.h
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

#ifndef ROADLogger_ROADLogger_h
#define ROADLogger_ROADLogger_h

#import "RFLogging.h"
#import "RFLogger.h"
#import "RFLogMessage.h"
#import "RFLogWriter.h"
#import "RFConsoleLogWriter.h"
#import "RFFileLogWriter.h"
#import "RFNetLogWriter.h"
#import "RFLogFormatter.h"
#import "RFLogBlockFormatter.h"
#import "RFLogPlainFormatter.h"
#import "RFLogFilter.h"
#import "RFLogMessageWrapper.h"
#import "RFServiceProvider+LoggingService.h"

#define RFLogInternalError(...) \
        [[RFServiceProvider logger] logInternalErrorMessage:[[NSString alloc] initWithFormat:__VA_ARGS__]]

#define RFLogInfo(...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelInfo) [[RFServiceProvider logger] logInfoMessage:[[NSString alloc] initWithFormat:__VA_ARGS__]];
#define RFLogDebug(...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelDebug) [[RFServiceProvider logger] logDebugMessage:[[NSString alloc] initWithFormat:__VA_ARGS__]]
#define RFLogWarning(...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelWarning) [[RFServiceProvider logger] logWarningMessage:[[NSString alloc] initWithFormat:__VA_ARGS__]]
#define RFLogError(...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelError) [[RFServiceProvider logger] logErrorMessage:[[NSString alloc] initWithFormat:__VA_ARGS__]]

#define RFLogTypedInfo(__type__, ...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelInfo) [[RFServiceProvider logger] logInfoMessage:[[NSString alloc] initWithFormat:__VA_ARGS__] type:__type__]
#define RFLogTypedDebug(__type__, ...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelDebug) [[RFServiceProvider logger] logDebugMessage:[[NSString alloc] initWithFormat:__VA_ARGS__] type:__type__]
#define RFLogTypedWarning(__type__, ...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelWarning) [[RFServiceProvider logger] logWarningMessage:[[NSString alloc] initWithFormat:__VA_ARGS__] type:__type__]
#define RFLogTypedError(__type__, ...) \
        if ([RFServiceProvider logger].logLevel >= RFLogLevelError) [[RFServiceProvider logger] logErrorMessage:[[NSString alloc] initWithFormat:__VA_ARGS__] type:__type__]

#endif
