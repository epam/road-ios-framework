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

#import "AnnotatedClassTest.h"
#import "AnnotatedClass.h"
#import "SecondAnnotatedClass.h"

@interface AnnotatedClassTest() {
    AnnotatedClass *_testObject;
}

@end

@implementation AnnotatedClassTest

- (void)setUp
{
    [super setUp];
    
    _testObject = [AnnotatedClass new];
}

- (void)tearDown
{
    // Tear-down code here.
    _testObject = nil;
    [super tearDown];
}

#pragma mark - Test Attributes generated code (Methods section)

- (void)test_attributesForInstanceMethod {
    NSArray *attributesList = [[_testObject class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must be contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must be contain 2 items");
    
    CustomESDAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property1, @"Text1", @"testAttribute doesn't contains appropriate value");
}

- (void)test_attributesForInstanceMethodCaching {
    NSArray *attributesList1 = [[_testObject class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");

    NSArray *attributesList2 = [[_testObject class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");    
}

- (void)test_attributesForInstanceMethodCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [[_testObject class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    }
        
    NSArray *attributesList2 = [[_testObject class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_InstanceMethodCachingInterference {
    AnnotatedClass *_testObject1 = [AnnotatedClass new];
    SecondAnnotatedClass *_testObject2 = [SecondAnnotatedClass new];
    
    NSArray *attributesList1 = [[_testObject1 class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    
    NSArray *attributesList2 = [[_testObject2 class] attributesForInstanceMethod:@"viewDidLoad" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark - 

#pragma mark - Test Attributes generated code (Properties section)

- (void)test_attributesForProperty {
    NSArray *attributesList = [[_testObject class] attributesForProperty:@"window" withType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must be contain values");
    STAssertTrue([attributesList count] == 2, @"attributesList must be contain 2 items");
    
    CustomESDAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
    STAssertEquals(testAttribute.property2, @"Text2", @"testAttribute doesn't contains appropriate value");
}

- (void)test_attributesForPropertyCaching {
    NSArray *attributesList1 = [[_testObject class] attributesForProperty:@"window" withType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    
    NSArray *attributesList2 = [[_testObject class] attributesForProperty:@"window" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_attributesForPropertyCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [[_testObject class] attributesForProperty:@"window" withType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    }
    
    NSArray *attributesList2 = [[_testObject class] attributesForProperty:@"window" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_PropertyCachingInterference {
    AnnotatedClass *_testObject1 = [AnnotatedClass new];
    SecondAnnotatedClass *_testObject2 = [SecondAnnotatedClass new];
    
    NSArray *attributesList1 = [[_testObject1 class] attributesForProperty:@"window" withType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    
    NSArray *attributesList2 = [[_testObject2 class] attributesForProperty:@"window" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark -

#pragma mark - Test Attributes generated code (Fields section)

- (void)test_attributesForField {
    NSArray *attributesList = [[_testObject class] attributesForField:@"_someField" withType:nil];
    STAssertTrue(attributesList != nil, @"attributesList must be contain values");
    STAssertTrue([attributesList count] == 1, @"attributesList must be contain 2 items");
    
    CustomESDAttribute *testAttribute = [attributesList lastObject];
    STAssertTrue(testAttribute != nil, @"testAttribute must not be nil");
}

- (void)test_attributesForFieldCaching {
    NSArray *attributesList1 = [[_testObject class] attributesForField:@"_someField" withType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    
    NSArray *attributesList2 = [[_testObject class] attributesForField:@"_someField" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 == attributesList2, @"attributesList1 and attributesList2 must point at the same array");
}

- (void)test_attributesForFieldCachingAfterAutoreleasePool {
    NSArray __weak *attributesList1 = nil;
    
    @autoreleasepool {
        attributesList1 = [[_testObject class] attributesForField:@"_someField" withType:nil];
        STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    }
    
    NSArray *attributesList2 = [[_testObject class] attributesForField:@"_someField" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"it seems here is memory leak");
}

- (void)test_FieldCachingInterference {
    AnnotatedClass *_testObject1 = [AnnotatedClass new];
    SecondAnnotatedClass *_testObject2 = [SecondAnnotatedClass new];
    
    NSArray *attributesList1 = [[_testObject1 class] attributesForField:@"_someField" withType:nil];
    STAssertTrue(attributesList1 != nil, @"attributesList1 must be contain values");
    
    NSArray *attributesList2 = [[_testObject2 class] attributesForField:@"_someField" withType:nil];
    STAssertTrue(attributesList2 != nil, @"attributesList2 must be contain values");
    
    STAssertTrue(attributesList1 != attributesList2, @"attributesList1 and attributesList2 must not point at the same array");
}

#pragma mark -

@end
