//
//  ReflectionTestingFactory.m
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


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
