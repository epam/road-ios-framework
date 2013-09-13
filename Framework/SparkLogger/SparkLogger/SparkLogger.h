//
//  SparkLogger.h
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

#ifndef SparkLogger_SparkLogger_h
#define SparkLogger_SparkLogger_h

#import "SFLogging.h"
#import "SFLogger.h"
#import "SFLogMessage.h"
#import "SFLogWriter.h"
#import "SFConsoleLogWriter.h"
#import "SFFileLogWriter.h"
#import "SFNetLogWriter.h"
#import "SFLogFormatter.h"
#import "SFLogBlockFormatter.h"
#import "SFLogPlainFormatter.h"
#import "SFLogFilter.h"
#import "SFLoggerWebServicePath.h"
#import "SFLogMessageWrapper.h"
#import "SFServiceProvider+LoggingService.h"

#define SFLogInternalError(frmt, ...) [[[SFServiceProvider sharedProvider] logger] logInternalErrorMessage:frmt, ##__VA_ARGS__]

#define SFLogInfo(frmt, ...) [[[SFServiceProvider sharedProvider] logger] logInfoMessage:frmt, ##__VA_ARGS__]
#define SFLogDebug(frmt, ...) [[[SFServiceProvider sharedProvider] logger] logDebugMessage:frmt, ##__VA_ARGS__]
#define SFLogWarning(frmt, ...) [[[SFServiceProvider sharedProvider] logger] logWarningMessage:frmt, ##__VA_ARGS__]
#define SFLogError(frmt, ...) [[[SFServiceProvider sharedProvider] logger] logErrorMessage:frmt, ##__VA_ARGS__]

#define SFLogTypedInfo(__type__, frmt, ...) [[[SFServiceProvider sharedProvider] logger] logInfoType:__type__ message:frmt, ##__VA_ARGS__]
#define SFLogTypedDebug(__type__, frmt, ...) [[[SFServiceProvider sharedProvider] logger] logDebugType:__type__ message:frmt, ##__VA_ARGS__]
#define SFLogTypedWarning(__type__, frmt, ...) [[[SFServiceProvider sharedProvider] logger] logWarningType:__type__ message:frmt, ##__VA_ARGS__]
#define SFLogTypedError(__type__, frmt, ...) [[[SFServiceProvider sharedProvider] logger] logErrorType:__type__ message:frmt, ##__VA_ARGS__]

#endif
