//
//  AttributeTest.h
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import "AttributeTestingParameters.h"
#import "AttributeTestResult.h"


@interface AttributeTest : NSObject

@property (nonatomic) NSSet *classes;
@property (nonatomic) AttributeTestingParameters *params;

- (AttributeTestResult *)runTest;

@end
