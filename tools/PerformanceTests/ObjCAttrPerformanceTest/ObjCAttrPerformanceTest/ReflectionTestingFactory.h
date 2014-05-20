//
//  ReflectionTestingFactory.h
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import "ReflectionTestingParameters.h"


@interface ReflectionTestingFactory : NSObject

+ (id)createTestForParameters:(ReflectionTestingParameters *)params;

@end
