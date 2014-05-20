//
//  AttributeTestingFactory.m
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import <objc/runtime.h>
#import "AttributeTestingFactory.h"
#import "ReflectionTestingFactory.h"
#import "AttributeTest.h"
#import "ReflectionTest.h"


@implementation AttributeTestingFactory

+ (id)createTestForParameters:(AttributeTestingParameters *)params {
    NSUInteger numberOfClasses = 0;
    NSString *classTemplate = @"Class";
    Class class;
    NSMutableSet *classes = [[NSMutableSet alloc] init];
    while ((class = NSClassFromString([NSString stringWithFormat:@"%@%lu", classTemplate, (unsigned long)numberOfClasses]))) {
        numberOfClasses++;
        [classes addObject:class];
    }
    
    AttributeTest *test = [[AttributeTest alloc] init];
    test.classes = classes;
    test.params = params;
    
    return test;
}

- (NSUInteger)countNumberOfClassses {

    NSUInteger numberOfClasses = 0;
    NSString *classTemplate = @"Class";
    while (NSClassFromString([NSString stringWithFormat:@"%@%lu", classTemplate, (unsigned long)numberOfClasses])) {
        numberOfClasses++;
    }

    return numberOfClasses;
}

@end
