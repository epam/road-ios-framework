//
// Created by Anton Vaneev on 6/6/13.
// Copyright (c) 2013 EPAM Systems Inc. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface ASParsingHelper : NSObject

+ (NSString *) safeJSONString: (id) string;
+ (NSDate *) safeJSONDate: (id) date;
@end