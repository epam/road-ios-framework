//
//  ReflectionTest.h
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import "ReflectionTestResult.h"

@class ReflectionTestingParameters;


@interface ReflectionTest : NSObject

@property (nonatomic) NSSet *classes;
@property (nonatomic) ReflectionTestingParameters *params;

- (ReflectionTestResult *)runTest;

@end
