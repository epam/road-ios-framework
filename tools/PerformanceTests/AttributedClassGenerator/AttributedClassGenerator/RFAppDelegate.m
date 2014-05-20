//
//  RFAppDelegate.m
//  AttributedClassGenerator
//
//  Created by Ossir on 5/12/14.
//  Copyright (c) 2014 Yuru Taustahuzau. All rights reserved.
//


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
