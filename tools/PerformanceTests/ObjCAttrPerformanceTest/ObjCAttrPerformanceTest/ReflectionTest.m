//
//  ReflectionTest.m
//  ObjCAttrPerformanceTest
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


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
