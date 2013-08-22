//
//  ESDLogMessage.h
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


typedef enum ESDLogLevel : NSInteger {
    
    ESDLogLevelInfo = -1000,
    ESDLogLevelDebug = -1001,
    ESDLogLevelWarning = -1002,
    ESDLogLevelError = -1003
    
} ESDLogLevel;

extern NSString * const kESDLogMessageTypeAllLoggers;
extern NSString * const kESDLogMessageTypeNetworkOnly;
extern NSString * const kESDLogMessageTypeConsoleOnly;
extern NSString * const kESDLogMessageTypeWebServiceOnly;
extern NSString * const kESDLogMessageTypeFileOnly;
extern NSString * const kESDLogMessageTypeNoLogging;

/**
 The log message encapsulation object.
 */
//[ESDSerializable]
@interface ESDLogMessage : NSObject <NSCoding, NSCopying>

/**
 The actual log message string.
 */
//[ESDSerializable]
@property (copy, nonatomic) NSString *message;

/**
 The type of the log message, string.
 */
//[ESDSerializable]
@property (copy, nonatomic) NSString *type;

/**
 The date and time the log message was generated.
 */
//[ESDSerializable]
@property (strong, nonatomic) NSDate *timeStamp;

/**
 The userinfo dictionary of the log message. Can be used to attach extra information into the log message.
 */
//[ESDSerializable]
@property (strong, nonatomic) NSDictionary *userInfo;

/**
 The level of the log - info, debug, warning, or error.
 */
//[ESDSerializable]
@property (assign, nonatomic) ESDLogLevel level;

/**
 Factory method for creating a log message.
 @param messageText The message text.
 @param type The message type.
 @param level The log level of the message.
 @param userInfo The userInfo dictionary for the log message.
 */
+ (ESDLogMessage *)logMessage:(NSString * const)messageText type:(NSString * const)type level:(ESDLogLevel const)level userInfo:(NSDictionary * const)userInfo;

+ (ESDLogMessage *)infoMessage:(NSString * const)messageText;
+ (ESDLogMessage *)warningMessage:(NSString * const)messageText;
+ (ESDLogMessage *)errorMessage:(NSString * const)messageText;
+ (ESDLogMessage *)debugMessage:(NSString * const)messageText;

+ (ESDLogMessage *)infoMessage:(NSString * const)messageText type:(NSString *)type;
+ (ESDLogMessage *)warningMessage:(NSString * const)messageText type:(NSString *)type;
+ (ESDLogMessage *)errorMessage:(NSString * const)messageText type:(NSString *)type;
+ (ESDLogMessage *)debugMessage:(NSString * const)messageText type:(NSString *)type;

@end
