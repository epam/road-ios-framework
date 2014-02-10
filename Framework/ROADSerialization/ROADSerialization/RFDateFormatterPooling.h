//
//  RFDateFormatterPooling.h
//  ROADSerialization
//
//  Created by Yuru Taustahuzau on 2/6/14.
//  Copyright (c) 2014 Epam Systems. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RFDateFormatterPooling <NSObject>

- (NSDateFormatter *)dataFormatterWithFormatString:(NSString *)formatString;

@end
