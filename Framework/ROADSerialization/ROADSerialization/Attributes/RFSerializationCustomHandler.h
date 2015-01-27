//
//  RFSerializationCustomHandler.h
//  ROADSerialization
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
#import <ROAD/ROADAttribute.h>


typedef id(^RFSerializationValuePreprocessor)(id value);


/**
 * Defines custom serialization handler class. The handler class has to conform to RFJSONSerializationHandling protocol for JSON serialization.
 */
@interface RFSerializationCustomHandler : NSObject

/**
 * Defines path to object that custom serialization handler will receive. It can be property of class, in case it was defined for class, or it can be key in dictionary, in case it was defined for property with NSDictionary type.
 */
@property (nonatomic, strong) NSString *key;

/**
 * Defines class that responsible for serialization and deserialization back part of object. Must conform RFJSONSerializationHandling.
 */
@property (nonatomic, strong) Class handlerClass;

/**
 *  If set, this block will be executed with raw (straight after NSJSONSerialization decoding) value. The block should return value that will be used as output value for final object. Works for properties only.
 */
@property (nonatomic, copy) RFSerializationValuePreprocessor decodingPreprocessor;

/**
 *  If set, this block will be executed with raw (from appropriate property) value. The block should return value that will be used as part of output string. Works for properties only.
 */
@property (nonatomic, copy) RFSerializationValuePreprocessor encodingPreprocessor;

@end
