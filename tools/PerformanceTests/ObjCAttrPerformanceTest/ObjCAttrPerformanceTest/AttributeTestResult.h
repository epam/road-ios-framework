//
//  AttributeTestResult.h
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


@interface AttributeTestResult : NSObject

@property (nonatomic) double retrievingClassAttributes;
@property (nonatomic) double retrievingMethodAttributes;
@property (nonatomic) double retrievingPropertyAttributes;
@property (nonatomic) double retrievingIvarAttributes;

@end
