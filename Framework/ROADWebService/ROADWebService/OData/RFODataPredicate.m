//
//  RFODataPredicate.m
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

#import "RFODataPredicate.h"

#import "RFODataExpression.h"

@implementation RFODataPredicate

static NSArray * kRFPredicateOperatorTypes;

#pragma mark  - Initialization

- (id)initWithLeftExpression:(RFODataExpression *)leftExpression rightExpression:(RFODataExpression *)rightExpression type:(RFODataPredicateOperatorType)type {
    self = [super init];
    
    if (self) {
        _leftExpression = leftExpression;
        _rightExpression = rightExpression;
        _type = type;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            kRFPredicateOperatorTypes = @[@"",
                                           @"eq",
                                           @"ne",
                                           @"gt",
                                           @"ge",
                                           @"lt",
                                           @"le",
                                           @"and",
                                           @"or",
                                           @"not",
                                           @"add",
                                           @"sub",
                                           @"mul",
                                           @"div",
                                           @"mod"];
        });
    }
    
    return self;
}

- (id)initWithExpression:(RFODataExpression *)expression type:(RFODataPredicateOperatorType)type {
    self = [self initWithLeftExpression:expression rightExpression:nil type:type];
    
    return self;
}

- (id)initWithFilterString:(NSString *)filterString {
    self = [self initWithLeftExpression:nil rightExpression:nil type:RFNotSpecifiedODataPredicateOperatorType];
    
    if (self) {
        _filter = filterString;
    }
    
    return self;
}

- (RFODataExpression *)expression {
    return [[RFODataExpression alloc] initWithPredicate:self];
}


#pragma mark - Building description


- (NSString *)filter {
    return [self description];
}

- (NSString *)description {
    // If filter specified directly - return filter string
    if (_filter) {
        return _filter;
    }
    
    NSString *description;
    
    if (_type == RFNotEqualToODataPredicateOperatorType) {
        description = [NSString stringWithFormat:@"%@ %@", kRFPredicateOperatorTypes[_type], _leftExpression];
    }
    else {
        description = [NSString stringWithFormat:@"%@ %@ %@", _leftExpression, kRFPredicateOperatorTypes[_type], _rightExpression];
    }
    
    return description;
}

@end
