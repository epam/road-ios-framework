//
//  ESAlbum.h
//  ITunesSearch
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


#import <ROAD/ROADSerialization.h>


/**
 * We need to map class on web service response.
 * First we mark this class as serializable.
 */
RF_ATTRIBUTE(RFSerializable)
@interface ESAlbum : NSObject

/**
 * Then we mark all the properties we want to be serializable in this class.
 * And define serializationKey if necessary.
 * Good practice will be specifying serializationKey for every property.
 * In this case you can refactor property name later without fear.
 */
RF_ATTRIBUTE(RFSerializable, serializationKey = @"artworkUrl60")
@property NSString *artistName;

RF_ATTRIBUTE(RFSerializable, serializationKey = @"collectionName")
@property NSString *name;

RF_ATTRIBUTE(RFSerializable, serializationKey = @"collectionViewUrl")
@property NSString *viewURL;

RF_ATTRIBUTE(RFSerializable, serializationKey = @"artworkUrl60")
@property NSString *artworkURL;

RF_ATTRIBUTE(RFSerializable, serializationKey = @"collectionPrice")
@property NSNumber *price;

RF_ATTRIBUTE(RFSerializable)
@property NSString *currency;

/**
 * This property is just a composition of two previous. It won't be serialized.
 */
RF_ATTRIBUTE(RFDerived)
@property (readonly) NSString *priceLabel;

RF_ATTRIBUTE(RFSerializable)
@property NSNumber *trackCount;

/**
 * For serializing of dates we have efficient mechanism too. 
 * Just specify RFSerializableDate and its parameter you need.
 * Allocation of NSDateFormatter is pretty expansive operation, 
 * but if you use this property we will try to create as less as possible, and reuse as much as possible.
 */
RF_ATTRIBUTE(RFSerializable)
RF_ATTRIBUTE(RFSerializableDate, format = @"yyyy-MM-dd'T'HH:mm:ss'Z'")
@property NSDate *releaseDate;

@end
