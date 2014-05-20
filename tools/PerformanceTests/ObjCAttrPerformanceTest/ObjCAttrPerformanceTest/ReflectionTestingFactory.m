//
//  ReflectionTestingFactory.m
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


#import <objc/runtime.h>
#import "ReflectionTestingFactory.h"
#import "ReflectionTestingParameters.h"
#import "ReflectionTest.h"


@implementation ReflectionTestingFactory

+ (id)createTestForParameters:(ReflectionTestingParameters *)params {
    NSMutableSet *classes = [[NSMutableSet alloc] initWithCapacity:params.numberOfClasses];
    for (int idx = 0; idx < params.numberOfClasses; idx++) {
        NSString *className = [kTestClassNamePrefix stringByAppendingString:[@(idx) stringValue]];
        Class createdClass = objc_allocateClassPair([NSObject class], [className UTF8String], 0);
        [self configureClass:createdClass withParameters:params];
        [classes addObject:createdClass];

    }

    ReflectionTest *test = [[ReflectionTest alloc] init];
    test.classes = classes;
    test.params = params;

    return test;
}

+ (void)configureClass:(Class)class withParameters:(ReflectionTestingParameters *)params {
    [self addMethodsToClass:class withParameters:params];
    [self addIvarsToClass:class withParameters:params];
    [self addPropertiesToClass:class withParameters:params];
}

+ (void)addMethodsToClass:(Class)class withParameters:(ReflectionTestingParameters *)params {
    Method description = class_getInstanceMethod([self class], @selector(dummyMethod:));
    const char *typeEncoding = method_getTypeEncoding(description);

    for (int idx = 0; idx < params.numberOfMethods; idx++) {
        NSString *methodName = [kTestMethodNamePrefix stringByAppendingString:[@(idx) stringValue]];
        class_addMethod(class, NSSelectorFromString(methodName), (IMP)ReturnFive, typeEncoding);
    }
}

+ (void)addIvarsToClass:(Class)class withParameters:(ReflectionTestingParameters *)params {
    for (int idx = 0; idx < params.numberOfIvars; idx++) {
        NSString *ivarName = [kTestIvarNamePrefix stringByAppendingString:[@(idx) stringValue]];
        if (arc4random() % 2 == 0) {
            class_addIvar(class, [ivarName UTF8String], sizeof(id), rint(log2(sizeof(id))), @encode(id));
        }
        else {
            class_addIvar(class, [ivarName UTF8String], sizeof(int), rint(log2(sizeof(int))), @encode(int));
        }
    }
}

+ (void)addPropertiesToClass:(Class)class withParameters:(ReflectionTestingParameters *)params {
    // http://stackoverflow.com/questions/7819092/how-can-i-add-properties-to-an-object-at-runtime
    for (int idx = 0; idx < params.numberOfProperties; idx++) {
        objc_property_attribute_t type = { "T", "@\"NSString\"" };
        objc_property_attribute_t ownership = { "C", "" };
        NSString *ivarName = [kTestIvarNamePrefix stringByAppendingString:@"0"];
        objc_property_attribute_t backingIvar  = { "V", [ivarName UTF8String]};
        objc_property_attribute_t attrs[] = { type, ownership, backingIvar };
        NSString *propertyName = [kTestPropertyNamePrefix stringByAppendingString:[@(idx) stringValue]];
        class_addProperty(class, [propertyName UTF8String], attrs, 3);
//        class_addMethod(class, @selector(name), (IMP)nameGetter, "@@:");
//        class_addMethod(class, @selector(setName:), (IMP)nameSetter, "v@:@");
    }
}


#pragma mark - Creating method utility

- (NSUInteger)dummyMethod:(NSNumber *)number {
    return 0;
}

static NSUInteger ReturnFive(id self, SEL _cmd) {
    return 5;
}

//NSString *nameGetter(id self, SEL _cmd) {
//    NSString *ivarName = [kTestIvarNamePrefix stringByAppendingString:@"0"];
//    Ivar ivar = class_getInstanceVariable([self class], [ivarName UTF8String]);
//    return object_getIvar(self, ivar);
//}
//
//void nameSetter(id self, SEL _cmd, NSString *newName) {
//    NSString *ivarName = [kTestIvarNamePrefix stringByAppendingString:@"0"];
//    Ivar ivar = class_getInstanceVariable([self class], [ivarName UTF8String]);
//    id oldName = object_getIvar(self, ivar);
//    if (oldName != newName) object_setIvar(self, ivar, [newName copy]);
//}

@end
