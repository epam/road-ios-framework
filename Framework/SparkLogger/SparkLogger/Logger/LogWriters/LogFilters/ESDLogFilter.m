//
//  ESDLogFilter.m
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


#import "ESDLogFilter.h"

#import "ESDLogMessage.h"

@implementation ESDLogFilter {
    NSPredicate *predicate;
}

- (BOOL)hasMessagePassedTest:(ESDLogMessage *const)message {
    return [predicate evaluateWithObject:message];
}

+ (ESDLogFilter *)filterForLevel:(const ESDLogLevel)level {
    ESDLogFilter *filter = [[ESDLogFilter alloc] init];
    filter->predicate = [NSPredicate predicateWithBlock:^BOOL(ESDLogMessage * const evaluatedObject, NSDictionary *bindings) {
        return evaluatedObject.level == level;
    }];
    return filter;
}

+ (ESDLogFilter *)filterWithPrediate:(NSPredicate * const)predicate {
    ESDLogFilter *filter = [[ESDLogFilter alloc] init];
    filter->predicate = predicate;
    return filter;
}

+ (ESDLogFilter *)consoleFilter {
    NSPredicate * const predicate = [NSPredicate predicateWithBlock:^BOOL(ESDLogMessage * const evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject.type isEqualToString:kESDLogMessageTypeAllLoggers]
            || [evaluatedObject.type isEqualToString:kESDLogMessageTypeConsoleOnly];
    }];
    return [self filterWithPrediate:predicate];
}

+ (ESDLogFilter *)networkFilter {
    NSPredicate * const predicate = [NSPredicate predicateWithBlock:^BOOL(ESDLogMessage * const evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject.type isEqualToString:kESDLogMessageTypeAllLoggers]
        || [evaluatedObject.type isEqualToString:kESDLogMessageTypeNetworkOnly];
    }];
    return [self filterWithPrediate:predicate];
}

+ (ESDLogFilter *)fileFilter {
    NSPredicate * const predicate = [NSPredicate predicateWithBlock:^BOOL(ESDLogMessage * const evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject.type isEqualToString:kESDLogMessageTypeAllLoggers]
        || [evaluatedObject.type isEqualToString:kESDLogMessageTypeFileOnly];
    }];
    return [self filterWithPrediate:predicate];
}

@end
