//
//  ROADJSONParser.m
//  ROADClassesGenerator
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
//

#import "ROADJSONParser.h"

@implementation ROADJSONParser

+ (ROADClassModel *)parseJSONFromFilePath:(NSString *)path error:(NSError **)error {
    NSData *jsonData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:error];
    id jsonRootObject = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:error];
    NSDictionary *jsonDictionary;
    
    if ([jsonRootObject isKindOfClass:[NSArray class]]) {
        jsonDictionary = [jsonRootObject firstObject];
    }
    if ([jsonRootObject isKindOfClass:[NSDictionary class]]) {
        jsonDictionary = jsonRootObject;
    }
    return [ROADJSONParser parseJsonObject:jsonDictionary withName:@"Result"];
}

+ (ROADClassModel *)parseJsonObject:(NSDictionary *)jsonDictionary withName:(NSString *)name {
    ROADClassModel *classModel = [[ROADClassModel alloc] initWithName:[ROADJSONParser forClassName:name]];
    if([jsonDictionary isKindOfClass:[NSDictionary class]]){
        for (NSString *key in jsonDictionary) {
            ROADPropertyModel *propertyModel = [[ROADPropertyModel alloc] init];
            id jsonObject = [jsonDictionary valueForKey:key];
            
            if ([jsonObject isKindOfClass:[NSString class]]) {
                if ([key rangeOfString:@"Date"].location != NSNotFound || [key rangeOfString:@"date"].location != NSNotFound) {
                    propertyModel = [ROADJSONParser propertyModelDateWithObject:jsonObject withPropertyName:key];
                }
                else {
                    propertyModel = [ROADJSONParser propertyModelStringWithObject:jsonObject withPropertyName:key];
                }
            }
            else if ([jsonObject isKindOfClass:[NSNumber class]]) {
                propertyModel = [ROADJSONParser propertyModelNumberWithObject:jsonObject withPropertyName:key];
            }
            else if ([jsonObject isKindOfClass:[NSArray class]]) {
                propertyModel = [ROADJSONParser propertyModelArrayWithObject:jsonObject withPropertyName:key];
            }
            else if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                propertyModel = [ROADJSONParser propertyModelCustomWithObject:jsonObject withPropertyName:key];
            }
            [classModel addProperty:propertyModel];
        }
    }
    [ROADClassModel registerModel:classModel];
    return classModel;
}

+ (ROADPropertyModel *)propertyModelDateWithObject:(id)propertyObject withPropertyName:(NSString *)propertyName {
    ROADPropertyModel *propertyModel = [[ROADPropertyModel alloc] init];
    propertyModel.propertyClassName = NSStringFromClass([NSDate class]);
    propertyModel.propertyClass = [NSDate class];
    propertyModel.propertyName = [ROADJSONParser forDatePropertyName:propertyName];
    return propertyModel;
}

+ (ROADPropertyModel *)propertyModelStringWithObject:(id)propertyObject withPropertyName:(NSString *)propertyName {
    ROADPropertyModel *propertyModel = [[ROADPropertyModel alloc] init];
    propertyModel.propertyClassName = NSStringFromClass([NSString class]);
    propertyModel.propertyClass = [NSString class];
    propertyModel.propertyName = [ROADJSONParser forStringPropertyName:propertyName];
    return propertyModel;
}

+ (ROADPropertyModel *)propertyModelNumberWithObject:(id)propertyObject withPropertyName:(NSString *)propertyName {
    ROADPropertyModel *propertyModel = [[ROADPropertyModel alloc] init];
    propertyModel.propertyClassName = NSStringFromClass([NSNumber class]);
    propertyModel.propertyClass = [NSNumber class];
    propertyModel.propertyName = [ROADJSONParser forNumberPropertyName:propertyName];
    return propertyModel;
}

+ (ROADPropertyModel *)propertyModelArrayWithObject:(id)propertyObject withPropertyName:(NSString *)propertyName {
    ROADPropertyModel *propertyModel = [[ROADPropertyModel alloc] init];
    propertyModel.propertyClassName = NSStringFromClass([NSArray class]);
    id objectInArray = [propertyObject firstObject];
    propertyModel.propertyClass = [ROADJSONParser parseObjectClass:objectInArray withName:propertyName];
    propertyModel.propertyName = propertyName;
    return propertyModel;
}

+ (ROADPropertyModel *)propertyModelCustomWithObject:(id)propertyObject withPropertyName:(NSString *)propertyName {
    ROADPropertyModel *propertyModel = [[ROADPropertyModel alloc] init];
    ROADClassModel *propertyClassModel = [ROADClassModel registeredModelWithName:propertyName];
    if (!propertyClassModel) {
        propertyClassModel = [self parseJsonObject:propertyObject withName:propertyName];
    }
    propertyModel.propertyClassName = [ROADJSONParser forClassName:propertyName];
    propertyModel.propertyClass = propertyClassModel;
    propertyModel.propertyName = [ROADJSONParser forCustomPropertyName:propertyName];
    return propertyModel;
}

+ (id)parseObjectClass:(id)object withName:(NSString *)objectClassName{
    if ([object isKindOfClass:[NSString class]]) {
        return [NSString class];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        return [NSNumber class];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        return [NSArray class];
    }
    ROADClassModel *propertyClassModel = [ROADClassModel registeredModelWithName:[ROADJSONParser forArrayPropertyName:objectClassName]];
    if (!propertyClassModel) {
        propertyClassModel = [self parseJsonObject:object withName:[ROADJSONParser forArrayPropertyName:objectClassName]];
    }
    
    return propertyClassModel.name;
}

+ (NSString *)forDatePropertyName:(NSString *)name {
    return name;
}

+ (NSString*)forStringPropertyName:(NSString *)name {
    return name;
}

+ (NSString *)forArrayPropertyName:(NSString *)name {
    return ([name characterAtIndex:(name.length - 1)] == 's') ? [name substringToIndex:(name.length - 1)] : name;
}

+ (NSString *)forNumberPropertyName:(NSString *)name {
    return name;
}

+ (NSString *)forCustomPropertyName:(NSString *)name {
    return name;
}

+ (NSString *)forClassName:(NSString *)name {
    return [NSString stringWithFormat:@"%@%@",[[name substringToIndex:1] uppercaseString],[name substringFromIndex:1]];
}

@end
