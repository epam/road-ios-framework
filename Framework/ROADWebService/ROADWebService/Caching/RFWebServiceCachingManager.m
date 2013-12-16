//
//  RFWebServiceCachingManager.m
//  ROADWebService
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

#import "RFWebServiceCachingManager.h"
#import <CoreData/CoreData.h>
#import <ROAD/ROADCore.h>
#import <ROAD/ROADLogger.h>

#import "RFWebResponse.h"
#import "RFWebServiceCacheContext.h"


static NSString * const kRFWebResponseEntityName = @"WebResponse";

const char * RFWebServiceCacheQueueName = "RFWebServiceCacheQueue";

@implementation RFWebServiceCachingManager {
    dispatch_queue_t _cacheQueue;
    
    RFWebServiceCacheContext * _cacheContext;
}


#pragma mark - Initialization

- (id)init {
    self = [super init];
    if (self) {
        _cacheQueue = dispatch_queue_create(RFWebServiceCacheQueueName, DISPATCH_QUEUE_SERIAL);
        _cacheContext = [[RFWebServiceCacheContext alloc] init];
    }
    return self;
}

- (void)setCacheWithRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response responseBodyData:(NSData *)responseBodyData expirationDate:(NSDate *)expirationDate {
    if (!expirationDate) {
        expirationDate = [RFWebServiceCachingManager expirationDateFromResponse:response];
    }
    
    if ([expirationDate compare:[NSDate date]] == NSOrderedAscending) {
        dispatch_sync(_cacheQueue, ^{
            NSManagedObjectContext *managedObjectContext = _cacheContext.context;
            
            RFWebResponse *newWebResponse = [NSEntityDescription insertNewObjectForEntityForName:kRFWebResponseEntityName inManagedObjectContext:managedObjectContext];
            newWebResponse.urlHash = [[NSDecimalNumber alloc] initWithUnsignedInteger:[[request.URL absoluteString] hash]];
            newWebResponse.requestURL = [request.URL absoluteString];
            newWebResponse.requestBodyData = request.HTTPBody;
            newWebResponse.response = [NSKeyedArchiver archivedDataWithRootObject:response];
            newWebResponse.responseBodyData = responseBodyData;
            newWebResponse.expirationDate = expirationDate;
            newWebResponse.eTag = [RFWebServiceCachingManager etagFromResponse:response];
            
            NSError *error;
            [managedObjectContext save:&error];
            RFLogError(@"RFWebServiceCachingManager error: saving cached response failed with error: %@", [error localizedDescription]);
        });

    }
}

- (id)cacheWithRequest:(NSURLRequest *)request {
    NSUInteger requestURLHash = [[request.URL absoluteString] hash];
    __block NSArray *cachedResponse;
    dispatch_sync(_cacheQueue, ^{
        NSManagedObjectContext *managedObjectContext = _cacheContext.context;
        NSFetchRequest *fetchCachedResponse = [[NSFetchRequest alloc] initWithEntityName:kRFWebResponseEntityName];
        fetchCachedResponse.predicate = [NSPredicate predicateWithFormat:@"urlHash == %@", requestURLHash];
        NSError *error;
        cachedResponse = [managedObjectContext executeFetchRequest:fetchCachedResponse error:&error];
    });
        
    return cachedResponse;
}


#pragma mark - Utility methods

static NSString * const kRFWebServiceHeaderFieldPragma              = @"Pragma";
static NSString * const kRFWebServiceHeaderFieldCacheControl        = @"Cache-Control";
static NSString * const kRFWebServiceHeaderFieldExpires             = @"Expires";
static NSString * const kRFWebServiceHeaderFieldETag                = @"ETag";
static NSString * const kRFWebServiceHeaderNoCacheValue             = @"no-cache";
static NSString * const kRFWebServiceHeaderMaxAgeKey                = @"max-age";
static NSString * const kRFWebServiceHeaderExpiresFormat            = @"EEE, dd MMM yyyy HH:mm:ss zzz";
static NSString * const kRFWebServiceHeaderParameterSeparator       = @",";
static NSString * const kRFWebServiceHeaderKeyValueSeparator        = @"=";
static const NSInteger kRFWebServiceHeaderValueParameterIndex       = 1;

+ (NSDate *)expirationDateFromResponse:(NSHTTPURLResponse *)response {
    NSDate *expirationDate;
    BOOL noCaching = NO;
    
    NSString *pragma = [response.allHeaderFields valueForKey:kRFWebServiceHeaderFieldPragma];
    if ([pragma rangeOfString:kRFWebServiceHeaderNoCacheValue].location != NSNotFound) {
        noCaching = YES;
    }
    
    NSString *cacheControl = [response.allHeaderFields valueForKey:kRFWebServiceHeaderFieldCacheControl];
    NSArray *cacheControlComponents = [cacheControl componentsSeparatedByString:kRFWebServiceHeaderParameterSeparator];
    
    if (!noCaching) {
        for (NSString *component in cacheControlComponents) {
            if ([component rangeOfString:kRFWebServiceHeaderNoCacheValue].location != NSNotFound) {
                noCaching = YES;
                break;
            }
            
            if ([component rangeOfString:kRFWebServiceHeaderMaxAgeKey].location != NSNotFound) {
                NSArray *maxAgeComponents = [component componentsSeparatedByString:kRFWebServiceHeaderKeyValueSeparator];
                NSString *maxAgeValue = maxAgeComponents[kRFWebServiceHeaderValueParameterIndex];
                NSInteger maxAge = [maxAgeValue integerValue];
                expirationDate = [NSDate dateWithTimeIntervalSinceNow:maxAge];
            }
        }
        
        if (!expirationDate && !noCaching) {
            NSString *expires = [response.allHeaderFields valueForKey:kRFWebServiceHeaderFieldExpires];
            NSDateFormatter *expiresDateFormatter = [[NSDateFormatter alloc] init];
            expiresDateFormatter.dateFormat = kRFWebServiceHeaderExpiresFormat;
            expirationDate = [expiresDateFormatter dateFromString:expires];
        }
    }
    
    return expirationDate;
}

+ (NSString *)etagFromResponse:(NSHTTPURLResponse *)response {
    return [response.allHeaderFields valueForKey:kRFWebServiceHeaderFieldETag];
}

@end
