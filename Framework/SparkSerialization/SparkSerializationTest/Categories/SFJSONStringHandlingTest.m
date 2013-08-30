//
//  SFJSONStringHandlingTest.m
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


#import "SFJSONStringHandlingTest.h"
#import "NSJSONSerialization+JSONStringHandling.h"

@implementation SFJSONStringHandlingTest

- (void)testJSONStringParsing {
    NSString *jsonString = @"{ \"string\" : \"value1\", \"array\" : [ 1, 2, 3], \"dict\" : { \"string\" : \"value2\" }}";
    NSError *error;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithString:jsonString options:NSJSONReadingAllowFragments error:&error];
    STAssertTrue([jsonDict[@"string"] isEqualToString:@"value1"], @"Assertion: string is available in the dictionary with the correct value.");
    STAssertTrue([jsonDict[@"array"] isKindOfClass:[NSArray class]] && [jsonDict[@"array"] count] == 3, @"Assertion: array is present in json with 3 elements.");
    STAssertTrue([jsonDict[@"dict"] isKindOfClass:[NSDictionary class]] && [jsonDict[@"dict"][@"string"] isEqualToString:@"value2"], @"Assertion: dictionary is present in json with a single pair.");
}

@end
