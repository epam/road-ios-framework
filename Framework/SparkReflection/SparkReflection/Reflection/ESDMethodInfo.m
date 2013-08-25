//
//  ESDMethodInfo.m
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


#import "ESDMethodInfo.h"
#import "ESDEncodingMapper.h"
#import <objc/runtime.h>

// The number hidden of method arguments: self and _cmd
static NSUInteger const kESDMethodArgumentOffset = 2;

@implementation ESDMethodInfo {
    NSArray *argumentTypes;
}

+ (NSArray *)methodsOfClass:(__unsafe_unretained Class const)aClass {
    unsigned int numberOfMethods = 0;
    NSMutableArray * const result = [[NSMutableArray alloc] init];
    
    Method *methods = class_copyMethodList(aClass, &numberOfMethods);
    [result addObjectsFromArray:[self methodInfoList:methods count:numberOfMethods ofClass:aClass areClassMethods:NO]];
    free(methods);
    
    methods = class_copyMethodList(object_getClass(aClass), &numberOfMethods);
    [result addObjectsFromArray:[self methodInfoList:methods count:numberOfMethods ofClass:aClass areClassMethods:YES]];
    free(methods);
    
    return result;
}

+ (ESDMethodInfo *)instanceMethodNamed:(NSString *)methodName forClass:(__unsafe_unretained Class const)aClass {
    Method aMethod = class_getInstanceMethod(aClass, NSSelectorFromString(methodName));
    ESDMethodInfo * const info = [self methodInfo:aMethod forClass:aClass];
    info.classMethod = NO;
    return info;
}

+ (ESDMethodInfo *)classMethodNamed:(NSString *)methodName forClass:(__unsafe_unretained Class const)aClass {
    Method aMethod = class_getClassMethod(aClass, NSSelectorFromString(methodName));
    ESDMethodInfo * const info = [self methodInfo:aMethod forClass:aClass];
    info.classMethod = YES;
    return info;
}

+ (ESDMethodInfo *)methodInfo:(Method const)aMethod forClass:(__unsafe_unretained Class const)aClass {
    ESDMethodInfo * const info = [[ESDMethodInfo alloc] init];
    info.className = NSStringFromClass(aClass);
    info.name = NSStringFromSelector(method_getName(aMethod));
    info.numberOfArguments = (NSUInteger)method_getNumberOfArguments(aMethod) - kESDMethodArgumentOffset;
    info->argumentTypes = [self mapArgumentTypeEncodingForMethod:aMethod numberOfArguments:info.numberOfArguments];
    info.returnType = [self mapReturnTypeEncodingForMethod:aMethod];
    return info;
}

+ (NSArray *)methodInfoList:(const Method *)methods
                      count:(unsigned int const)numberOfMethods
                    ofClass:(__unsafe_unretained Class const)aClass
            areClassMethods:(const BOOL)areClassMethods {

    NSMutableArray * const result = [[NSMutableArray alloc] init];
    ESDMethodInfo *info;
    
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

+ (NSArray *)mapArgumentTypeEncodingForMethod:(Method const)aMethod numberOfArguments:(NSUInteger const)numberOfArguments {
    NSMutableArray * const array = [[NSMutableArray alloc] init];
    
    for (unsigned int index = kESDMethodArgumentOffset; index < numberOfArguments + kESDMethodArgumentOffset; index++) {
        char *argEncoding = method_copyArgumentType(aMethod, index);
        [array addObject:[ESDEncodingMapper nameFromTypeEncoding:[NSString stringWithCString:argEncoding encoding:NSUTF8StringEncoding]]];
        free(argEncoding);
    }
    
    return array;
}

+ (NSString *)mapReturnTypeEncodingForMethod:(Method const)aMethod {
    char *returnTypeEncoding = method_copyReturnType(aMethod);
    NSString * const result = [NSString stringWithCString:returnTypeEncoding encoding:NSUTF8StringEncoding];
    free(returnTypeEncoding);
    return [ESDEncodingMapper nameFromTypeEncoding:result];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@:%@, argument types: %@, return type: %@", [super description], _className, _name, [argumentTypes componentsJoinedByString:@","], _returnType];
}

@end