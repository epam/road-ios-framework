//
//  AttributeTestResult.m
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#import "AttributeTestResult.h"

@implementation AttributeTestResult

- (NSString *)description {
    return [NSString stringWithFormat:@"Access to attributes:\nClass attributes : %lf\nMethod attributes : %lf\nIvar attributes : %lf\nProperty attributes : %lf", self.retrievingClassAttributes, self.retrievingMethodAttributes, self.retrievingIvarAttributes, self.retrievingPropertyAttributes];
}

@end
