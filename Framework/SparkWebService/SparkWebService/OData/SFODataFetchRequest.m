//
//  SFODataFetchRequest.m
//  SparkWebService
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

#import "SFODataFetchRequest.h"

@implementation SFODataFetchRequest

#pragma mark - Initialization

- (id)initWithEntityName:(NSString *)entityName predicate:(SFODataPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors {
    self = [super init];

    if (self) {
        _entityName = entityName;
        _predicate = predicate;
        _sortDescriptors = [sortDescriptors mutableCopy] ? : [[NSMutableArray alloc] init];
        _expandEntities = [[NSMutableArray alloc] init];
    }

    return self;
}

- (id)initWithEntityName:(NSString *)entityName predicate:(SFODataPredicate *)predicate {
    self = [self initWithEntityName:entityName predicate:predicate sortDescriptors:nil];
    
    return self;
}

- (id)initWithEntityName:(NSString *)entityName {
    self = [self initWithEntityName:entityName predicate:nil sortDescriptors:nil];
    
    return self;
}


#pragma mark - Combining request

- (void)expandWithEntity:(NSString *)entityName {
    [_expandEntities addObject:@[entityName]];
}

- (void)expandWithMultiLevelEntities:(NSArray *)entityNames {
    [_expandEntities addObject:entityNames];
}

- (NSString *)generateQueryString {
    NSMutableString *queryString = [[NSMutableString alloc] init];
    
    [self addTopOptionToQueryString:queryString];
    
    [self addSkipOptionToQueryString:queryString];
    
    [self addOrderByOptionToQueryString:queryString];
    
    [self addFilterOptionToQueryString:queryString];
    
    [self addExpandOptionToQueryString:queryString];
    
    return queryString;
}

     
#pragma mark - Query building
     
- (void)addTopOptionToQueryString:(NSMutableString *)queryString {
    if (_fetchLimit) {
        [self addAmpersandToQueryStringIfNecessary:queryString];
        [queryString appendFormat:@"$top=%d", _fetchLimit];
    }
}

- (void)addSkipOptionToQueryString:(NSMutableString *)queryString {
    if (_fetchOffset) {
        [self addAmpersandToQueryStringIfNecessary:queryString];
        [queryString appendFormat:@"$skip=%d", _fetchOffset];
    }
}

- (void)addOrderByOptionToQueryString:(NSMutableString *)queryString {
    if ([_sortDescriptors count] > 0) {
        [self addAmpersandToQueryStringIfNecessary:queryString];
        for (int index = 0; index < [_sortDescriptors count]; index++) {
            NSSortDescriptor *sortDescriptor = [_sortDescriptors objectAtIndex:index];
            NSString *direction = sortDescriptor.ascending ? @"asc" : @"desc";
            if (index == 0) {
                [queryString appendFormat:@"$orderby=%@ %@", sortDescriptor.key, direction];
            }
            else {
                [queryString appendFormat:@",%@ %@", sortDescriptor.key, direction];
            }
        }
    }
}

- (void)addFilterOptionToQueryString:(NSMutableString *)queryString {
    if (_predicate) {
        [self addAmpersandToQueryStringIfNecessary:queryString];
        [queryString appendFormat:@"$filter=%@", _predicate];
    }
}

- (void)addExpandOptionToQueryString:(NSMutableString *)queryString {
    if ([_expandEntities count] > 0) {
        [self addAmpersandToQueryStringIfNecessary:queryString];
        for (int indexOfExpandOption = 0; indexOfExpandOption < [_expandEntities count]; indexOfExpandOption++) {
            NSArray *expandOption = [_expandEntities objectAtIndex:indexOfExpandOption];
            if (indexOfExpandOption == 0) {
                [queryString appendString:@"$expand="];
            }
            else {
                [queryString appendString:@","];
            }

            for (int indexOfEntityName = 0; indexOfEntityName < [expandOption count]; indexOfEntityName++) {
                NSString *entityName = expandOption[indexOfEntityName];
                if (indexOfEntityName == 0) {
                    [queryString appendFormat:@"%@", entityName];
                }
                else {
                    [queryString appendFormat:@"/%@", entityName];
                }
            }
        }
    }
}

- (void)addAmpersandToQueryStringIfNecessary:(NSMutableString *)queryString {
    if ([queryString length] > 0) {
        [queryString appendString:@"&"];
    }
}

@end
