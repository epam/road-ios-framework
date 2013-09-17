//
//  SFIvarInfo.m
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

#import "SFIvarInfo.h"

#import "SFTypeDecoder.h"
#import <objc/runtime.h>
#import "SparkAttribute.h"

@interface SFIvarInfo () {
    NSString *_name;
    NSString *_variableTypeName;
    BOOL _primitive;
    NSString *_className;
    Class _hostClass;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *variableTypeName;
@property (assign, nonatomic, getter = isPrimitive) BOOL primitive;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) Class hostClass;

@end


@implementation SFIvarInfo

@synthesize name = _name;
@synthesize variableTypeName = _variableTypeName;
@synthesize primitive = _primitive;
@synthesize className = _className;
@synthesize hostClass = _hostClass;

@dynamic attributes;

+ (NSArray *)ivarsOfClass:(Class)aClass {
    unsigned int memberCount = 0;
    Ivar * const ivarList = class_copyIvarList(aClass, &memberCount);
    NSMutableArray *array = [NSMutableArray array];
    
    for (unsigned int index = 0; index < memberCount; index++) {
        SFIvarInfo *descriptor = [self SF_infoFromIvar:ivarList[index]];
        descriptor.className = NSStringFromClass(aClass);
        descriptor.hostClass = aClass;
        [array addObject:descriptor];
    }
    
    free(ivarList);
    return array;
}

+ (SFIvarInfo *)SF_ivarNamed:(NSString *const)ivarName ofClass:(Class)aClass {
    Ivar anIvar = class_getInstanceVariable(aClass, [ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    SFIvarInfo *descriptor = [self SF_infoFromIvar:anIvar];
    descriptor.className = NSStringFromClass(aClass);
    descriptor.hostClass = aClass;
    return descriptor;
}

+ (SFIvarInfo *)SF_infoFromIvar:(Ivar)anIvar {
    SFIvarInfo * const info = [[SFIvarInfo alloc] init];
    info.name = [NSString stringWithCString:ivar_getName(anIvar) encoding:NSUTF8StringEncoding];
    
    NSString *typeEncoding = [NSString stringWithCString:ivar_getTypeEncoding(anIvar) encoding:NSUTF8StringEncoding];
    info.variableTypeName = [SFTypeDecoder nameFromTypeEncoding:typeEncoding];
    info.primitive = [SFTypeDecoder isPrimitiveType:typeEncoding];

    return info;
}

- (NSArray *)attributes {
    return [self.hostClass SF_attributesForIvar:self.name];
}

- (id)attributeWithType:(Class)requiredClassOfAttribute {
    return [self.hostClass SF_attributeForIvar:self.name withAttributeType:requiredClassOfAttribute];
}


@end
