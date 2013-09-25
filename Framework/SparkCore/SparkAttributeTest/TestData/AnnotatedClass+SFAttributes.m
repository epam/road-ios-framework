//
//  AnnotatedClass+SFAttributes.m
//  SparkCore
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
#import "AnnotatedClass.h"
#import "NSObject+SFAttributesInternal.h"
 
@interface AnnotatedClass(SFAttribute)
 
@end
 
@implementation AnnotatedClass(SFAttribute)
 
#pragma mark - Fill Attributes generated code (Ivars section)

static NSMutableArray __weak *sf_attributes_list_AnnotatedClass_ivar__someField = nil;

+ (NSArray *)sf_attributes_AnnotatedClass_ivar__someField {
    if (sf_attributes_list_AnnotatedClass_ivar__someField != nil) {
        return sf_attributes_list_AnnotatedClass_ivar__someField;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_AnnotatedClass_ivar__someField = attributesArray;
    
    return sf_attributes_list_AnnotatedClass_ivar__someField;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForIvarsDict = nil;
    
+ (NSDictionary *)SF_attributesFactoriesForIvars {
    if (attributesAnnotatedClassFactoriesForIvarsDict != nil) {
        return attributesAnnotatedClassFactoriesForIvarsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForIvars];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_AnnotatedClass_ivar__someField)] forKey:@"_someField"];
    attributesAnnotatedClassFactoriesForIvarsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForIvarsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Properties section)

static NSMutableArray __weak *sf_attributes_list_AnnotatedClass_property_window = nil;

+ (NSArray *)sf_attributes_AnnotatedClass_property_window {
    if (sf_attributes_list_AnnotatedClass_property_window != nil) {
        return sf_attributes_list_AnnotatedClass_property_window;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomSFTestAttribute *attr2 = [[CustomSFTestAttribute alloc] init];
    attr2.property2 = @"Text2";
    attr2.intProperty = (2+2)*2;
    [attributesArray addObject:attr2];

    sf_attributes_list_AnnotatedClass_property_window = attributesArray;
    
    return sf_attributes_list_AnnotatedClass_property_window;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForPropertiesDict = nil;
    
+ (NSDictionary *)SF_attributesFactoriesForProperties {
    if (attributesAnnotatedClassFactoriesForPropertiesDict != nil) {
        return attributesAnnotatedClassFactoriesForPropertiesDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForProperties];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
    
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_AnnotatedClass_property_window)] forKey:@"window"];
    attributesAnnotatedClassFactoriesForPropertiesDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForPropertiesDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Methods section)

static NSMutableArray __weak *sf_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = nil;

+ (NSArray *)sf_attributes_AnnotatedClass_method_viewDidLoad_p0 {
    if (sf_attributes_list_AnnotatedClass_method_viewDidLoad_p0 != nil) {
        return sf_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomSFTestAttribute *attr2 = [[CustomSFTestAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.property2 = @"Text2";
    [attributesArray addObject:attr2];

    sf_attributes_list_AnnotatedClass_method_viewDidLoad_p0 = attributesArray;
    
    return sf_attributes_list_AnnotatedClass_method_viewDidLoad_p0;
}

static NSMutableArray __weak *sf_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = nil;

+ (NSArray *)sf_attributes_AnnotatedClass_method_viewDidLoad_p1 {
    if (sf_attributes_list_AnnotatedClass_method_viewDidLoad_p1 != nil) {
        return sf_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:1];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    sf_attributes_list_AnnotatedClass_method_viewDidLoad_p1 = attributesArray;
    
    return sf_attributes_list_AnnotatedClass_method_viewDidLoad_p1;
}

static NSMutableDictionary __weak *attributesAnnotatedClassFactoriesForMethodsDict = nil;
    
+ (NSDictionary *)SF_attributesFactoriesForMethods {
    if (attributesAnnotatedClassFactoriesForMethodsDict != nil) {
        return attributesAnnotatedClassFactoriesForMethodsDict;
    }
    
    NSMutableDictionary *dictionaryHolder = [super SF_attributesFactoriesForMethods];
    
    if (!dictionaryHolder) {
        dictionaryHolder = [NSMutableDictionary dictionary];
    }
        
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_AnnotatedClass_method_viewDidLoad_p0)] forKey:@"viewDidLoad"];
    [dictionaryHolder setObject:[self SF_invocationForSelector:@selector(sf_attributes_AnnotatedClass_method_viewDidLoad_p1)] forKey:@"viewDidLoad:"];
    attributesAnnotatedClassFactoriesForMethodsDict = dictionaryHolder;  
    
    return attributesAnnotatedClassFactoriesForMethodsDict;
}


#pragma mark - 

#pragma mark - Fill Attributes generated code (Class section)

static NSMutableArray __weak *sf_attributes_list__class_AnnotatedClass = nil;

+ (NSArray *)SF_attributesForClass {
    if (sf_attributes_list__class_AnnotatedClass != nil) {
        return sf_attributes_list__class_AnnotatedClass;
    }
    
    NSMutableArray *attributesArray = [NSMutableArray arrayWithCapacity:2];
    
    SFTestAttribute *attr1 = [[SFTestAttribute alloc] init];
    [attributesArray addObject:attr1];

    CustomSFTestAttribute *attr2 = [[CustomSFTestAttribute alloc] init];
    attr2.property1 = @"Text1";
    attr2.dictionaryProperty = @{
                @"key1" : @"[value1",
                @"key2" : @"value2]"
              };
    attr2.arrayProperty = @[@'a',@'b',@'[',@'[', @']', @'{', @'{', @'}', @'"', @'d', @'"'];
    attr2.blockProperty = ^(NSString* sInfo, int *result) {
                  if (sInfo == nil) {
                      *result = 1;
                      return;
                  }
                  
                  if ([sInfo length] == 0) {
                      *result = 2;
                      return;
                  }
                  
                  *result = 0;
              };
    [attributesArray addObject:attr2];

    sf_attributes_list__class_AnnotatedClass = attributesArray;
    
    return sf_attributes_list__class_AnnotatedClass;
}

#pragma mark - 

@end
