//
//  NSArray+RFEmptyArrayChecks.h
//  ROADCore
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


#import "RFWebServiceCacheMigrationPolicy.h"
#import "RFWebResponse.h"

static NSString* const RFUrlHashName = @"urlHash";
static NSString* const RFRequestURLName = @"requestURL";
static NSString* const RFResponseBodyDataName = @"responseBodyData";
static NSString* const RFExpirationDateName = @"expirationDate";
static NSString* const RFETagName = @"eTag";
static NSString* const RFRequestBodyDataName = @"requestBodyData";
static NSString* const RFResponseName = @"response";
static NSString* const RFLastModifiedName = @"lastModified";

@implementation RFWebServiceCacheMigrationPolicy

- (BOOL)createDestinationInstancesForSourceInstance:(NSManagedObject *)sourceInstance
                                      entityMapping:(NSEntityMapping *)mapping
                                            manager:(NSMigrationManager *)manager
                                              error:(NSError *__autoreleasing *)error {
    
    if (![mapping.name isEqualToString:@"WebResponse3ToWebResponse4"]) {
        return [super createDestinationInstancesForSourceInstance:sourceInstance
                                                    entityMapping:mapping
                                                          manager:manager
                                                            error:error];
    }
    
    NSManagedObject* webResponse = [NSEntityDescription insertNewObjectForEntityForName:[mapping destinationEntityName]
                                                                 inManagedObjectContext:[manager destinationContext]];
    
    //TODO: check cacheIdentifier
    [webResponse setValue:[sourceInstance valueForKey:RFUrlHashName] forKeyPath:RFUrlHashName];
    
    RFWebResponseImplementation* implementation = [[RFWebResponseImplementation alloc] init];
    
    implementation.requestURL = [sourceInstance valueForKey:RFRequestURLName];
    implementation.responseBodyData = [sourceInstance valueForKey:RFResponseBodyDataName];
    implementation.expirationDate = [sourceInstance valueForKey:RFExpirationDateName];
    implementation.eTag = [sourceInstance valueForKey:RFETagName];
    implementation.requestBodyData = [sourceInstance valueForKey:RFRequestBodyDataName];
    implementation.response = [sourceInstance valueForKey:RFResponseName];
    implementation.lastModified = [sourceInstance valueForKey:RFLastModifiedName];
    
    [webResponse setValue:implementation forKeyPath:@"implementationPrivate"];
    
    [manager associateSourceInstance:sourceInstance
             withDestinationInstance:webResponse
                    forEntityMapping:mapping];
    
    return YES;
}

@end
