//
//  SFPropertyInfo.m
//  SparkReflection
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


#import "SFPropertyInfo.h"
#import "SFEncodingMapper.h"
#import "NSCharacterSet+EncodingCharacterSet.h"
#import <objc/runtime.h>
#import "SparkAttribute.h"

@implementation SFPropertyInfo

@dynamic attributes;

+ (NSArray *)propertiesForClass:(__unsafe_unretained Class const)aClass {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    unsigned int numberOfProperties = 0;
    objc_property_t *propertiesArray = class_copyPropertyList(aClass, &numberOfProperties);
    
    for (int index = 0; index < numberOfProperties; index++) {
        [result addObject:[self property:propertiesArray[index] forClass:aClass]];
    }
    
    free(propertiesArray);
    return result;
}

+ (SFPropertyInfo *)propertyNamed:(NSString *)name forClass:(__unsafe_unretained Class const)aClass {
    objc_property_t prop = class_getProperty(aClass, [name cStringUsingEncoding:NSUTF8StringEncoding]);
    SFPropertyInfo *result = nil;
    
    if (prop != NULL) {
        result = [self property:prop forClass:aClass];
    }
    
    return result;
}

+ (NSArray *)propertiesForClass:(__unsafe_unretained Class const)class withPredicate:(NSPredicate * const)aPredicate {
    NSArray *result = [self propertiesForClass:class];
    return [result filteredArrayUsingPredicate:aPredicate];
}

// For reference see apple's documetation about declared properties:
// https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
+ (SFPropertyInfo *)property:(objc_property_t const)property forClass:(__unsafe_unretained Class const)class {
    SFPropertyInfo * const info = [[SFPropertyInfo alloc] init];
    NSString * const name = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
    NSString * const attributeName = [self propertyAttributeNameForField:"T" property:property];
    NSString * const getterName = [self propertyAttributeNameForField:"G" property:property];
    NSString * const setterName = [self propertyAttributeNameForField:"S" property:property];
    
    info.propertyName = name;
    info.attributeClassName = [SFEncodingMapper nameFromTypeEncoding:attributeName];
    info.attributeClass = NSClassFromString([info.attributeClassName stringByTrimmingCharactersInSet:[NSCharacterSet pointerCharacterSet]]);
    info.object = [attributeName hasPrefix:@"@"];
    info.className = NSStringFromClass(class);
    info.hostClass = class;
    info.getterName = getterName;
    info.setterName = setterName;
    info.dynamic = [self property:property containsSpecifier:"D"];
    info.weak = [self property:property containsSpecifier:"W"];
    info.nonatomic = [self property:property containsSpecifier:"N"];
    info.readonly = [self property:property containsSpecifier:"R"];
    info.strong = [self property:property containsSpecifier:"&"];
    info.copied = [self property:property containsSpecifier:"C"];
    return info;
}

+ (NSString *)propertyAttributeNameForField:(const char *)fieldName property:(const objc_property_t)property {
    NSString *result;
    char *name = property_copyAttributeValue(property, fieldName);

    if (name != NULL) {
        result = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
        free(name);
    }
    
    return result;
}

+ (BOOL)property:(const objc_property_t)property containsSpecifier:(const char *)specifier {
    char *attributeValue = property_copyAttributeValue(property, specifier);
    BOOL const result = attributeValue != NULL;
    free(attributeValue);
    return result;
}

- (NSArray *)attributes {
    return [self.hostClass SF_attributesForProperty:self.propertyName];
}

- (id)attributeWithType:(Class)requiredClassOfAttribute {
    return [self.hostClass SF_attributeForProperty:self.propertyName withAttributeType:requiredClassOfAttribute];
}

@end
