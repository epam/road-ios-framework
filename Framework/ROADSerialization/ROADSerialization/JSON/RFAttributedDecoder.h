//
//  RFAnnotatedDecoder.h
//  ROADSerialization
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


#import <Foundation/Foundation.h>

/**
 * JSON deserializer. This class is using the RFSerializable and RFDerived attributes to map the JSON string to memory objects.
 */
@interface RFAttributedDecoder : NSObject

/**
 * Decodes a json string. If the json object contains the base class name information, this method can build up the total object hierarchy encoded.
 * @param jsonString The json string to decode.
 */
+ (id)decodeJSONString:(NSString * const)jsonString;

/**
 * Decodes a json string using the specified root class name and serialization root. Referenced object types are determined by the json string if it contained this piece of information or from the reflection framework.
 * @param jsonData The json data to decode.
 * @param serializationRoot Key path string to top most json object what will be serialized
 * @param rootClassName The root class name to the object whics will be used for decoding.
 */
+ (id)decodeJSONData:(NSData * const)jsonData withSerializtionRoot:(NSString *)serializationRoot rootClassNamed:(NSString * const)rootClassName;
/**
 * Decodes a json string using the specified root class name. Referenced object types are determined by the json string if it contained this piece of information or from the reflection framework.
 * @param jsonString The json string to decode.
 * @param rootClassName The root class name to the object whics will be used for decoding.
 */
+ (id)decodeJSONString:(NSString *const)jsonString withRootClassNamed:(NSString * const)rootClassName;

/**
 * Decodes a json data using the specified root class name. Referenced object types are determined by the json string if it contained this piece of information or from the reflection framework.
 * @param jsonData The json data object to decode.
 * @param rootClassName The root class name to the object which will be used for decoding.
 */
+ (id)decodeJSONData:(NSData * const)jsonData withRootClassNamed:(NSString * const)rootClassName;

/**
 * Links a NSDictinary or NSArray to specified class using attributes. If root class name set to nil method will return object without transformation.
 * @param jsonObject The predeserialized data object.
 * @param rootClassName The root class name to the object which will be used for mapping.
 */
+ (id)decodePredeserializedObject:(id)jsonObject withRootClassName:(NSString * const)rootClassName;

@end
