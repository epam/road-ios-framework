//
//  RFClassGenerator.h
//  AttributedClassGenerator
//
//  Created by Ossir on 5/15/14.
//  Copyright (c) 2014 Yuru Taustahuzau. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RFClassGenerator : NSObject

@property (nonatomic) NSString *className;

@property (nonatomic) NSMutableSet *imports;

@property (nonatomic) int numberOfProperties;
@property (nonatomic) int numberOfIvars;
@property (nonatomic) int numberOfMethods;

@property (nonatomic) int numberOfClassAttributes;
@property (nonatomic) int numberOfPropertieAttributes;
@property (nonatomic) int numberOfIvarsAttributes;
@property (nonatomic) int numberOfMethodsAttributes;

@property (nonatomic) NSString *outputPath;

- (BOOL)generateAndSaveClass;

@end
