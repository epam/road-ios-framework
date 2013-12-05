//
//  RFDownloader+FakeRequest.m
//  ROADWebService
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "RFDownloader+FakeRequest.h"

@implementation RFDownloader (FakeRequest)

- (void)fakeStart {
    NSMethodSignature * downloaderFinishMethodSignature = [RFDownloader
                                                           instanceMethodSignatureForSelector:@selector(downloaderFinishedWithResult:response:error:)];
    NSInvocation * downloaderFinishMethodInvocation = [NSInvocation
                                   invocationWithMethodSignature:downloaderFinishMethodSignature];
    [downloaderFinishMethodInvocation setTarget:self];
    [downloaderFinishMethodInvocation setSelector:@selector(downloaderFinishedWithResult:response:error:)];

    NSData *resultData = [[NSData alloc] init];
    NSURLResponse *response;
    NSError *error;
    
    if ([[[self.request URL] absoluteString] isEqualToString:@"http://test.multipart.data"]) {
        if ([self checkMultipartData]) {
            response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{}];
        }
        else {
            response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:400 HTTPVersion:@"HTTP/1.1" headerFields:@{}];
        }
    }
    else if ([[[self.request URL] absoluteString] isEqualToString:@"http://test.method.without.blocks"]) {
        response = [[NSHTTPURLResponse alloc] initWithURL:self.request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:@{}];
    }
    else {
        // Not processed URL
        [self fakeStart];
        return;
    }
    
    [downloaderFinishMethodInvocation setArgument:&resultData atIndex:2];
    [downloaderFinishMethodInvocation setArgument:&response atIndex:3];
    [downloaderFinishMethodInvocation setArgument:&error atIndex:4];
    
    [downloaderFinishMethodInvocation invoke];
}

- (BOOL)checkMultipartData {
    NSString *result = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
    NSError *error = NULL;
    NSString *contentType = [self.request.allHTTPHeaderFields objectForKey:@"Content-Type"];
    NSRange rangeBoundary = [contentType rangeOfString:@"boundary="];
    NSRange rangeWithoutBoundary = NSMakeRange(0, rangeBoundary.location + rangeBoundary.length);
    NSString *boundary = [contentType stringByReplacingCharactersInRange:rangeWithoutBoundary withString:@""];
    NSString *fullBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n", boundary];
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:fullBoundary options:NSRegularExpressionCaseInsensitive error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:result options:0 range:NSMakeRange(0, [result length])];
    
    BOOL isOkMultipartData = NO;
    // Number of boundaries have to be odd or for one attachment it has to be 2
    if (numberOfMatches >= 2
        && (numberOfMatches == 2
            || numberOfMatches % 2 == 1)) {
        isOkMultipartData = YES;
    }
    else {
        NSLog(@"Number of matches exceed the limit - %d", numberOfMatches);
        NSLog(@"result - %@", result);
        NSLog(@"%@", self.request.allHTTPHeaderFields);
    }
    
    return isOkMultipartData;
}

@end
