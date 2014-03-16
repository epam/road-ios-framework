//
//  RFCustomJSONSerializationHandlingTest.m
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

#import <SenTestingKit/SenTestingKit.h>
#import "RFAttributedCoder.h"
#import "RFAttributedDecoder.h"
#import "RFJSONCustomSerializationHandler.h"
#import "RFJSONCustomClassHandlerEntity.h"
#import "RFJSONCustomClassPropertyHandlerEntity.h"
#import "RFJSONCustomPropertyHandlerEntity.h"
#import "RFJSONCustomPropertyKeyHandlerEntity.h"

@interface RFCustomJSONSerializationHandlingTest : SenTestCase

@end


@implementation RFCustomJSONSerializationHandlingTest

- (void)testClassCustomSerializationHandler {
    NSString *encodedObject = [RFAttributedCoder encodeRootObject:[RFJSONCustomClassHandlerEntity sampleObject]];
    NSString *stringForSampleObject = @"\"Success Encoding\"";
    STAssertTrue([stringForSampleObject isEqualToString:encodedObject], @"JSON custom serialization handling for class failed! Result of encoding is undefined!");
}

- (void)testClassCustomDeserializationHandler {
    NSError *fileError;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"DeserializationCustomHandlingTest" ofType:@"json"] encoding:NSUTF8StringEncoding error:&fileError];
    STAssertNil(fileError, @"File for deserialization was not loaded properly");
    NSString *decodedObject = [RFAttributedDecoder decodeJSONString:jsonString withRootClassNamed:NSStringFromClass([RFJSONCustomClassHandlerEntity class])];
    NSString *stringForSampleObject = @"Success Decoding";
    STAssertTrue([stringForSampleObject isEqualToString:decodedObject], @"JSON custom deserialization handling for class failed! Result of decoding is undefined!");
}

- (void)testClassPropertyCustomSerializationHandler {
    NSString *encodedObject = [RFAttributedCoder encodeRootObject:[RFJSONCustomClassPropertyHandlerEntity sampleObject]];
    NSString *stringForSampleObject = @"{\n"
                                        "  \"string1\" : \"Success Encoding\",\n"
                                        "  \"RFSerializedObjectClassName\" : \"RFJSONCustomClassPropertyHandlerEntity\"\n"
                                        "}";
    STAssertTrue([stringForSampleObject isEqualToString:encodedObject], @"JSON custom serialization handling for class property failed! Result of encoding is undefined!");
}

- (void)testClassPropertyCustomDeserializationHandler {
    NSError *fileError;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"DeserializationCustomHandlingTest" ofType:@"json"] encoding:NSUTF8StringEncoding error:&fileError];
    STAssertNil(fileError, @"File for deserialization was not loaded properly");
    NSString *decodedObject = [RFAttributedDecoder decodeJSONString:jsonString withRootClassNamed:NSStringFromClass([RFJSONCustomClassPropertyHandlerEntity class])];
    NSString *deserializationTestObject = [RFJSONCustomClassPropertyHandlerEntity deserializationTestObject];
    STAssertTrue([deserializationTestObject isEqual:decodedObject], @"JSON custom deserialization handling for class property failed! Result of decoding is undefined!");
}

- (void)testPropertyCustomSerializationHandler {
    NSString *encodedObject = [RFAttributedCoder encodeRootObject:[RFJSONCustomPropertyHandlerEntity sampleObject]];
    NSString *stringForSampleObject = @"{\n"
                                        "  \"string1\" : \"Success Encoding\",\n"
                                        "  \"RFSerializedObjectClassName\" : \"RFJSONCustomPropertyHandlerEntity\"\n"
                                        "}";
    STAssertTrue([stringForSampleObject isEqualToString:encodedObject], @"JSON custom serialization handling for property failed! Result of encoding is undefined!");
}

- (void)testPropertyCustomDeserializationHandler {
    NSError *fileError;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"DeserializationCustomHandlingTest" ofType:@"json"] encoding:NSUTF8StringEncoding error:&fileError];
    STAssertNil(fileError, @"File for deserialization was not loaded properly");
    NSString *decodedObject = [RFAttributedDecoder decodeJSONString:jsonString withRootClassNamed:NSStringFromClass([RFJSONCustomPropertyHandlerEntity class])];
    NSString *deserializationTestObject = [RFJSONCustomPropertyHandlerEntity deserializationTestObject];
    STAssertTrue([deserializationTestObject isEqual:decodedObject], @"JSON custom deserialization handling for property failed! Result of decoding is undefined!");
}

- (void)testPropertyKeyCustomSerializationHandler {
    NSString *encodedObject = [RFAttributedCoder encodeRootObject:[RFJSONCustomPropertyKeyHandlerEntity sampleObject]];
    NSString *stringForSampleObject = @"{\n"
                                        "  \"subDictionary\" : {\n"
                                        "    \"string1\" : \"Success Encoding\"\n"
                                        "  },\n"
                                        "  \"RFSerializedObjectClassName\" : \"RFJSONCustomPropertyKeyHandlerEntity\"\n"
                                        "}";
    STAssertTrue([stringForSampleObject isEqualToString:encodedObject], @"JSON custom serialization handling for key in property failed! Result of encoding is undefined!");
}

- (void)testPropertyKeyCustomDeserializationHandler {
    NSError *fileError;
    NSString *jsonString = [[NSString alloc] initWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"DeserializationCustomPropertyKeyHandlingTest" ofType:@"json"] encoding:NSUTF8StringEncoding error:&fileError];
    STAssertNil(fileError, @"File for deserialization was not loaded properly");
    NSString *decodedObject = [RFAttributedDecoder decodeJSONString:jsonString withRootClassNamed:NSStringFromClass([RFJSONCustomPropertyKeyHandlerEntity class])];
    NSString *deserializationTestObject = [RFJSONCustomPropertyKeyHandlerEntity deserializationTestObject];
    STAssertTrue([deserializationTestObject isEqual:decodedObject], @"JSON custom deserialization handling for property failed! Result of decoding is undefined!");
}

@end
