//
//  ReflectionTestResult.h
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


@interface ReflectionTestResult : NSObject

@property (nonatomic) double propertiesGenerationTime;
@property (nonatomic) double accessPropertiesTime;

@property (nonatomic) double methodsGenerationTime;
@property (nonatomic) double accessMethodsTime;

@property (nonatomic) double ivarsGenerationTime;
@property (nonatomic) double accessIvarsTime;

@end
