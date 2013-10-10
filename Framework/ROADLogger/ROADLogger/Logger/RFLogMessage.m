//
//  RFLogMessage.m
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

#import "RFLogMessage.h"


static NSString * const kMessage = @"kMessage";
static NSString * const kMessageType = @"kMessageType";
static NSString * const kUserInfo = @"kUserInfo";
static NSString * const kLogLevel = @"kLogLevel";
static NSString * const kTimeStamp = @"kTimeStamp";

NSString * const kRFLogMessageTypeAllLoggers = @"RFLogMessageTypeAllLoggers";
NSString * const kRFLogMessageTypeNetworkOnly = @"RFLogMessageTypeNetworkOnly";
NSString * const kRFLogMessageTypeWebServiceOnly = @"RFLogMessageTypeWebServiceOnly";
NSString * const kRFLogMessageTypeConsoleOnly = @"RFLogMessageTypeConsoleOnly";
NSString * const kRFLogMessageTypeFileOnly = @"RFLogMessageTypeFileOnly";
NSString * const kRFLogMessageTypeNoLogging = @"RFLogMessageTypeNoLogging";


@implementation RFLogMessage

+ (RFLogMessage *)logMessage:(NSString * const)messageText type:(NSString * const)type level:(RFLogLevel const)level userInfo:(NSDictionary * const)userInfo {
    RFLogMessage * const message = [[RFLogMessage alloc] init];
    message.message = messageText;
    if (type) {
        message.type = type;
    }
    else {
        message.type = kRFLogMessageTypeConsoleOnly;
    }
    message.level = level;
    message.userInfo = userInfo;
    message.timeStamp = [NSDate date];
    return message;
}

+ (RFLogMessage *)infoMessage:(NSString * const)messageText {
    return [self logMessage:messageText type:kRFLogMessageTypeConsoleOnly level:RFLogLevelInfo userInfo:nil];
}

+ (RFLogMessage *)warningMessage:(NSString * const)messageText {
    return [self logMessage:messageText type:kRFLogMessageTypeConsoleOnly level:RFLogLevelWarning userInfo:nil];
}

+ (RFLogMessage *)errorMessage:(NSString * const)messageText {
    return [self logMessage:messageText type:kRFLogMessageTypeConsoleOnly level:RFLogLevelError userInfo:nil];
}

+ (RFLogMessage *)debugMessage:(NSString * const)messageText {
    return [self logMessage:messageText type:kRFLogMessageTypeConsoleOnly level:RFLogLevelDebug userInfo:nil];
}

+ (RFLogMessage *)infoMessage:(NSString * const)messageText type:(NSString *)type {
    return [self logMessage:messageText type:type level:RFLogLevelInfo userInfo:nil];
}

+ (RFLogMessage *)warningMessage:(NSString * const)messageText type:(NSString *)type {
    return [self logMessage:messageText type:type level:RFLogLevelWarning userInfo:nil];
}

+ (RFLogMessage *)errorMessage:(NSString * const)messageText type:(NSString *)type {
    return [self logMessage:messageText type:type level:RFLogLevelError userInfo:nil];
}

+ (RFLogMessage *)debugMessage:(NSString * const)messageText type:(NSString *)type {
    return [self logMessage:messageText type:type level:RFLogLevelDebug userInfo:nil];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder * const)aCoder {
    [aCoder encodeObject:_message forKey:kMessage];
    [aCoder encodeObject:_type forKey:kMessageType];
    [aCoder encodeObject:_timeStamp forKey:kTimeStamp];
    [aCoder encodeInteger:_level forKey:kLogLevel];
    [aCoder encodeObject:_userInfo forKey:kUserInfo];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        _message = [[aDecoder decodeObjectForKey:kMessage] copy];
        _type = [[aDecoder decodeObjectForKey:kMessageType] copy];
        _timeStamp = [aDecoder decodeObjectForKey:kTimeStamp];
        _level = [aDecoder decodeIntegerForKey:kLogLevel];
        _userInfo = [aDecoder decodeObjectForKey:kUserInfo];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    id copy = [[[self class] allocWithZone:zone] init];
    [copy setMessage:_message];
    [copy setType:_type];
    [copy setLevel:_level];
    [copy setUserInfo:_userInfo];
    [copy setTimeStamp:_timeStamp];
    return copy;
}

@end
