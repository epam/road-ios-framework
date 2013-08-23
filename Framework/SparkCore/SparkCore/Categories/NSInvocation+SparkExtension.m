//
//  NSInvocation+SparkExtension.m
//  SparkCore
//
//  Created by Igor Chesnokov on 8/23/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import "NSInvocation+SparkExtension.h"

@implementation NSInvocation (SparkExtension)

+ (NSInvocation *)invocationForSelector:(SEL)selector target:(id)target  {
    NSMethodSignature *methodSig = [target methodSignatureForSelector:selector];
    if (methodSig == nil) {
        return nil;
    }
    
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setSelector:selector];
    [invocation setTarget:target];
    
    return invocation;
}

@end
