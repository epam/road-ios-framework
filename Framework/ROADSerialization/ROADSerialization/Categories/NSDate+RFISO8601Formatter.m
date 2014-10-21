//
//  NSDate+RFISO8601Formatter.m
//  ROADSerialization
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing
//
//  Using code from here:
//  http://sam.roon.io/how-to-drastically-improve-your-app-with-an-afternoon-and-instruments


#import "NSDate+RFISO8601Formatter.h"
#include <locale.h>

@implementation NSDate (RF_ISO8601Formatter)

+ (NSDate *)RF_dateFromISO8601String:(NSString *)string withDateFormat:(NSString*)dateFormat {
    if (!string) {
        return nil;
    }
    struct tm tm;
    time_t t;
    const char *cdateFormat = [dateFormat UTF8String];
    strptime([string cStringUsingEncoding:NSUTF8StringEncoding], cdateFormat, &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    return [NSDate dateWithTimeIntervalSince1970:t];
}

- (NSString *)RF_ISO8601StringWithDateFormat:(NSString*)dateFormat {
    time_t rawTime = [self rawTime];
    return [self RF_ISO8601StringWithDateFormat:dateFormat withRawTime:rawTime];
}

- (NSString *)RF_ISO8601StringWithDateFormat:(NSString*)dateFormat withRawTime:(time_t)rawtime{
    setlocale(LC_ALL, "");
    struct tm *timeinfo;
    char buffer[80];
    timeinfo = localtime(&rawtime);
    timeinfo->tm_isdst = -1;
    const char *cdateFormat = [dateFormat UTF8String];
    strftime(buffer, sizeof(buffer), cdateFormat, timeinfo);
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (time_t)rawTime {
    return [self rawTimeForTimeZone:[NSTimeZone systemTimeZone]];
}

- (time_t)rawTimeForTimeZone:(NSTimeZone*)timeZone {
    return (time_t)([self timeIntervalSince1970] );
}

@end
