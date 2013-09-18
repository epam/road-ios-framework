//
//  SFMethodInfo.m
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


#import "SFMethodInfo.h"

#import "SFTypeDecoder.h"
#import <objc/runtime.h>
#import "SparkAttribute.h"

@interface SFMethodInfo () {
    NSString *_name;
    NSString *_className;
    Class _hostClass;
    NSUInteger _numberOfArguments;
    NSString *_returnType;
    BOOL _classMethod;
    
    NSArray *argumentTypes;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) Class hostClass;
@property (assign, nonatomic) NSUInteger numberOfArguments;
@property (copy, nonatomic) NSString *returnType;
@property (assign, nonatomic, getter = isClassMethod) BOOL classMethod;
@end


// The number hidden of method arguments: self and _cmd
static NSUInteger const kSFMethodArgumentOffset = 2;

@implementation SFMethodInfo

@synthesize name = _name;
@synthesize className = _className;
@synthesize hostClass = _hostClass;
@synthesize numberOfArguments = _numberOfArguments;
@synthesize returnType = _returnType;
@synthesize classMethod = _classMethod;

@dynamic attributes;

+ (NSArray *)methodsOfClass:(Class)aClass {  
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    unsigned int numberOfInstanceMethods = 0;
    Method *instanceMethods = class_copyMethodList(aClass, &numberOfInstanceMethods);
    [result addObjectsFromArray:[self methodInfoList:instanceMethods count:numberOfInstanceMethods ofClass:aClass areClassMethods:NO]];
    free(instanceMethods);
    
    unsigned int numberOfClassMethods = 0;
    Method *classMethods = class_copyMethodList(object_getClass(aClass), &numberOfClassMethods);
    [result addObjectsFromArray:[self methodInfoList:classMethods count:numberOfClassMethods ofClass:aClass areClassMethods:YES]];
    free(classMethods);
    
    return result;
}

+ (SFMethodInfo *)instanceMethodNamed:(NSString *)methodName forClass:(Class)aClass {
    Method method = class_getInstanceMethod(aClass, NSSelectorFromString(methodName));
    SFMethodInfo *info = [self methodInfo:method forClass:aClass];
    info.classMethod = NO;
    return info;
}

+ (SFMethodInfo *)classMethodNamed:(NSString *)methodName forClass:(Class)aClass {
    Method method = class_getClassMethod(aClass, NSSelectorFromString(methodName));
    SFMethodInfo *info = [self methodInfo:method forClass:aClass];
    info.classMethod = YES;
    return info;
}

+ (SFMethodInfo *)methodInfo:(Method)method forClass:(Class)aClass {
    SFMethodInfo *info = [[SFMethodInfo alloc] init];
    info.className = NSStringFromClass(aClass);
    info.hostClass = aClass;
    info.name = NSStringFromSelector(method_getName(method));
    info.numberOfArguments = (NSUInteger)method_getNumberOfArguments(method) - kSFMethodArgumentOffset;
    info->argumentTypes = [self argumentsTypeNamesOfMethod:method numberOfArguments:info.numberOfArguments];
    info.returnType = [self returnTypeNameOfMethod:method];
    return info;
}

+ (NSArray *)methodInfoList:(const Method *)methods count:(unsigned int)numberOfMethods ofClass:(Class)aClass areClassMethods:(const BOOL)areClassMethods {
    NSMutableArray * const result = [[NSMutableArray alloc] init];
    SFMethodInfo *info;
    
    for (unsigned int index = 0; index < numberOfMethods; index++) {
        info = [self methodInfo:methods[index] forClass:aClass];
        info.classMethod = areClassMethods;
        [result addObject:info];
    }

    return result;
}

- (NSString *)typeOfArgumentAtIndex:(const NSUInteger)anIndex {
    return argumentTypes[anIndex];
}

+ (NSArray *)argumentsTypeNamesOfMethod:(Method)method numberOfArguments:(NSUInteger)numberOfArguments {
    NSMutableArray * const array = [[NSMutableArray alloc] init];
    
    for (unsigned int index = kSFMethodArgumentOffset; index < numberOfArguments + kSFMethodArgumentOffset; index++) {
        char *argEncoding = method_copyArgumentType(method, index);
        [array addObject:[SFTypeDecoder nameFromTypeEncoding:[NSString stringWithCString:argEncoding encoding:NSUTF8StringEncoding]]];
        free(argEncoding);
    }
    
    return array;
}

+ (NSString *)returnTypeNameOfMethod:(Method)method {
    char *returnTypeEncoding = method_copyReturnType(method);
    NSString * const result = [NSString stringWithCString:returnTypeEncoding encoding:NSUTF8StringEncoding];
    free(returnTypeEncoding);
    return [SFTypeDecoder nameFromTypeEncoding:result];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@:%@, argument types: %@, return type: %@", [super description], _className, _name, [argumentTypes componentsJoinedByString:@","], _returnType];
}

- (NSArray *)attributes {
    return [self.hostClass SF_attributesForMethod:self.name];
}

- (id)attributeWithType:(Class)requiredClassOfAttribute {
    return [self.hostClass SF_attributeForMethod:self.name withAttributeType:requiredClassOfAttribute];
}

@end
