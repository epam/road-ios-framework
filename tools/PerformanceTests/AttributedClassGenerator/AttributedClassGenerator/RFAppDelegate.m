//
//  RFAppDelegate.m
//  AttributedClassGenerator
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


#import "RFAppDelegate.h"

#import "RFClassGenerator.h"


@interface RFAppDelegate ()

@property (weak) IBOutlet NSTextField *numberOfClasses;
@property (weak) IBOutlet NSTextField *numberOfIvars;
@property (weak) IBOutlet NSTextField *numberOfMethods;
@property (weak) IBOutlet NSTextField *numberOfProperties;

@property (weak) IBOutlet NSTextField *numberOfClassAttributes;
@property (weak) IBOutlet NSTextField *numberOfIvarAttributes;
@property (weak) IBOutlet NSTextField *numberOfMethodAttributes;
@property (weak) IBOutlet NSTextField *numberOfPropertyAttributes;

@property (weak) IBOutlet NSTextField *outputFolder;

@end


@implementation RFAppDelegate

static NSString * kAttributeClassNameTemplate = @"AttributeClass%i";
static NSString * kClassNameTemplate = @"Class%i";

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self.outputFolder setStringValue:[[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent]];
}

- (IBAction)generateClasses:(id)sender {
    RFClassGenerator *classGenerator = [[RFClassGenerator alloc] init];
    classGenerator.outputPath = [self.outputFolder stringValue];
    classGenerator.numberOfIvars = [self.numberOfIvars intValue];
    classGenerator.numberOfProperties = [self.numberOfProperties intValue];
    classGenerator.numberOfMethods = [self.numberOfMethods intValue];

    int maxNumberOfAttributes = [self.numberOfClassAttributes intValue];
    if (maxNumberOfAttributes < [self.numberOfIvarAttributes intValue]) {
        maxNumberOfAttributes = [self.numberOfIvarAttributes intValue];
    }
    if (maxNumberOfAttributes < [self.numberOfPropertyAttributes intValue]) {
        maxNumberOfAttributes = [self.numberOfPropertyAttributes intValue];
    }
    if (maxNumberOfAttributes < [self.numberOfMethodAttributes intValue]) {
        maxNumberOfAttributes = [self.numberOfMethodAttributes intValue];
    }

    NSMutableSet *imports = [[NSMutableSet alloc] init];
    for (int classIndex = 0; classIndex < [self.numberOfClasses intValue]; classIndex++) {
        classGenerator.className = [NSString stringWithFormat:kAttributeClassNameTemplate, classIndex];
        if (classIndex < maxNumberOfAttributes) {
            [imports addObject:[NSString stringWithFormat:@"%@.h", classGenerator.className]];
        }
        [classGenerator generateAndSaveClass];
    }

    classGenerator.imports = imports;
    classGenerator.numberOfClassAttributes = [self.numberOfClassAttributes intValue];
    classGenerator.numberOfIvarsAttributes = [self.numberOfIvarAttributes intValue];
    classGenerator.numberOfPropertieAttributes = [self.numberOfPropertyAttributes intValue];
    classGenerator.numberOfMethodsAttributes = [self.numberOfMethodAttributes intValue];

    for (int classIndex = 0; classIndex < [self.numberOfClasses intValue]; classIndex++) {
        classGenerator.className = [NSString stringWithFormat:kClassNameTemplate, classIndex];
        [classGenerator generateAndSaveClass];
    }
}

@end
