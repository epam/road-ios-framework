//
//  RFWebServiceBasicURLBuilder.m
//  ROADWebService
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

#import <ROAD/ROADCore.h>

#import "RFWebServiceBasicURLBuilder.h"
#import "RFWebServiceURLBuilder.h"

NSString * const RFApiCallTemplateEscapeString = @"%%";

@implementation RFWebServiceBasicURLBuilder

+ (NSString *)urlTemplateEscapeString {
    return RFApiCallTemplateEscapeString;
}


+ (NSURL *)urlFromTemplate:(NSString * const)urlTemplate withServiceRoot:(NSString* const)serviceRoot values:(NSDictionary * const)values urlBuilderAttribute:(RFWebServiceURLBuilder *)urlBuilderAttribute {
    NSAssert([serviceRoot length] > 0, @"Assertion: Web service URL is empty");
    
    NSMutableString * const root = [serviceRoot mutableCopy];
    NSMutableString * const suffix = urlTemplate.length > 0 ? [urlTemplate mutableCopy] : [@"" mutableCopy];
    [root RF_formatStringUsingValues:values withEscape:[self urlTemplateEscapeString]];
    [suffix RF_formatStringUsingValues:values withEscape:[self urlTemplateEscapeString]];
    
    NSString *urlParameterStringPattern = [NSString stringWithFormat:@"&.+?=%@.+?%@", RFApiCallTemplateEscapeString, RFApiCallTemplateEscapeString];
    
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:urlParameterStringPattern options:0 error:nil];
    [regexp replaceMatchesInString:suffix options:0 range:NSMakeRange(0, [suffix length]) withTemplate:@""];
    
    urlParameterStringPattern = [NSString stringWithFormat:@"\\?.+?=%@.+?%@&", RFApiCallTemplateEscapeString, RFApiCallTemplateEscapeString];
    regexp = [NSRegularExpression regularExpressionWithPattern:urlParameterStringPattern options:0 error:nil];
    [regexp replaceMatchesInString:suffix options:0 range:NSMakeRange(0, [suffix length]) withTemplate:@"?"];
    
    NSString *serverURLString = [NSString stringWithFormat:@"%@%@", root, suffix];

    NSURL *url = [NSURL URLWithString:[self escapeString:serverURLString withUrlBuilderAttribute:urlBuilderAttribute]];
    
    return url;
}

+ (NSString *)escapeString:(NSString *)string withUrlBuilderAttribute:(RFWebServiceURLBuilder *)urlBuilderAttribute {
    NSString *escapedURLString;
    if (urlBuilderAttribute.allowedCharset) {
        escapedURLString = [string stringByAddingPercentEncodingWithAllowedCharacters:urlBuilderAttribute.allowedCharset];
    }
    else if (urlBuilderAttribute.encoding) {
        escapedURLString = [string stringByAddingPercentEscapesUsingEncoding:urlBuilderAttribute.encoding];
    }
    else {
        escapedURLString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }

    return escapedURLString;
}


@end
