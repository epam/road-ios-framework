//
//  ReflectionConstants.h
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

#ifndef ObjCAttrPerformanceTest_ReflectionConstants_h
#define ObjCAttrPerformanceTest_ReflectionConstants_h

static NSString const * kTestClassNamePrefix = @"TestClass";
static NSString const * kTestIvarNamePrefix = @"testIvar";
static NSString const * kTestPropertyNamePrefix = @"testProperty";
static NSString const * kTestMethodNamePrefix = @"testMethod";

static NSString * kTestMethodAttributeFormatString = @"RF_attributes_%@_method_%@_p1";
static NSString * kTestIvarAttributeMethodFormatString = @"RF_attributes_%@_ivar_%@";
static NSString * kTestPropertyAttributeMethodFormatString = @"RF_attributes_%@_property_%@";
static NSString const * kTestClassAttributeMethodFormatString = @"RF_attributesForClass";

#endif
