//
//  RFODataWebServiceURLBuilder.m
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

#import "RFODataWebServiceURLBuilder.h"
#import <ROAD/ROADCore.h>

#import "RFODataFetchRequest.h"

@implementation RFODataWebServiceURLBuilder

+ (NSURL *)urlFromTemplate:(NSString *const)urlTemplate withServiceRoot:(NSString *const)serviceRoot values:(NSDictionary *const)values {
    NSURL *url = [super urlFromTemplate:urlTemplate withServiceRoot:serviceRoot values:values];

    NSArray *valuesArray = [values allValues];
    for (int index = 0; index < [values count]; index++) {
        id value = valuesArray[index];
        
        if ([value isKindOfClass:[RFODataFetchRequest class]]) {
            RFODataFetchRequest *fetchRequest = value;
            url = [url URLByAppendingPathComponent:fetchRequest.entityName isDirectory:NO];
            
            NSString *queryString = [fetchRequest generateQueryString];
            
            // If fetch request has some queries, it will add it
            if (queryString.length) {
                NSString *separatorString = url.query ? @"&" : @"?";
                // In case query was added already, we will add new parameters:
                // entity name as last path component and new parameters in query string
                NSString *urlAddition = [NSString stringWithFormat:@"%@%@", separatorString, queryString];
                urlAddition = [urlAddition stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                
                NSString *urlString = [NSString stringWithFormat:@"%@%@", url.absoluteString, urlAddition];
                url = [NSURL URLWithString:urlString];
            }

            break;
        }
    }
    
    return url;
}

@end
