//
//  ReflectionTest.m
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import <ROAD/ROADReflection.h>
#import "Functions.h"
#import "ReflectionTest.h"
#import "ReflectionTestingParameters.h"


@implementation ReflectionTest

- (ReflectionTestResult *)runTest {
    ReflectionTestResult *result = [[ReflectionTestResult alloc] init];

    for (Class class in self.classes) {
        // Properties
        const uint64_t propertyStartTime = mach_absolute_time();
        NSArray *properties = [class RF_properties];
        const uint64_t propertyEndTime = mach_absolute_time();
        result.propertiesGenerationTime = ElapsedNanoseconds(propertyStartTime, propertyEndTime);

        result.accessPropertiesTime = [self accessToProperties:properties];

        // Methods
        const uint64_t methodStartTime = mach_absolute_time();
        NSArray *methods = [class RF_methods];
        const uint64_t methodEndTime = mach_absolute_time();
        result.methodsGenerationTime = ElapsedNanoseconds(methodStartTime, methodEndTime);

        result.accessMethodsTime = [self accessToMethods:methods];

        // Ivars
        const uint64_t ivarStartTime = mach_absolute_time();
        NSArray *ivars = [class RF_ivars];
        const uint64_t ivarEndTime = mach_absolute_time();
        result.ivarsGenerationTime = ElapsedNanoseconds(ivarStartTime, ivarEndTime);

        result.accessIvarsTime = [self accessToIvars:ivars];
    }


    return result;
}

- (const double)accessToProperties:(NSArray *)properties {
    id result;
    BOOL isResult;
    const uint64_t startTime = mach_absolute_time();
    for (RFPropertyInfo *properyInfo in properties) {
        if (self.params.accessToPropertyName) {
            result = properyInfo.propertyName;
        }
        if (self.params.accessToPropertySpecifiers) {
            isResult = properyInfo.isDynamic;
            isResult = properyInfo.isWeak;
            isResult = properyInfo.isNonatomic;
            isResult = properyInfo.isReadonly;
            isResult = properyInfo.isStrong;
            isResult = properyInfo.isCopied;
        }
        if (self.params.accessToPropertyAttributes) {
            isResult = properyInfo.isPrimitive;
            result = properyInfo.typeName;
        }
        if (self.params.accessToPropertyTypeClass) {
            result = properyInfo.typeClass;
        }
    }
    const uint64_t endTime = mach_absolute_time();
    return ElapsedNanoseconds(startTime, endTime);
}

- (const double)accessToMethods:(NSArray *)methods {
    id result;
    NSUInteger uintResult;
    const uint64_t startTime = mach_absolute_time();
    for (RFMethodInfo *method in methods) {
        if (self.params.accessToMethodArguments) {
            uintResult = method.numberOfArguments;
        }
        if (self.params.accessToMethodReturnType) {
            result = method.returnType;
        }
    }
    const uint64_t endTime = mach_absolute_time();
    return ElapsedNanoseconds(startTime, endTime);
}

- (const double)accessToIvars:(NSArray *)ivars {
    id result;
    BOOL isResult;
    const uint64_t startTime = mach_absolute_time();
    for (RFIvarInfo *ivar in ivars) {
        if (self.params.accessToIvarPrimitiveCheck) {
            isResult = ivar.isPrimitive;
        }
        if (self.params.accessToIvarTypeName) {
            result = ivar.typeName;
        }
    }
    const uint64_t endTime = mach_absolute_time();
    return ElapsedNanoseconds(startTime, endTime);
}

@end
