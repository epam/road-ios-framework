//
//  RFODataFetchRequest.h
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

#import "RFODataPrioritizedPredicate.h"
#import "RFODataExpression.h"
#import "NSSortDescriptor+RFOData.h"
#import "RFWebServiceURLBuilderParameter.h"

@class RFODataPredicate;

RF_ATTRIBUTE(RFWebServiceURLBuilderParameter)
@interface RFODataFetchRequest : NSObject

- (id)initWithEntityName:(NSString *)entityName;
- (id)initWithEntityName:(NSString *)entityName predicate:(RFODataPredicate *)predicate;
- (id)initWithEntityName:(NSString *)entityName predicate:(RFODataPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

/**
 * Adds to request indication that specified entity have to be included inline in response.
 @param entityName The entity with specified entity name will be included inline in response.
 */
- (void)expandWithEntity:(NSString *)entityName;
/**
 * Adds to request indication that specified entities have to be included inline in response. Entity names have to follow in specific order (from requested order to embeded entities).
 */
- (void)expandWithMultiLevelEntities:(NSArray *)entityNames;

/**
 * Name of resource you want to request from server.
 */
@property (nonatomic, strong) NSString *entityName;

/**
 * Number of first records that will be fetch from server.
 */
@property (nonatomic, assign) NSInteger fetchLimit;

/**
 * Number of records that will be skipped. First record you will get will be (fetchOffset + 1).
 */
@property (nonatomic, assign) NSInteger fetchOffset;

/**
 * The sort descriptor that indicate which order you want to get.
 */
@property (nonatomic, strong) NSMutableArray *sortDescriptors;

/**
 * The filtration option that will be apply to all record.
 */
@property (nonatomic, strong) RFODataPredicate *predicate;

/**
 * Array of entity names that will be included inline in response.
 */
@property (nonatomic, strong) NSMutableArray *expandEntities;

/**
 * Method generates query string according specified parameters
 */
- (NSString *)generateQueryString;

@end
