//
//  RFSerializableStringChecker.m
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


#import "RFSerializableStringChecker.h"
#import <XCTest/XCTest.h>


#define CHECK_AND_THROW_ERROR(check, error) if (check) { \
                                                return error; \
                                            } \


@implementation RFSerializableStringChecker

+ (NSString *)serializeAndCheckEqualityOfString:(NSString *)string withString:(NSString *)anotherString {
    NSError *error;
    NSDictionary *testDictionary = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    CHECK_AND_THROW_ERROR(error, @"Assertion: error while parsing test file");
    
    NSDictionary *resultDictionary = [NSJSONSerialization JSONObjectWithData:[anotherString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:&error];
    CHECK_AND_THROW_ERROR(error, @"Assertion: error while parsing test file");
    
    return [self checkDictionary:testDictionary withDictionary:resultDictionary];
}

+ (NSString *)checkDictionary:(NSDictionary *)dictionary withDictionary:(NSDictionary *)anotherDictionary {
    CHECK_AND_THROW_ERROR((![dictionary isKindOfClass:[NSDictionary class]]
                           || ![anotherDictionary isKindOfClass:[NSDictionary class]]), @"Values are not equal. Test data differ from result of encoding");
    CHECK_AND_THROW_ERROR([[dictionary allKeys] count] != [[anotherDictionary allKeys] count], @"Key count is not the same. Dictionaries is not equal");
    
    for (NSString *key in dictionary) {
        id obj = dictionary[key];
        id anotherObj = anotherDictionary[key];
        if ([key rangeOfString:@"date"].location == NSNotFound) {
            CHECK_AND_THROW_ERROR([self checkObject:obj withObject:anotherObj], @"Values are not equal. Dictionaries is not equal");
        }
        else { // Don't check dates for equality, because of difference in time zone
            CHECK_AND_THROW_ERROR(anotherObj == nil, @"Date value is nill. Dictionaries is not equal");
        }
    }
    
    return nil;
}

+ (NSString *)checkObject:(id)obj withObject:(id)anotherObj {
    if ([obj isKindOfClass:[NSDictionary class]]) { // Recursive check for dictionary value
        CHECK_AND_THROW_ERROR([self checkDictionary:obj withDictionary:anotherObj], @"Values are not equal. Test data differ from result of encoding");
    }
    else if ([obj isKindOfClass:[NSArray class]]) { // Loop check for arrays
        [self checkArray:obj withArray:anotherObj];
    }
    else {
        CHECK_AND_THROW_ERROR(![obj isEqual:anotherObj], @"Values are not equal. Test data differ from result of encoding");
    }
    
    return nil;
}

+ (NSString *)checkArray:(NSArray *)array withArray:(NSArray *)anotherArray {
    CHECK_AND_THROW_ERROR(![array isKindOfClass:[NSArray class]]
                          || ![anotherArray isKindOfClass:[NSArray class]], @"Values are not equal. Test data differ from result of encoding");
    for (int index = 0; index < [array count]; index++) {
        id objOfFirstArray = array[index];
        id objOfSecondArray = anotherArray[index];
        [self checkObject:objOfFirstArray withObject:objOfSecondArray];
    }
    
    return nil;
}

@end
