//
//  AttributeTest.m
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/8/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import <ROAD/ROADAttribute.h>
#import <ROAD/ROADReflection.h>
#import "AttributeTest.h"
#import "Functions.h"


@implementation AttributeTest

- (AttributeTestResult *)runTest {
    AttributeTestResult *result = [[AttributeTestResult alloc] init];

    const uint64_t classStartTime = mach_absolute_time();
    for (Class class in self.classes) {
        if ([[class RF_attributesForClass] count] != self.params.numberOfClassAttributes) {
            NSLog(@"Error retrieving attributes - %@", [class RF_attributesForClass]);
        }
    }
    const uint64_t classEndTime = mach_absolute_time();
    result.retrievingClassAttributes = ElapsedNanoseconds(classStartTime, classEndTime);
    
    const uint64_t propertyStartTime = mach_absolute_time();
    for (Class class in self.classes) {
        for (RFPropertyInfo *property in [class RF_properties]) {
            if ([[property attributes] count] != self.params.numberOfPropertyAttributes) {
                NSLog(@"Error retrieving attributes");
            }
        }
    }
    const uint64_t propertyEndTime = mach_absolute_time();
    result.retrievingPropertyAttributes = ElapsedNanoseconds(propertyStartTime, propertyEndTime);
    
    const uint64_t methodStartTime = mach_absolute_time();
    for (Class class in self.classes) {
        for (RFMethodInfo *method in [class RF_methods]) {
            if ([[method attributes] count] != self.params.numberOfMethodAttributes) {
                NSLog(@"Error retrieving attributes");
            }
        }
        [class RF_attributesForClass];
    }
    const uint64_t methodEndTime = mach_absolute_time();
    result.retrievingMethodAttributes = ElapsedNanoseconds(methodStartTime, methodEndTime);
    
    const uint64_t ivarStartTime = mach_absolute_time();
    for (Class class in self.classes) {
        for (RFIvarInfo *ivar in [class RF_ivars]) {
            if ([[ivar attributes] count] != self.params.numberOfIvarAttributes) {
                NSLog(@"Error retrieving attributes");
            }
        }
        [class RF_attributesForClass];
    }
    const uint64_t ivarEndTime = mach_absolute_time();
    result.retrievingIvarAttributes = ElapsedNanoseconds(ivarStartTime, ivarEndTime);

    return result;
}

@end
