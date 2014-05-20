//
//  ReflectionViewController.m
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
