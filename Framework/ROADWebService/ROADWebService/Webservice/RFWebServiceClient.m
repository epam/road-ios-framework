//
//
//  RFWebServiceClient.m
//  ROADWebService
//
//  Copyright (c) 2014 Epam Systems. All rights reserved.
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


#import "RFWebServiceClient.h"

#import "RFAuthenticating.h"
#import "RFDefaultSerializer.h"
#import "RFWebService.h"
#import "RFWebServiceSerializer.h"
#import "RFWebServiceHeader.h"


@implementation RFWebServiceClient


#pragma mark - Initialization

- (id)init {
    self = [super init];
 
    if (self) {
        [self configureServiceRoot];
        [self configureSerializer];
        [self configureSharedHeaders];
    }
    
    return self;
}

- (id)initWithServiceRoot:(NSString *)serviceRoot {
    self = [self init];
    
    if (self) {
        _serviceRoot = serviceRoot;
    }
    
    return self;
}

- (void)configureSerializer {
    // Creates custom serializer if it was specified
    RFWebServiceSerializer *serializerAttribute = [[self class] RF_attributeForClassWithAttributeType:[RFWebServiceSerializer class]];
    if (serializerAttribute.serializerClass) {
        _serializationDelegate = [[serializerAttribute.serializerClass alloc] init];
    }
    else {
        _serializationDelegate = [[RFDefaultSerializer alloc] init];
    }
}

- (void)configureSharedHeaders {
    RFWebServiceHeader *headerAttribute = [[self class] RF_attributeForClassWithAttributeType:[RFWebServiceHeader class]];
    if (headerAttribute.headerFields) {
        _sharedHeaders = [headerAttribute.headerFields mutableCopy];
    }
    else {
        _sharedHeaders = [[NSMutableDictionary alloc] init];
    }
}

- (void)configureServiceRoot {
    RFWebService *webServiceAttribute = [[self class] RF_attributeForClassWithAttributeType:[RFWebService class]];

    if (webServiceAttribute) {
        _serviceRoot = webServiceAttribute.serviceRoot;
    }
}


#pragma mark - Authentication provider

- (void)setAuthenticationProvider:(id<RFAuthenticating>)authenticationProvider {
    // Managing authentication provider webServiceClient property
    _authenticationProvider.webServiceClient = nil;
    authenticationProvider.webServiceClient = self;
    
    _authenticationProvider = authenticationProvider;
    
}

@end
