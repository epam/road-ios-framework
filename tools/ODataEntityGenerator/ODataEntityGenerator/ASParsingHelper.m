//
// Created by Anton Vaneev on 6/6/13.
// Copyright (c) 2013 EPAM Systems Inc. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ASParsingHelper.h"

static NSDateFormatter *_rfcDateFormatter = nil;

@implementation ASParsingHelper

+ (NSString *)safeJSONString:(id)string
{
    if ([string isKindOfClass:[NSString class]])
    {
        return string;
    }
    if ([string isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = string;
        return [number stringValue];
    }
    return nil;
}

+ (NSDate *)safeJSONDate:(id)date
{
    if ([date isKindOfClass:[NSString class]])
    {
        if (_rfcDateFormatter == nil)
        {
            _rfcDateFormatter = [[NSDateFormatter alloc] init];
            assert(_rfcDateFormatter != nil);

            [_rfcDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"];
            [_rfcDateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        }
        return [_rfcDateFormatter dateFromString:date];
    }
    else if ([date isKindOfClass:[NSNumber class]])
    {
        NSNumber *number = date;
        NSTimeInterval interval =[number doubleValue] / 1000;
        return [NSDate dateWithTimeIntervalSince1970:interval];
    }

    return nil;
}

@end