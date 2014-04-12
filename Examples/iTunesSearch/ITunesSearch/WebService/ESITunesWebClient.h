//
//  ESITunesWebClient.h
//  ITunesSearch
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


#import <ROAD/ROADWebservice.h>
#import <ROAD/RFWebServiceSerializer.h>
#import "ESITunesLookupSerializer.h"
#import "ESSoftware.h"


RF_ATTRIBUTE(RFWebService, serviceRoot = @"https://itunes.apple.com")
@interface ESITunesWebClient : RFWebServiceClient

/**
 *  This request returns json response simular to https://itunes.apple.com/search?term=paper&entity=software&limit=10
 *  The request will be sent by default with GET method and enabled serialization
 *  We specifies that we want only results array and individual elements of this array should be serialized into ESSoftware
 */
RF_ATTRIBUTE(RFWebServiceCall, relativePath = @"/search?term=%%0%%&entity=software&limit=10", prototypeClass = [ESSoftware class], serializationRoot = @"results")
- (id<RFWebServiceCancellable>)searchAppsWithName:(NSString *)appName success:(void(^)(NSArray *apps))successBlock failure:(void(^)(NSError *error))failureBlock;;

/**
 * A bit more complex request in terms of serialization.
 * As you see in the example: https://itunes.apple.com/lookup?amgArtistId=468749,5723&entity=album 
 * there're two possible types of items in result array. This case does not have standard implementation, 
 * so we need to override default response serializer
 * (There's another possible solution - check out RFSerializationCustomHandler attribute).
 */
RF_ATTRIBUTE(RFWebServiceSerializer, serializerClass = [ESITunesLookupSerializer class])
RF_ATTRIBUTE(RFWebServiceCall, relativePath = @"/lookup?amgArtistId=%%0%%&entity=album", serializationRoot = @"results")
- (id<RFWebServiceCancellable>)lookupAmgArtistId:(NSString *)amgArtistId success:(void(^)(NSDictionary *albumsInfo))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
