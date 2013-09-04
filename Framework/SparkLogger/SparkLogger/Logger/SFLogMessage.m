//
//  SFLogMessage.m
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

static NSString * const kMessage = @"kMessage";
static NSString * const kMessageType = @"kMessageType";
static NSString * const kUserInfo = @"kUserInfo";
static NSString * const kLogLevel = @"kLogLevel";
static NSString * const kTimeStamp = @"kTimeStamp";

NSString * const kSFLogMessageTypeAllLoggers = @"SFLogMessageTypeAllLoggers";
NSString * const kSFLogMessageTypeNetworkOnly = @"SFLogMessageTypeNetworkOnly";
NSString * const kSFLogMessageTypeWebServiceOnly = @"SFLogMessageTypeWebServiceOnly";
NSString * const kSFLogMessageTypeConsoleOnly = @"SFLogMessageTypeConsoleOnly";
NSString * const kSFLogMessageTypeFileOnly = @"SFLogMessageTypeFileOnly";
NSString * const kSFLogMessageTypeNoLogging = @"SFLogMessageTypeNoLogging";

@implementation SFLogMessage

+ (SFLogMessage *)logMessage:(NSString *)msg {
    
    SFLogMessage * const msgLog = [SFLogMessage new];
    msgLog.message = msg;
    msgLog.type = kSFLogMessageTypeConsoleOnly;
    msgLog.userInfo = nil; // todo
    msgLog.timeStamp = [NSDate date];
    return msgLog;
}

+ (SFLogMessage *)logMessageFormat:(NSString *)format args:(va_list)args {
    
    SFLogMessage * const msgLog = [SFLogMessage new];
    msgLog.type = kSFLogMessageTypeConsoleOnly;
    msgLog.userInfo = nil; // todo
    msgLog.timeStamp = [NSDate date];
    msgLog->_message = [[NSString alloc] initWithFormat:format arguments:args];
    return msgLog;
}

+ (SFLogMessage *)logMessageFormat:(NSString *)format args:(va_list)args level:(SFLogLevel)level {
    SFLogMessage * const msgLog = [SFLogMessage logMessageFormat:format args:args];
    msgLog.level = level;
    return msgLog;
}

+ (SFLogMessage *)logMessageFormat:(NSString *)format args:(va_list)args level:(SFLogLevel)level type:(NSString *)type {
    SFLogMessage * const msgLog = [SFLogMessage logMessageFormat:format args:args level:level];
    msgLog.type = type;
    return msgLog;
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
