//
//  RFWebResponse.m
//  ROADWebService
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


#import "RFWebResponse.h"

static NSString* const RFRequestURLName = @"requestURL";
static NSString* const RFResponseBodyDataName = @"responseBodyData";
static NSString* const RFExpirationDateName = @"expirationDate";
static NSString* const RFETagName = @"eTag";
static NSString* const RFRequestBodyDataName = @"requestBodyData";
static NSString* const RFResponseName = @"response";
static NSString* const RFLastModifiedName = @"lastModified";


@implementation RFWebResponseImplementation

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.requestURL forKey:RFRequestURLName];
    [aCoder encodeObject:self.responseBodyData forKey:RFResponseBodyDataName];
    [aCoder encodeObject:self.expirationDate forKey:RFExpirationDateName];
    [aCoder encodeObject:self.eTag forKey:RFETagName];
    [aCoder encodeObject:self.requestBodyData forKey:RFRequestBodyDataName];
    [aCoder encodeObject:self.response forKey:RFResponseName];
    [aCoder encodeObject:self.lastModified forKey:RFLastModifiedName];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if ( self = [super init] ) {
        _requestURL = [aDecoder decodeObjectForKey:RFRequestURLName];
        _responseBodyData = [aDecoder decodeObjectForKey:RFResponseBodyDataName];
        _expirationDate = [aDecoder decodeObjectForKey:RFExpirationDateName];
        _eTag = [aDecoder decodeObjectForKey:RFETagName];
        _requestBodyData = [aDecoder decodeObjectForKey:RFRequestBodyDataName];
        _response = [aDecoder decodeObjectForKey:RFResponseName];
        _lastModified = [aDecoder decodeObjectForKey:RFLastModifiedName];
    }
    return self;
}

@end

@interface RFWebResponse()
@property (nonatomic) RFWebResponseImplementation* implementationPrivate;
@end

@implementation RFWebResponse

@dynamic cacheIdentifier;
@dynamic urlHash;
@dynamic implementationPrivate;

- (id)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        self.implementationPrivate = [[RFWebResponseImplementation alloc] init];
    }
    return self;
}

/**
 * This pointer ping-pong is needed because CoreData doesn't see any changes in transformable field structure to which the pointer points. So we have to explicitly change the pointer itself to make CoreData take changes into account.
 */
- (RFWebResponseImplementation*)implementation {
    RFWebResponseImplementation* temp = self.implementationPrivate;
    self.implementationPrivate = temp;
    return self.implementationPrivate;
}

@end
