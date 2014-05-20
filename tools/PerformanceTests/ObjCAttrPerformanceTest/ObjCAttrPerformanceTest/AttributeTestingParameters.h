//
//  AttributeTestingParameters.h
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import "ReflectionTestingParameters.h"


@interface AttributeTestingParameters : ReflectionTestingParameters

@property (nonatomic) NSUInteger numberOfClassAttributes;
@property (nonatomic) NSUInteger numberOfPropertyAttributes;
@property (nonatomic) NSUInteger numberOfMethodAttributes;
@property (nonatomic) NSUInteger numberOfIvarAttributes;


@end
