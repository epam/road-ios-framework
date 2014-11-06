//
//  ESITunesLookupSerializer.m
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


#import "ESITunesLookupSerializer.h"

#import <ROAD/ROADSerialization.h>
#import "ESArtist.h"
#import "ESAlbum.h"


@implementation ESITunesLookupSerializer

/**
 * In this particular example we don't need any action here. 
 * We just don't pass any object to serialize in request method.
 */
- (NSString *)serializeObject:(id)object {
    return [object description];
}

/**
 * We need to separate artist entity from album entities.
 * Then deserialize them and pass to sender.
 */
- (id)deserializeData:(NSData *)data serializationRoot:(NSString *)serializationRoot withDeserializationClass:(__unsafe_unretained Class)deserializationClass serializationEncoding:(NSStringEncoding)serializationEncoding error:(NSError *__autoreleasing *)error {
    // We want to parse data with standard serialization and then map it onto our object
    NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:error];
    NSArray *results = responseDictionary[serializationRoot];
    
    NSDictionary *artist;
    NSUInteger albumsCount = [results count] ? [results count] - 1 : 0;
    NSMutableArray *albums = [[NSMutableArray alloc] initWithCapacity:albumsCount];
    
    // Go throught result and separate different type of objects
    for (NSDictionary *result in results) {
        if ([@"artist" isEqualToString:result[@"wrapperType"]]) {
            // We found our artist
            artist = result;
        }
        else if ([@"collection" isEqualToString:result[@"wrapperType"]]
                 && [@"Album" isEqualToString:result[@"collectionType"]]) {
            [albums addObject:result];
        }
    }

    // Direct interface for mapping dictionary on model class is exposed for you, let's use it.
    ESArtist *deserializedArtist = artist ? [RFAttributedDecoder decodePredeserializedObject:artist withRootClassName:NSStringFromClass([ESArtist class])] : [[ESArtist alloc] init];
    NSArray *deserializedAlbums = [RFAttributedDecoder decodePredeserializedObject:albums withRootClassName:NSStringFromClass([ESAlbum class])];
    
    // Return it as a dictionary with predefined keys.
    return @{@"Artist" : deserializedArtist,
             @"Albums" : deserializedAlbums};
}

@end
