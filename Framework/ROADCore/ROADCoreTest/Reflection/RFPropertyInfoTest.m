//
//  RFPropertyInfoTest.m
//  ROADCore
//
//  Created by Eduard Beleninik on 9/30/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>
#import "RFPropertyInfo.h"

@interface RFPropertyInfoTest : SenTestCase {
    Class _testClass;
}

@end

@implementation RFPropertyInfoTest

const static NSUInteger numberOfProperties = 76;
const static char *testClassName = "testClassName";

- (void)setUp {
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
    _testClass = objc_allocateClassPair([NSObject class], testClassName, 0);
}

- (void)testPropertyCount {
    
    NSUInteger inc = 0;
    
    objc_property_attribute_t type = { "T", [@"NSString" UTF8String] };
    objc_property_attribute_t ownership = { "R", "" }; // R = readonly
    
    for (int i = inc; i <= numberOfProperties; i++) {
        
        objc_property_attribute_t backingivar  = { "V", [[NSString stringWithFormat:@"_Property%d", i] UTF8String] };
        objc_property_attribute_t attrs[] = { type, ownership, backingivar };
        
        SEL methodSelector = NSSelectorFromString([NSString stringWithFormat:@"Property%d", i]);
        
        class_addProperty(_testClass, [[NSString stringWithFormat:@"Property%d", i] UTF8String], attrs, 3);
        class_addMethod(_testClass, methodSelector, nil, "@@:");

        inc++;
    }
    STAssertTrue(inc == [[RFPropertyInfo propertiesForClass:_testClass] count], @"It's not equal a sum of properties");
}

- (void)testPropertyByPredicated {
    objc_property_attribute_t attrs[] = {
        { "T", [@"NSString" UTF8String] },
        { "V", "_Property" },
        { "R", "" },
    };
    
    NSString *propertyName = @"nameForTestPredicate";
    SEL methodSelector = NSSelectorFromString(propertyName);
    
    class_addProperty(_testClass, "nameForTestPredicate", attrs, 3);
    class_addMethod(_testClass, methodSelector, nil, "@@:");
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"propertyName == %@", propertyName];
    
    RFPropertyInfo *propertyInfo = [[RFPropertyInfo propertiesForClass:_testClass withPredicate:predicate] lastObject];
    STAssertNotNil(propertyInfo, @"Can't find metadata of property by name");
}

- (void)testPropertyFunctionality {
    objc_property_attribute_t attrs[] = {
        { "T", [@"NSString" UTF8String] },
        { "G", "getter" },
        { "S", "setter" },
        { "V", "_Property" },
        { "D", "" },
        { "C", "" },
        { "R", "" },
        { "&", "" },
        { "N", "" },
        { "W", "" },
    };
    
    NSString *propertyName = @"name";
    SEL methodSelector = NSSelectorFromString(propertyName);
    
    class_addProperty(_testClass, "name", attrs, 10);
    class_addMethod(_testClass, methodSelector, nil, "@@:");
    
    RFPropertyInfo *propertyInfo = [RFPropertyInfo RF_propertyNamed:propertyName forClass:_testClass];
    STAssertNotNil(propertyInfo, @"Can't find metadata of property by name");

    STAssertTrue([propertyInfo.typeName isEqualToString:@"NSString"], @"It's not equals a type name of property");
    STAssertTrue([NSStringFromClass(propertyInfo.typeClass) isEqualToString:@"NSString"], @"It's not equals a type name of property");
    STAssertTrue([propertyInfo.className isEqualToString:@"testClassName"], @"It's not equals a name of class of property");
    STAssertTrue([propertyInfo.setterName isEqualToString:@"setter"], @"It's not equals a setter name of property");
    STAssertTrue([propertyInfo.getterName isEqualToString:@"getter"], @"It's not equals a getter name of property");
    
    STAssertTrue(propertyInfo.isReadonly, @"It's not equal attribute 'readonly' of property");
    STAssertTrue(propertyInfo.isCopied, @"It's not equal attribute 'copy' of property");
    STAssertTrue(propertyInfo.isDynamic, @"It's not equal attribute 'dynamic' of property");
    STAssertTrue(propertyInfo.isWeak, @"It's not equal attribute 'weak' of property");
    STAssertTrue(propertyInfo.isNonatomic, @"It's not equal attribute 'nonatomic' of property");
    STAssertTrue(propertyInfo.isStrong, @"It's not equal attribute 'strong' of property");
}

- (void)tearDown {
    _testClass = nil;
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

@end