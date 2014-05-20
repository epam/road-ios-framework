//
//  ReflectionViewController.m
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/2/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//


#import "ReflectionViewController.h"
#import "ReflectionTestingFactory.h"
#import "ReflectionTest.h"


@interface ReflectionViewController ()

@property (weak, nonatomic) IBOutlet UITextField *numberOfClasses;

@property (weak, nonatomic) IBOutlet UITextField *numberOfProperties;
@property (weak, nonatomic) IBOutlet UISwitch *accessToPropertyName;
@property (weak, nonatomic) IBOutlet UISwitch *accessToPropertyAttributes;
@property (weak, nonatomic) IBOutlet UISwitch *accessToPropertySpecifiers;
@property (weak, nonatomic) IBOutlet UISwitch *accessToPropertyTypeClass;

@property (weak, nonatomic) IBOutlet UITextField *numberOfMethods;
@property (weak, nonatomic) IBOutlet UISwitch *accessToMethodArguments;
@property (weak, nonatomic) IBOutlet UISwitch *accessToMethodReturnType;

@property (weak, nonatomic) IBOutlet UITextField *numberOfIvars;
@property (weak, nonatomic) IBOutlet UISwitch *accessToIvarPrimitive;
@property (weak, nonatomic) IBOutlet UISwitch *accessToIvarTypeName;

@end

@implementation ReflectionViewController

- (IBAction)runTest:(id)sender {
    
    ReflectionTestingParameters *params = [self gatherParameters];

    ReflectionTest *test = [ReflectionTestingFactory createTestForParameters:params];
    ReflectionTestResult *result = [test runTest];
    NSLog(@"\n%@\n\n", [result description]);
    
    // Show to user
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Results" message:[result description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
}

- (ReflectionTestingParameters *)gatherParameters {
    ReflectionTestingParameters *params = [[ReflectionTestingParameters alloc] init];
    
    params.numberOfClasses = [self.numberOfClasses.text integerValue];
    
    params.numberOfProperties = [self.numberOfProperties.text integerValue];
    params.accessToPropertyName = [self.accessToPropertyName isOn];
    params.accessToPropertyAttributes = [self.accessToPropertyAttributes isOn];
    params.accessToPropertySpecifiers = [self.accessToPropertySpecifiers isOn];
    params.accessToPropertyTypeClass = [self.accessToPropertyTypeClass isOn];
    
    params.numberOfMethods = [self.numberOfMethods.text integerValue];
    params.accessToMethodArguments = [self.accessToMethodArguments isOn];
    params.accessToMethodReturnType = [self.accessToMethodReturnType isOn];
    
    params.numberOfIvars = [self.numberOfIvars.text integerValue];
    params.accessToIvarTypeName = [self.accessToIvarTypeName isOn];
    params.accessToIvarPrimitiveCheck = [self.accessToIvarPrimitive isOn];
    
    return params;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
