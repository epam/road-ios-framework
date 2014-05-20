//
//  AttributeViewController.m
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/2/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

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
