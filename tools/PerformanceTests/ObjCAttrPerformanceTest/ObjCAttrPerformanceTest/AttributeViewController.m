//
//  AttributeViewController.m
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


#import <ROAD/ROADAttribute.h>
#import <ROAD/ROADReflection.h>
#import "AttributeViewController.h"
#import "AttributeTestingFactory.h"
#import "AttributeTest.h"

@interface AttributeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberOfClasses;
@property (weak, nonatomic) IBOutlet UITextField *numberOfClassAttributes;
@property (weak, nonatomic) IBOutlet UITextField *numberOfProperties;
@property (weak, nonatomic) IBOutlet UITextField *numberOfPropertyAttributes;
@property (weak, nonatomic) IBOutlet UITextField *numberOfMethods;
@property (weak, nonatomic) IBOutlet UITextField *numberOfMethodAttributes;
@property (weak, nonatomic) IBOutlet UITextField *numberOfIvars;
@property (weak, nonatomic) IBOutlet UITextField *numberOfIvarAttributes;

@end

@implementation AttributeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.numberOfClassAttributes.text = [@([self countNumberOfClasssAttributes]) stringValue];
    self.numberOfClasses.text = [@([self countNumberOfClassses]) stringValue];
    self.numberOfMethodAttributes.text = [@([self countNumberOfMethodAttributes]) stringValue];
    self.numberOfMethods.text = [@([self countNumberOfMethods]) stringValue];
    self.numberOfIvarAttributes.text = [@([self countNumberOfIvarAttributes]) stringValue];
    self.numberOfIvars.text = [@([self countNumberOfIvars]) stringValue];
    self.numberOfPropertyAttributes.text = [@([self countNumberOfPropertyAttributes]) stringValue];
    self.numberOfProperties.text = [@([self countNumberOfProperties]) stringValue];
}

- (IBAction)runTest:(id)sender {    
    AttributeTestingParameters *params = [self gatherParameters];
    
    AttributeTest *test = [AttributeTestingFactory createTestForParameters:params];
    AttributeTestResult *result = [test runTest];
    NSLog(@"\n%@\n\n", [result description]);
    
    // Show to user
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Results" message:[result description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (AttributeTestingParameters *)gatherParameters {
    AttributeTestingParameters *params = [[AttributeTestingParameters alloc] init];
    
    params.numberOfClasses = [self.numberOfClasses.text integerValue];
    params.numberOfClassAttributes = [self.numberOfClassAttributes.text integerValue];
    params.numberOfProperties = [self.numberOfProperties.text integerValue];
    params.numberOfPropertyAttributes = [self.numberOfPropertyAttributes.text integerValue];
    params.numberOfMethods = [self.numberOfMethods.text integerValue];
    params.numberOfMethodAttributes = [self.numberOfMethodAttributes.text integerValue];
    params.numberOfIvars = [self.numberOfIvars.text integerValue];
    params.numberOfIvarAttributes = [self.numberOfIvarAttributes.text integerValue];
    
    return params;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


static NSString * const kAttributeClassTemplate = @"AttributeClass";

- (NSUInteger)countNumberOfClassses {

    NSUInteger numberOfClasses = 0;

    NSString *classTemplate = @"Class";

    while (NSClassFromString([NSString stringWithFormat:@"%@%lu", classTemplate, (unsigned long)numberOfClasses])) {
        numberOfClasses++;
    }

    return numberOfClasses;
}

- (NSUInteger)countNumberOfClasssAttributes {

    NSUInteger numberOfClassAttributes = 0;

    Class class = NSClassFromString(@"Class0");

    NSString *attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfClassAttributes];
    Class attributeClass = NSClassFromString(attributeClassString);
    while (attributeClass && [class RF_attributeForClassWithAttributeType:attributeClass]) {
        numberOfClassAttributes++;
        attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfClassAttributes];
        attributeClass = NSClassFromString(attributeClassString);
    }

    return numberOfClassAttributes;
}

- (NSUInteger)countNumberOfProperties {
    Class class = NSClassFromString(@"Class0");
    return [[class RF_properties] count];
}

- (NSUInteger)countNumberOfPropertyAttributes {

    NSUInteger numberOfPropertyAttributes = 0;

    Class class = NSClassFromString(@"Class0");

    NSString *attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfPropertyAttributes];
    Class attributeClass = NSClassFromString(attributeClassString);
    while (attributeClass && [class RF_attributeForProperty:@"property0" withAttributeType:attributeClass]) {
        numberOfPropertyAttributes++;
        attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfPropertyAttributes];
        attributeClass = NSClassFromString(attributeClassString);
    }

    return numberOfPropertyAttributes;
}

- (NSUInteger)countNumberOfMethods {
    Class class = NSClassFromString(@"Class0");
    NSUInteger numberOfMethods = 0;
    for (RFMethodInfo *methodInfo in [class RF_methods]) {
        if ([methodInfo.name hasPrefix:@"method"]) {
            numberOfMethods++;
        }
    }
    return numberOfMethods;
}

- (NSUInteger)countNumberOfMethodAttributes {

    NSUInteger numberOfMethodAttributes = 0;

    Class class = NSClassFromString(@"Class0");

    NSString *attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfMethodAttributes];
    Class attributeClass = NSClassFromString(attributeClassString);
    while (attributeClass && [class RF_attributeForMethod:@"method0" withAttributeType:attributeClass]) {
        numberOfMethodAttributes++;
        attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfMethodAttributes];
        attributeClass = NSClassFromString(attributeClassString);
    }

    return numberOfMethodAttributes;
}

- (NSUInteger)countNumberOfIvars {
    Class class = NSClassFromString(@"Class0");
    NSUInteger numberOfIvars = 0;
    for (RFIvarInfo *ivarInfo in [class RF_ivars]) {
        if ([ivarInfo.name hasPrefix:@"_ivar"]) {
            numberOfIvars++;
        }
    }
    return numberOfIvars;
}

- (NSUInteger)countNumberOfIvarAttributes {

    NSUInteger numberOfIvarAttributes = 0;

    Class class = NSClassFromString(@"Class0");

    NSString *attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfIvarAttributes];
    Class attributeClass = NSClassFromString(attributeClassString);
    while (attributeClass && [class RF_attributeForIvar:@"_ivar0" withAttributeType:attributeClass]) {
        numberOfIvarAttributes++;
        attributeClassString = [NSString stringWithFormat:@"%@%lu", kAttributeClassTemplate, (unsigned long)numberOfIvarAttributes];
        attributeClass = NSClassFromString(attributeClassString);
    }

    return numberOfIvarAttributes;
}


@end
