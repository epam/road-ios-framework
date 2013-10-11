//
//  RFIvarInfo.m
//  ROADCore
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "RFIvarInfo.h"

#import "RFTypeDecoder.h"
#import <objc/runtime.h>
#import "ROADAttribute.h"

@interface RFIvarInfo () {
    NSString *_name;
    NSString *_typeName;
    BOOL _primitive;
    NSString *_className;
    Class _hostClass;
    
    Ivar _ivar;
    BOOL _isPrimitiveFilled;
}

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *typeName;
@property (assign, nonatomic, getter = isPrimitive) BOOL primitive;
@property (copy, nonatomic) NSString *className;
@property (assign, nonatomic) Class hostClass;

@end


@implementation RFIvarInfo

@synthesize name = _name;
@synthesize typeName = _typeName;
@synthesize primitive = _primitive;
@synthesize className = _className;
@synthesize hostClass = _hostClass;

@dynamic attributes;

+ (NSArray *)ivarsOfClass:(Class)aClass {
    unsigned int memberCount = 0;
    Ivar * const ivarList = class_copyIvarList(aClass, &memberCount);
    NSMutableArray *array = [NSMutableArray array];
    
    for (unsigned int index = 0; index < memberCount; index++) {
        RFIvarInfo *descriptor = [self RF_infoFromIvar:ivarList[index]];
        descriptor.className = NSStringFromClass(aClass);
        descriptor.hostClass = aClass;
        [array addObject:descriptor];
    }
    
    free(ivarList);
    return array;
}

+ (RFIvarInfo *)RF_ivarNamed:(NSString *const)ivarName ofClass:(Class)aClass {
    Ivar anIvar = class_getInstanceVariable(aClass, [ivarName cStringUsingEncoding:NSUTF8StringEncoding]);
    RFIvarInfo *descriptor = [self RF_infoFromIvar:anIvar];
    descriptor.className = NSStringFromClass(aClass);
    descriptor.hostClass = aClass;
    return descriptor;
}

+ (RFIvarInfo *)RF_infoFromIvar:(Ivar)anIvar {
    RFIvarInfo * const info = [[RFIvarInfo alloc] initWithIvar:anIvar];
    info.name = [NSString stringWithCString:ivar_getName(anIvar) encoding:NSUTF8StringEncoding];
    
    return info;
}

- (id)initWithIvar:(Ivar)ivar {
    self = [super init];
    if (self) {
        _ivar = ivar;
        _isPrimitiveFilled = NO;
    }
    return self;
}

- (NSArray *)attributes {
    return [self.hostClass RF_attributesForIvar:self.name];
}

- (id)attributeWithType:(Class)requiredClassOfAttribute {
    return [self.hostClass RF_attributeForIvar:self.name withAttributeType:requiredClassOfAttribute];
}

- (BOOL)isPrimitive {
    if (!_isPrimitiveFilled) {
        NSString *typeEncoding = [NSString stringWithCString:ivar_getTypeEncoding(_ivar) encoding:NSUTF8StringEncoding];
        _primitive = [RFTypeDecoder RF_isPrimitiveType:typeEncoding];
        _isPrimitiveFilled = YES;
    }
    
    return _primitive;
}

- (NSString *)typeName {
    if (!_typeName) {
        NSString *typeEncoding = [NSString stringWithCString:ivar_getTypeEncoding(_ivar) encoding:NSUTF8StringEncoding];
        _typeName = [RFTypeDecoder nameFromTypeEncoding:typeEncoding];
    }
    
    return _typeName;
}

@end
