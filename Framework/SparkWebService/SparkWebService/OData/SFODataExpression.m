//
//  SFODataExpression.m
//  SparkWebservice
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

#import "SFODataExpression.h"

#import "SFODataPredicate.h"
#import "SFODataProperty.h"
#import <Spark/SparkSerialization.h>

@implementation SFODataExpression

- (id)initWithValue:(NSString *)value {
    self = [super init];
    
    if (self) {
        _expression = [value copy];
    }
    
    return self;
}

- (id)initWithProperty:(SFPropertyInfo *)property {

    self = [self initWithMultiLevelProperty:@[property]];
    
    return self;
}

- (id)initWithMultiLevelProperty:(NSArray *)properties {
    NSMutableString *propertyName = nil;
    for (SFPropertyInfo *propertyInfo in properties) {
        NSString *propertyAttributeName = [SFODataExpression propertyAttributeNameFromInfo:propertyInfo];
        if (propertyName) {
            [propertyName appendFormat:@"/%@", propertyAttributeName];
        }
        else {
            propertyName = [propertyAttributeName mutableCopy];
        }
    }
    
    self = [self initWithValue:propertyName];
    
    return self;
}



- (id)initWithPredicate:(SFODataPredicate *)predicate {
    self = [self initWithValue:[predicate description]];
    
    return self;
}

- (NSString *)description {
    return _expression;
}

+ (NSString *)propertyAttributeNameFromInfo:(SFPropertyInfo *)propertyInfo {
    SFODataProperty *dataPropertyAttribute = [propertyInfo attributeWithType:[SFODataProperty class]];
    if (dataPropertyAttribute) {
        return [dataPropertyAttribute serializationKey];
    }
    
    SFSerializable *serializablePropertyAttribute = [propertyInfo attributeWithType:[SFSerializable class]];
    if (serializablePropertyAttribute) {
        return [serializablePropertyAttribute serializationKey];
    }
    
    return [propertyInfo getterName];
}

@end
