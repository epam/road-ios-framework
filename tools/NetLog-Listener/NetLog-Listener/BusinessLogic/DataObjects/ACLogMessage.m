//
//  ACLogMessage.m
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


#import "ACLogMessage.h"

NSString *kACLogMessageTypeDebug = @"kACLogMessageDebug";
NSString *kACLogMessageTypeInfo = @"kACLogMessageInfo";
NSString *kACLogMessageTypeWarning = @"kACLogMessageWarning";
NSString *kACLogMessageTypeError = @"kACLogMessageError";

NSString *kMessage = @"kMessage";
NSString *kMessageType = @"kMessageType";
NSString *kUserInfo = @"kUserInfo";
NSString *kLogLevel = @"kLogLevel";
NSString *kTimeStamp = @"kTimeStamp";

@implementation ACLogMessage

@synthesize logLevel;
@synthesize message;
@synthesize messageType;
@synthesize userInfo;
@synthesize selectorName;
@synthesize timeStamp;

+ (ACLogMessage *)message:(NSString *)aMessage type:(NSString *)aType logLevel:(int)level userInfo:(NSDictionary *)info {
    
    ACLogMessage *logMessage = [[ACLogMessage alloc] init];
    logMessage.message = aMessage;
    logMessage.messageType = aType;
    logMessage.logLevel = level;
    logMessage.userInfo = info;
    logMessage.timeStamp = [NSDate date];
    
    return logMessage;
}

+ (ACLogMessage *)infoMessage:(NSString *)aMessage {
    
    ACLogMessage *logMessage = [[ACLogMessage alloc] init];
    logMessage.message = aMessage;
    logMessage.messageType = kACLogMessageTypeInfo;
    logMessage.logLevel = ACLogLevelInfo;
    logMessage.timeStamp = [NSDate date];
    
    return logMessage;
}

+ (ACLogMessage *)warningMessage:(NSString *)aMessage {
    
    ACLogMessage *logMessage = [[ACLogMessage alloc] init];
    logMessage.message = aMessage;
    logMessage.messageType = kACLogMessageTypeWarning;
    logMessage.logLevel = ACLogLevelWarning;
    logMessage.timeStamp = [NSDate date];
    
    return logMessage;
}

+ (ACLogMessage *)errorMessage:(NSString *)aMessage {
    
    ACLogMessage *logMessage = [[ACLogMessage alloc] init];
    logMessage.message = aMessage;
    logMessage.messageType = kACLogMessageTypeError;
    logMessage.logLevel = ACLogLevelError;
    logMessage.timeStamp = [NSDate date];
    
    return logMessage;
}


- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:message forKey:kMessage];
    [aCoder encodeObject:messageType forKey:kMessageType];
    [aCoder encodeObject:userInfo forKey:kUserInfo];
    [aCoder encodeInt:logLevel forKey:kLogLevel];
    [aCoder encodeObject:timeStamp forKey:kTimeStamp];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    
    if (self) {
        message = [aDecoder decodeObjectForKey:kMessage];
        messageType = [aDecoder decodeObjectForKey:kMessageType];
        userInfo = [aDecoder decodeObjectForKey:kUserInfo];
        logLevel = [aDecoder decodeIntForKey:kLogLevel];
        timeStamp = [aDecoder decodeObjectForKey:kTimeStamp];
    }
    
    return self;
}

@end
