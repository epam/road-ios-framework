//
//  AttributesAPITest.m
//  ROADCore
//
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without 
// modification, are permitted provided that the following conditions are met:
// 
//  Redistributions of source code must retain the above copyright notice, this 
// list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this 
// list of conditions and the following disclaimer in the documentation and/or 
// other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors 
// may be used to endorse or promote products derived from this software without 
// specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND 
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE 
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE 
// FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL 
// DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR 
// SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
// CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
// OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
// OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "AttributesAPITest.h"
#import "AnnotatedClass.h"
#import "SecondAnnotatedClass.h"
#import <ROAD/ROADReflection.h>

@implementation AttributesAPITest

#pragma mark - Test Attributes generated code (Methods section)

- (void)test_RF_attributesForInstanceMethod {
    NSArray *attributesList = [AnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomRFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property1, @"Text1", @"testAttribute doesn't contains appropriate value");
}

- (void)test_RF_attributesForInstanceMethodCaching {
    NSArray *attributesList1 = [AnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");

    NSArray *attributesList2 = [AnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");    
}

- (void)test_RF_attributesForInstanceMethodCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
        
    NSArray *attributesList2 = [AnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_InstanceMethodCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass RF_attributesForMethod:@"viewDidLoad"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark - 

#pragma mark - Test Attributes generated code (Properties section)

- (void)test_RF_attributesForProperty {
    NSArray *attributesList = [AnnotatedClass RF_attributesForProperty:@"window"];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomRFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property2, @"Text2", @"testAttribute doesn't contains appropriate value");
}

- (void)test_RF_attributesForPropertyCaching {
    NSArray *attributesList1 = [AnnotatedClass RF_attributesForProperty:@"window"];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [AnnotatedClass RF_attributesForProperty:@"window"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_RF_attributesForPropertyCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass RF_attributesForProperty:@"window"];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
    
    NSArray *attributesList2 = [AnnotatedClass RF_attributesForProperty:@"window"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_PropertyCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass RF_attributesForProperty:@"window"];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass RF_attributesForProperty:@"window"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark -

#pragma mark - Test Attributes generated code (Fields section)

- (void)test_RF_attributesForField {
    NSArray *attributesList = [AnnotatedClass RF_attributesForIvar:@"_someField"];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 1, @"attributesList must contain 2 items");
    
    CustomRFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
}

- (void)test_RF_attributesForFieldCaching {
    NSArray *attributesList1 = [AnnotatedClass RF_attributesForIvar:@"_someField"];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [AnnotatedClass RF_attributesForIvar:@"_someField"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_RF_attributesForFieldCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass RF_attributesForIvar:@"_someField"];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
    
    NSArray *attributesList2 = [AnnotatedClass RF_attributesForIvar:@"_someField"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_FieldCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass RF_attributesForIvar:@"_someField"];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass RF_attributesForIvar:@"_someField"];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

- (void)test_RF_attributesForClass {
    NSArray *attributesList = [AnnotatedClass RF_attributesForClass];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomRFTestAttribute *testAttribute = [AnnotatedClass RF_attributeForClassWithAttributeType:[CustomRFTestAttribute class]];
    
    STAssertTrue(testAttribute != nil, @"please check function");
}

- (void)test_RF_propertiesWithAttributeType_withFiltering {
    NSArray *properties = [AnnotatedClass RF_propertiesWithAttributeType:[CustomRFTestAttribute class]];
    STAssertTrue([properties count] == 1, @"properties must contain values");

    RFPropertyInfo *property = [properties lastObject];
    STAssertTrue([property.propertyName isEqualToString:@"window"], @"please check function");
}

- (void)test_RF_propertiesWithAttributeType_withWrongFiltering {
    NSArray *properties = [AnnotatedClass RF_propertiesWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([properties count] == 0, @"properties must not contain values");
}

- (void)test_RF_ivarsWithAttributeType_withFiltering {
    NSArray *ivars = [AnnotatedClass RF_ivarsWithAttributeType:[RFTestAttribute class]];
    STAssertTrue([ivars count] == 1, @"ivars must contain values");
    
    RFIvarInfo *ivar = [ivars lastObject];
    STAssertTrue([ivar.name isEqualToString:@"_someField"], @"please check function");
}

- (void)test_RF_ivarsWithAttributeType_withWrongFiltering {
    NSArray *ivars = [AnnotatedClass RF_ivarsWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([ivars count] == 0, @"ivars must not contain values");
}

- (void)test_RF_methodsWithAttributeType_withFiltering {
    NSArray *methods = [AnnotatedClass RF_methodsWithAttributeType:[CustomRFTestAttribute class]];
    STAssertTrue([methods count] == 1, @"methods must contain values");
    
    RFMethodInfo *method = [methods lastObject];
    STAssertTrue([method.name isEqualToString:@"viewDidLoad"], @"please check function");
}

- (void)test_RF_methodsWithAttributeType_withWrongFiltering {
    NSArray *methods = [AnnotatedClass RF_methodsWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([methods count] == 0, @"methods must not contain values");
}

- (void)test_RF_attributeForMethod {
    STAssertTrue([AnnotatedClass RF_attributeForMethod:@"viewDidLoad" withAttributeType:[CustomRFTestAttribute class]] != nil, @"please check function");
}

- (void)test_RF_attributeForProperty {
    STAssertTrue([AnnotatedClass RF_attributeForProperty:@"window" withAttributeType:[CustomRFTestAttribute class]] != nil, @"please check function");
}

- (void)test_RF_attributeForIvar {
    STAssertTrue([AnnotatedClass RF_attributeForIvar:@"_someField" withAttributeType:[RFTestAttribute class]] != nil, @"please check function");
}

- (void)test_RF_attributeForClassWithAttributeType {
    STAssertTrue([AnnotatedClass RF_attributeForClassWithAttributeType:[CustomRFTestAttribute class]] != nil, @"please check function");
}

#pragma mark -

@end
