//
//  SFSerializationTestObject.h
//  SparkSerialization
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


#import <Foundation/Foundation.h>
#import "SFSerializable.h"
#import "SFSerializableDate.h"
#import "SFSerializableCollection.h"
#import "SFDerived.h"

SF_ATTRIBUTE(SFSerializable)
@interface SFSerializationTestObject : NSObject

@property (strong, nonatomic) NSString *string1;

SF_ATTRIBUTE(SFDerived)
@property (copy, nonatomic) NSString *string2;

@property (assign, nonatomic) BOOL boolean;

@property (strong, nonatomic) NSArray *strings;

SF_ATTRIBUTE(SFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z", encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z")
@property (strong, nonatomic) NSDate *date1;

SF_ATTRIBUTE(SFSerializableDate, format = @"MM.dd.yyyy HH:mm", decodingFormat = @"MM.dd.yyyy HH:mm:ss")
@property (strong, nonatomic) NSDate *date2;

SF_ATTRIBUTE(SFSerializableDate, unixTimestamp = YES)
@property (strong, nonatomic) NSDate *unixTimestamp;

@property (strong, nonatomic) SFSerializationTestObject *child;

SF_ATTRIBUTE(SFSerializableCollection, collectionClass = [SFSerializationTestObject class])
@property (strong, nonatomic) NSArray *subObjects;

SF_ATTRIBUTE(SFSerializableCollection, collectionClass = [SFSerializationTestObject class])
@property (strong, nonatomic) NSDictionary *subDictionary;

@property (nonatomic) int integer;

@property (nonatomic) NSNumber *number;

@end
