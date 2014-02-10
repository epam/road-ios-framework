//
//  RFBasicAttributedCoder.m
//  ROADSerialization
//
//  Created by Yuru Taustahuzau on 2/6/14.
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import "RFBasicAttributedCoder.h"

@implementation RFBasicAttributedCoder {
    NSMutableDictionary * _dateFormatters;
}

#pragma mark - Initialization

- (id)init {
    self = [super init];
    
    if (self) {
        _dateFormatters = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}


#pragma mark - RFDateFormatterPooling

- (NSDateFormatter *)dataFormatterWithFormatString:(NSString *)formatString {
    if ([formatString length] == 0) {
        return nil;
    }
    
    NSDateFormatter *dateFormatter = _dateFormatters[formatString];
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = formatString;
        _dateFormatters[formatString]  = dateFormatter;
    }
    
    return dateFormatter;
}

@end
