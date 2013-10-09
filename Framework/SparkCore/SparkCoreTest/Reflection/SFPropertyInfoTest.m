//
//  SFPropertyInfoTest.m
//  ROADCore
//
//  Created by Eduard Beleninik on 9/30/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import <objc/runtime.h>
#import "SFPropertyInfo.h"

@interface SFPropertyInfoTest : SenTestCase {
    Class _testClass;
}

@end

@implementation SFPropertyInfoTest

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
    STAssertTrue(inc == [[SFPropertyInfo propertiesForClass:_testClass] count], @"It's not equals a sum of properties");
}

- (void)testPropertyByName {

    objc_property_attribute_t type = { "T", [@"NSString" UTF8String] };
    objc_property_attribute_t ownership = { "R", "" }; // R = readonly
    objc_property_attribute_t backingivar  = { "V", "_Property" };
    objc_property_attribute_t attrs[] = { type, ownership, backingivar };
    
    NSString *propertyName = @"name";
    SEL methodSelector = NSSelectorFromString(propertyName);
    
    class_addProperty(_testClass, "name", attrs, 3);
    class_addMethod(_testClass, methodSelector, nil, "@@:");
    
    SFPropertyInfo *propertyInfo = [SFPropertyInfo SF_propertyNamed:propertyName forClass:_testClass];

    STAssertNotNil(propertyInfo, @"Can't find metadata of property by name");
}

- (void)tearDown {
    _testClass = nil;
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

@end