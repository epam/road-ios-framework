//
//  ReflectionTestingParameters.h
//  ObjCAttrPerformanceTest
//
//  Created by Ossir on 4/7/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


@interface ReflectionTestingParameters : NSObject

@property (nonatomic) NSInteger numberOfClasses;

@property (nonatomic) NSInteger numberOfProperties;
@property (nonatomic) BOOL accessToPropertyName;
@property (nonatomic) BOOL accessToPropertyAttributes;
@property (nonatomic) BOOL accessToPropertySpecifiers;
@property (nonatomic) BOOL accessToPropertyTypeClass;

@property (nonatomic) NSInteger numberOfMethods;
@property (nonatomic) BOOL accessToMethodArguments;
@property (nonatomic) BOOL accessToMethodReturnType;

@property (nonatomic) NSInteger numberOfIvars;
@property (nonatomic) BOOL accessToIvarPrimitiveCheck;
@property (nonatomic) BOOL accessToIvarTypeName;


@end
