//
//  RFWebServiceCachingManaging.h
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

#import <Foundation/Foundation.h>

@class RFWebResponse;
@class RFWebServiceCache;

@protocol RFWebServiceCachingManaging <NSObject>

/**
 * Set one cache entry to the web service cache with an identifier for handling.
 *
 * @param request          The request that should be stored in the cache.
 * @param response         The response of the request.
 * @param responseBodyData The response data.
 * @param expirationDate   The timeout time of the cache.
 * @param cacheIdentifier  The identifier of the cache entry for direct handling.
 */
- (void)setCacheWithRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response responseBodyData:(NSData *)responseBodyData expirationDate:(NSDate *)expirationDate cacheIdentifier:(NSString *)cacheIdentifier;

/**
 * Set one cache entry to the web service cache.
 * @param request The request that should be stored in the cache.
 * @param response The response of the request.
 * @param responseBodyData The response data.
 * @param expirationDate The timeout time of the cache.
 */
- (void)setCacheWithRequest:(NSURLRequest *)request response:(NSHTTPURLResponse *)response responseBodyData:(NSData *)responseBodyData expirationDate:(NSDate *)expirationDate;

/**
 * Returns an array of cache objects from the cache.
 *
 * @param cacheIdentifier The identifier which identifies the cache data entry.
 *
 * @return retruns the array of the matching RFWebResponse instances
 */
- (NSArray *)cacheWithIdentifier:(NSString *)cacheIdentifier;

/**
 * Returns an array of cache objects from the cache which have matching cache idenfier prefixes.
 *
 * @param cacheIdentifierPrefix The identifier prefix which identifies the cache data entries with
 * cacheIdentifiers with the matching begining.
 *
 * @return returns the array of the matching RFWebResponse instances
 */
- (NSArray *)cacheWithIdentifierPrefix:(NSString *)cacheIdentifierPrefix;

/**
 * Returns the cache object from the cache. If no entry has found, returns nil.
 * @param request The request that should be check in the cache.
 */
- (RFWebResponse *)cacheWithRequest:(NSURLRequest *)request;

/**
 * Returns the cache object in case response tells that the cache object is still valid.
 * @param response The response from the web service.
 * @param request The request to the web service.
 */
- (RFWebResponse *)cacheForResponse:(NSHTTPURLResponse *)response request:(NSURLRequest *)request cacheAttribute:(RFWebServiceCache *)cacheAttribute;

/**
 * Flushes the targeted records from the cache.
 *
 * @param cacheIdentifier The identifier which identifies the cache data entry.
 */
- (void)flushElementsWithIdentifier:(NSString *)cacheIdentifier;

/**
 * Flushes the targeted records from the cache. This method aims to target multiple cache
 * elements in the cache with partially matching cache identifiers.
 *
 * @param cacheIdentifierPrefix The identifier prefix which identifies multiple cache data entries.
 */
- (void)flushElementsWithIdentifierPrefix:(NSString *)cacheIdentifierPrefix;

/**
 * Clear all record in cache
 */
- (void)dropCache;

/**
 * Parses the cache identifier string with the supplied parameters
 *
 * @param cacheIdentifier The identifier which identifies the cache data entry.
 * @param parameterValues The parameter dictionary to parse the cache identifier
 *
 * @return The parsed cache identifier string
 */
- (NSString *)parseCacheIdentifier:(NSString *)cacheIdentifier withParameters:(NSDictionary *)parameterValues;

@end
