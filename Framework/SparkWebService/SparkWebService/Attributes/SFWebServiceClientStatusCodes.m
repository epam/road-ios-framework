//
//  SFWebServiceClientStatusCodes.m
//  SparkWebservice
//
//  Created by Andrei Kuzma on 7/16/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "SFWebServiceClientStatusCodes.h"

@implementation SFWebServiceClientStatusCodes

- (void)setSuccessCodes:(NSArray *)successCodes {
    __block NSMutableArray* ar = nil;
    if (successCodes != nil) {
        ar = [NSMutableArray new];
        [successCodes enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
            NSRange range = NSRangeFromString(obj);
            if (range.length == 0) {
                [ar addObject:[NSNumber numberWithUnsignedInteger:range.location]];
            } else {
                [ar addObject:[NSValue valueWithRange:range]];
            }
        }];
    } else {
        ar = [NSMutableArray arrayWithObjects:[NSValue valueWithRange:NSMakeRange(200, 100)], nil];
    }
    _successCodes = ar;
    
}

@end
