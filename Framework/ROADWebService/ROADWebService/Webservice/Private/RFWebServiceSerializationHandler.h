//
//  RFWebServiceSerializationHandler.h
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


@protocol RFSerializationDelegate;


/**
 Serialization handler. It performs both serialization and deserialization.
 */
@interface RFWebServiceSerializationHandler : NSObject

/**
 Serialize an Object using the given serializer object to a byte series with specified charset encoding.
 @param object The object to serialize from
 @param serializationObject The serializer
 @param callbackBlock The callback block to call when serialization completes.
 */
+(void)serializeObject:(id)object withSerialzer:(id<RFSerializationDelegate>)serializationObject withCompletitionBlock:(void(^)(NSString *serializedString, NSError *error))callbackBlock;

/**
 Deserialize data to a class with the given serializator object. 
 @param data The data to deserialize from
 @param serializationObject The serializer
 @param serializationRoot The key path of serialized object (e.g. json or xml object representation) from which serialization will be started
 @param deserializationClass The class to deserialize to.
 @param stringEncoding The charset encoding to be used when deserialise from the series of bytes
 @param callbackBlock The callback block to call when deserialization completes.
 */
+(void)deserializeData:(NSData * const)data withSerializer:(id<RFSerializationDelegate>)serializationObject serializationRoot:(NSString *)serializationRoot withDeserializationClass:(Class)deserializationClass withStringEncoding:(NSStringEncoding)stringEncoding withCompletitionBlock:(void(^)(id deserializedObject, NSError *error))callbackBlock;

@end

