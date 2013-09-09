//
//  SFServiceProvider.m
//  SparkAnnotation
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


#import "SFServiceProvider.h"
#import <objc/runtime.h>
#import <Spark/SparkReflection.h>

const char *SFServiceMethodEncoding = "@@:";

@implementation SFServiceProvider {
    NSMutableDictionary *services;
}

SPARK_SYNTHESIZE_SINGLETON_FOR_CLASS_WITH_ACCESSOR(SFServiceProvider, sharedProvider, ^(SFServiceProvider* object){ [object initialize]; });

- (void)initialize {
    services = [NSMutableDictionary new];
}

#pragma mark - Method resolution

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    BOOL result;
    NSString *selectorName = NSStringFromSelector(sel);
    SFService * const serviceAttribute = [self attributeForMethod:selectorName withAttributeType:[SFService class]];

    
    if (serviceAttribute != nil) {
        result = YES;
        IMP const implementation = [self instanceMethodForSelector:@selector(fetchService)];
        class_addMethod(self, sel, implementation, SFServiceMethodEncoding);
    }
    else {
        result = [super resolveInstanceMethod:sel];
    }
    
    return result;
}

- (id)fetchService {
    NSString * const serviceName = NSStringFromSelector(_cmd);
    id theService = services[serviceName];
    
    if (theService == nil) {
        SFService * const serviceAnnotation = [[self class] attributeForMethod:serviceName withAttributeType:[SFService class]];
        __unsafe_unretained Class const serviceClass = serviceAnnotation.serviceClass;
        theService = [(id)serviceClass new];
        [self registerService:theService forServiceName:serviceName];
    }
    
    return theService;
}

#pragma mark - Service registration

- (void)registerService:(const id)aServiceInstance forServiceName:(NSString * const)serviceName {
    
    if (aServiceInstance != nil) {
        services[serviceName] = aServiceInstance;
    }
}

@end
