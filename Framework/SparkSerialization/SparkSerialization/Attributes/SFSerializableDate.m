//
//  SFSerializableDate.m
//  SparkSerialization
//
//  Created by Yuru Taustahuzau on 7/18/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "SFSerializableDate.h"

@implementation SFSerializableDate

- (id)init
{
    self = [super init];
    if (self) {
        _unixTimestamp = NO;
    }
    return self;
}

@end
