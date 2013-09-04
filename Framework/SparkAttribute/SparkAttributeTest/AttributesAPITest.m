//
//  AnnotatedClassTest.m
//  AttributesPrototype
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

#import "AttributesAPITest.h"
#import "AnnotatedClass.h"
#import "SecondAnnotatedClass.h"
#import <Spark/SparkReflection.h>

@implementation AttributesAPITest

#pragma mark - Test Attributes generated code (Methods section)

- (void)test_attributesForInstanceMethod {
    NSArray *attributesList = [AnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomSFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property1, @"Text1", @"testAttribute doesn't contains appropriate value");
}

- (void)test_attributesForInstanceMethodCaching {
    NSArray *attributesList1 = [AnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");

    NSArray *attributesList2 = [AnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");    
}

- (void)test_attributesForInstanceMethodCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
        
    NSArray *attributesList2 = [AnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_InstanceMethodCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark - 

#pragma mark - Test Attributes generated code (Properties section)

- (void)test_attributesForProperty {
    NSArray *attributesList = [AnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomSFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property2, @"Text2", @"testAttribute doesn't contains appropriate value");
}

- (void)test_attributesForPropertyCaching {
    NSArray *attributesList1 = [AnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [AnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_attributesForPropertyCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
    
    NSArray *attributesList2 = [AnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_PropertyCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark -

#pragma mark - Test Attributes generated code (Fields section)

- (void)test_attributesForField {
    NSArray *attributesList = [AnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 1, @"attributesList must contain 2 items");
    
    CustomSFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
}

- (void)test_attributesForFieldCaching {
    NSArray *attributesList1 = [AnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [AnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_attributesForFieldCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
    
    NSArray *attributesList2 = [AnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_FieldCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

- (void)test_attributesForClass {
    NSArray *attributesList = [AnnotatedClass attributesForClassWithAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    attributesList = [AnnotatedClass attributesForClassWithAttributeType:[CustomSFTestAttribute class]];
    
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 1, @"attributesList must contain 2 items");
}

- (void)test_hasAttributesForMethod {
    STAssertTrue([AnnotatedClass hasAttributesForMethod:@"viewDidLoad" withAttributeType:nil], @"please check function");
    STAssertTrue([AnnotatedClass hasAttributesForMethod:@"viewDidLoad" withAttributeType:[CustomSFTestAttribute class]], @"please check function");
    STAssertTrue(![AnnotatedClass hasAttributesForMethod:@"viewDidLoad" withAttributeType:[AnnotatedClass class]], @"please check function");
}

- (void)test_hasAttributesForProperty {
    STAssertTrue([AnnotatedClass hasAttributesForProperty:@"window" withAttributeType:nil], @"please check function");
    STAssertTrue([AnnotatedClass hasAttributesForProperty:@"window" withAttributeType:[CustomSFTestAttribute class]], @"please check function");
    STAssertTrue(![AnnotatedClass hasAttributesForProperty:@"window" withAttributeType:[AnnotatedClass class]], @"please check function");
}

- (void)test_hasAttributesForIvar {
    STAssertTrue([AnnotatedClass hasAttributesForIvar:@"_someField" withAttributeType:nil], @"please check function");
}

- (void)test_hasAttributesForClassWithAttributeType {
    STAssertTrue([AnnotatedClass hasAttributesForClassWithAttributeType:nil], @"please check function");
    STAssertTrue([AnnotatedClass hasAttributesForClassWithAttributeType:[CustomSFTestAttribute class]], @"please check function");
    STAssertTrue(![AnnotatedClass hasAttributesForClassWithAttributeType:[AnnotatedClass class]], @"please check function");
}

- (void)test_propertiesWithAttributeType {
    NSArray *properties = [AnnotatedClass propertiesWithAttributeType:nil];
    STAssertTrue([properties count] == 1, @"properties must contain values");
}

- (void)test_propertiesWithAttributeType_withFiltering {
    NSArray *properties = [AnnotatedClass propertiesWithAttributeType:[CustomSFTestAttribute class]];
    STAssertTrue([properties count] == 1, @"properties must contain values");

    SFPropertyInfo *property = [properties lastObject];
    STAssertTrue([property.propertyName isEqualToString:@"window"], @"please check function");
}

- (void)test_propertiesWithAttributeType_withWrongFiltering {
    NSArray *properties = [AnnotatedClass propertiesWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([properties count] == 0, @"properties must not contain values");
}

- (void)test_ivarsWithAttributeType {
    NSArray *ivars = [AnnotatedClass ivarsWithAttributeType:nil];
    STAssertTrue([ivars count] == 1, @"ivars must contain values");
}

- (void)test_ivarsWithAttributeType_withFiltering {
    NSArray *ivars = [AnnotatedClass ivarsWithAttributeType:[SFTestAttribute class]];
    STAssertTrue([ivars count] == 1, @"ivars must contain values");
    
    SFIvarInfo *ivar = [ivars lastObject];
    STAssertTrue([ivar.name isEqualToString:@"_someField"], @"please check function");
}

- (void)test_ivarsWithAttributeType_withWrongFiltering {
    NSArray *ivars = [AnnotatedClass ivarsWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([ivars count] == 0, @"ivars must not contain values");
}

- (void)test_methodsWithAttributeType {
    NSArray *methods = [AnnotatedClass methodsWithAttributeType:nil];
    STAssertTrue([methods count] == 2, @"methods must contain values");
}

- (void)test_methodsWithAttributeType_withFiltering {
    NSArray *methods = [AnnotatedClass methodsWithAttributeType:[CustomSFTestAttribute class]];
    STAssertTrue([methods count] == 1, @"methods must contain values");
    
    SFMethodInfo *method = [methods lastObject];
    STAssertTrue([method.name isEqualToString:@"viewDidLoad"], @"please check function");
}

- (void)test_methodsWithAttributeType_withWrongFiltering {
    NSArray *methods = [AnnotatedClass methodsWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([methods count] == 0, @"methods must not contain values");
}

- (void)test_attributeForMethod {
    STAssertTrue([AnnotatedClass attributeForMethod:@"viewDidLoad" withAttributeType:[CustomSFTestAttribute class]] != nil, @"please check function");
}

- (void)test_attributeForProperty {
    STAssertTrue([AnnotatedClass attributeForProperty:@"window" withAttributeType:[CustomSFTestAttribute class]] != nil, @"please check function");
}

- (void)test_attributeForIvar {
    STAssertTrue([AnnotatedClass attributeForIvar:@"_someField" withAttributeType:[SFTestAttribute class]] != nil, @"please check function");
}

- (void)test_attributeForClassWithAttributeType {
    STAssertTrue([AnnotatedClass attributeForClassWithAttributeType:[CustomSFTestAttribute class]] != nil, @"please check function");
}

#pragma mark -

@end
