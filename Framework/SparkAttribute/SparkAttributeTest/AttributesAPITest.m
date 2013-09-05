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

- (void)test_SF_attributesForInstanceMethod {
    NSArray *attributesList = [AnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomSFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property1, @"Text1", @"testAttribute doesn't contains appropriate value");
}

- (void)test_SF_attributesForInstanceMethodCaching {
    NSArray *attributesList1 = [AnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");

    NSArray *attributesList2 = [AnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");    
}

- (void)test_SF_attributesForInstanceMethodCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
        
    NSArray *attributesList2 = [AnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_InstanceMethodCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass SF_attributesForMethod:@"viewDidLoad" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark - 

#pragma mark - Test Attributes generated code (Properties section)

- (void)test_SF_attributesForProperty {
    NSArray *attributesList = [AnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    CustomSFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property2, @"Text2", @"testAttribute doesn't contains appropriate value");
}

- (void)test_SF_attributesForPropertyCaching {
    NSArray *attributesList1 = [AnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [AnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_SF_attributesForPropertyCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
    
    NSArray *attributesList2 = [AnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_PropertyCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass SF_attributesForProperty:@"window" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark -

#pragma mark - Test Attributes generated code (Fields section)

- (void)test_SF_attributesForField {
    NSArray *attributesList = [AnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 1, @"attributesList must contain 2 items");
    
    CustomSFTestAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
}

- (void)test_SF_attributesForFieldCaching {
    NSArray *attributesList1 = [AnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [AnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_SF_attributesForFieldCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [AnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    }
    
    NSArray *attributesList2 = [AnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_FieldCachingInterference {    
    NSArray *attributesList1 = [AnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must contain values");
    
    NSArray *attributesList2 = [SecondAnnotatedClass SF_attributesForIvar:@"_someField" withAttributeType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

- (void)test_SF_attributesForClass {
    NSArray *attributesList = [AnnotatedClass SF_attributesForClassWithAttributeType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must contain 2 items");
    
    attributesList = [AnnotatedClass SF_attributesForClassWithAttributeType:[CustomSFTestAttribute class]];
    
    STAssertTrue(attributesList != nil, @"attributesList must contain values");
    STAssertTrue([attributesList count] == 1, @"attributesList must contain 2 items");
}

- (void)test_SF_hasAttributesForMethod {
    STAssertTrue([AnnotatedClass SF_hasAttributesForMethod:@"viewDidLoad" withAttributeType:nil], @"please check function");
    STAssertTrue([AnnotatedClass SF_hasAttributesForMethod:@"viewDidLoad" withAttributeType:[CustomSFTestAttribute class]], @"please check function");
    STAssertTrue(![AnnotatedClass SF_hasAttributesForMethod:@"viewDidLoad" withAttributeType:[AnnotatedClass class]], @"please check function");
}

- (void)test_SF_hasAttributesForProperty {
    STAssertTrue([AnnotatedClass SF_hasAttributesForProperty:@"window" withAttributeType:nil], @"please check function");
    STAssertTrue([AnnotatedClass SF_hasAttributesForProperty:@"window" withAttributeType:[CustomSFTestAttribute class]], @"please check function");
    STAssertTrue(![AnnotatedClass SF_hasAttributesForProperty:@"window" withAttributeType:[AnnotatedClass class]], @"please check function");
}

- (void)test_SF_hasAttributesForIvar {
    STAssertTrue([AnnotatedClass SF_hasAttributesForIvar:@"_someField" withAttributeType:nil], @"please check function");
}

- (void)test_SF_hasAttributesForClassWithAttributeType {
    STAssertTrue([AnnotatedClass SF_hasAttributesForClassWithAttributeType:nil], @"please check function");
    STAssertTrue([AnnotatedClass SF_hasAttributesForClassWithAttributeType:[CustomSFTestAttribute class]], @"please check function");
    STAssertTrue(![AnnotatedClass SF_hasAttributesForClassWithAttributeType:[AnnotatedClass class]], @"please check function");
}

- (void)test_SF_propertiesWithAttributeType {
    NSArray *properties = [AnnotatedClass SF_propertiesWithAttributeType:nil];
    STAssertTrue([properties count] == 1, @"properties must contain values");
}

- (void)test_SF_propertiesWithAttributeType_withFiltering {
    NSArray *properties = [AnnotatedClass SF_propertiesWithAttributeType:[CustomSFTestAttribute class]];
    STAssertTrue([properties count] == 1, @"properties must contain values");

    SFPropertyInfo *property = [properties lastObject];
    STAssertTrue([property.propertyName isEqualToString:@"window"], @"please check function");
}

- (void)test_SF_propertiesWithAttributeType_withWrongFiltering {
    NSArray *properties = [AnnotatedClass SF_propertiesWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([properties count] == 0, @"properties must not contain values");
}

- (void)test_SF_ivarsWithAttributeType {
    NSArray *ivars = [AnnotatedClass SF_ivarsWithAttributeType:nil];
    STAssertTrue([ivars count] == 1, @"ivars must contain values");
}

- (void)test_SF_ivarsWithAttributeType_withFiltering {
    NSArray *ivars = [AnnotatedClass SF_ivarsWithAttributeType:[SFTestAttribute class]];
    STAssertTrue([ivars count] == 1, @"ivars must contain values");
    
    SFIvarInfo *ivar = [ivars lastObject];
    STAssertTrue([ivar.name isEqualToString:@"_someField"], @"please check function");
}

- (void)test_SF_ivarsWithAttributeType_withWrongFiltering {
    NSArray *ivars = [AnnotatedClass SF_ivarsWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([ivars count] == 0, @"ivars must not contain values");
}

- (void)test_SF_methodsWithAttributeType {
    NSArray *methods = [AnnotatedClass SF_methodsWithAttributeType:nil];
    STAssertTrue([methods count] == 2, @"methods must contain values");
}

- (void)test_SF_methodsWithAttributeType_withFiltering {
    NSArray *methods = [AnnotatedClass SF_methodsWithAttributeType:[CustomSFTestAttribute class]];
    STAssertTrue([methods count] == 1, @"methods must contain values");
    
    SFMethodInfo *method = [methods lastObject];
    STAssertTrue([method.name isEqualToString:@"viewDidLoad"], @"please check function");
}

- (void)test_SF_methodsWithAttributeType_withWrongFiltering {
    NSArray *methods = [AnnotatedClass SF_methodsWithAttributeType:[AnnotatedClass class]];
    STAssertTrue([methods count] == 0, @"methods must not contain values");
}

- (void)test_SF_attributeForMethod {
    STAssertTrue([AnnotatedClass SF_attributeForMethod:@"viewDidLoad" withAttributeType:[CustomSFTestAttribute class]] != nil, @"please check function");
}

- (void)test_SF_attributeForProperty {
    STAssertTrue([AnnotatedClass SF_attributeForProperty:@"window" withAttributeType:[CustomSFTestAttribute class]] != nil, @"please check function");
}

- (void)test_SF_attributeForIvar {
    STAssertTrue([AnnotatedClass SF_attributeForIvar:@"_someField" withAttributeType:[SFTestAttribute class]] != nil, @"please check function");
}

- (void)test_SF_attributeForClassWithAttributeType {
    STAssertTrue([AnnotatedClass SF_attributeForClassWithAttributeType:[CustomSFTestAttribute class]] != nil, @"please check function");
}

#pragma mark -

@end
