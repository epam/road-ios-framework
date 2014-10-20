//
//  RFDateTestClass.h
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


#import "RFSerializableDate.h"
#import "RFSerializable.h"


RF_ATTRIBUTE(RFSerializable)
@interface RFDateTestClass : NSObject

RF_ATTRIBUTE(RFSerializableDate, unixTimestamp = YES)
@property (nonatomic, strong) NSDate *unixTimestamp;

RF_ATTRIBUTE(RFSerializableDate, unixTimestamp = YES, unixTimestampMultiplier = 1)
@property (nonatomic, strong) NSDate *unixTimestampWithMultiplier;

RF_ATTRIBUTE(RFSerializableDate, format = @"yyyy/MM/dd HH:mm:ss Z")
@property (nonatomic, strong) NSDate *dateWithFormat;

RF_ATTRIBUTE(RFSerializableDate, encodingFormat = @"yyyy/MM/dd HH:mm:ss Z", decodingFormat = @"yyyy.MM.dd HH:mm:ss Z")
@property (nonatomic, strong) NSDate *dateWithEncodeDecodeFormat;

RF_ATTRIBUTE(RFSerializableDate, format = @"yyyy/MM/dd HH:mm:ss Z", decodingFormat = @"yyyy.MM.dd HH:mm:ss Z")
@property (nonatomic, strong) NSDate *dateWithDecodeFormatPriority;

RF_ATTRIBUTE(RFSerializableDate, encodingFormat = @"yyyy/MM/dd HH:mm:ss Z", format = @"yyyy.MM.dd HH:mm:ss Z")
@property (nonatomic, strong) NSDate *dateWithEncodeFormatPriority;

RF_ATTRIBUTE(RFSerializableDate, format = @"%Y/%m/%d %H:%M:%S %z")
@property (nonatomic, strong) NSDate *dateWithCFormat;

RF_ATTRIBUTE(RFSerializableDate, encodingFormat = @"%Y/%m/%d %H:%M:%S %z", decodingFormat = @"%Y.%m.%d %H:%M:%S %z")
@property (nonatomic, strong) NSDate *dateWithCEncodeDecodeFormat;

RF_ATTRIBUTE(RFSerializableDate, format = @"%Y/%m/%d %H:%M:%S %z", decodingFormat = @"%Y.%m.%d %H:%M:%S %z")
@property (nonatomic, strong) NSDate *dateWithCDecodeFormatPriority;

RF_ATTRIBUTE(RFSerializableDate, encodingFormat = @"%Y/%m/%d %H:%M:%S %z", format = @"%Y.%m.%d %H:%M:%S %z")
@property (nonatomic, strong) NSDate *dateWithCEncodeFormatPriority;

+ (id)testObject;
+ (NSString *)testObjectStringRepresentation;
+ (NSString *)testDeserialisationString;

@end
