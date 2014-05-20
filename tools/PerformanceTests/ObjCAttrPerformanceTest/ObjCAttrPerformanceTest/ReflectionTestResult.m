//
//  ReflectionTestResult.m
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#import "ReflectionTestResult.h"

@implementation ReflectionTestResult

- (NSString *)description {
    return [NSString stringWithFormat:@"Generation time:\nProperties : %lf\nMethods : %lf\nIvars : %lf\n\nAccess Time:\nProperties : %lf\nMethods : %lf\nIvars : %lf\n\nTotalTime : %lf", _propertiesGenerationTime, _methodsGenerationTime, _ivarsGenerationTime, _accessPropertiesTime, _accessMethodsTime, _accessIvarsTime, _propertiesGenerationTime + _methodsGenerationTime + _ivarsGenerationTime + _accessPropertiesTime + _accessMethodsTime + _accessIvarsTime];
}

@end
