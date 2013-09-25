//
//  SFODataPredicate.h
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

#import <Foundation/Foundation.h>

@class SFODataExpression;

typedef NS_ENUM(NSUInteger, SFODataPredicateOperatorType) {
    SFNotSpecifiedODataPredicateOperatorType,
    // Logical Operators
    SFEqualToODataPredicateOperatorType,
    SFNotEqualToODataPredicateOperatorType,
    SFGreaterThanODataPredicateOperatorType,
    SFGreaterThanOrEqualToODataPredicateOperatorType,
    SFLessThanODataPredicateOperatorType,
    SFLessThanOrEqualToODataPredicateOperatorType,
    SFLogicalAndODataPredicateOperatorType,
    SFLogicalOrODataPredicateOperatorType,
    SFLogicalNegationODataPredicateOperatorType,
    // Arithmetic Operators
    SFAdditionODataPredicateOperatorType,
    SFSubstractionODataPredicateOperatorType,
    SFMultiplicationODataPredicateOperatorType,
    SFDivisionODataPredicateOperatorType,
    SFModuloODataPredicateOperatorType,
};

@interface SFODataPredicate : NSObject

/**
 * Left expression in case of two expression predicate or the one expression if operation does not need second one.
 */
@property (nonatomic, strong) SFODataExpression *leftExpression;
/**
 * Right expression to operate with specified operation
 */
@property (nonatomic, strong) SFODataExpression *rightExpression;
/**
 * Operation type that defines operation.
 */
@property (nonatomic, assign) SFODataPredicateOperatorType type;

/**
 * Filter string that will return as predicate query.
 */
@property (nonatomic, strong) NSString *filter;

/**
 * Initializes predicate with two expressions and operator between them.
 * @param leftExpression The left expression of operation.
 * @param rightExpression The right expression of operation.
 * @param type The type of operation between expressions.
 * @return Initialized predicate.
 */
- (id)initWithLeftExpression:(SFODataExpression *)leftExpression rightExpression:(SFODataExpression *)rightExpression type:(SFODataPredicateOperatorType)type;

/**
 * Initializes predicate with expression and operator.
 * @param expression The expression for operate with.
 * @param type The type of operation that will be performed on expression.
 * @return Initialized predicate.
 */
- (id)initWithExpression:(SFODataExpression *)expression type:(SFODataPredicateOperatorType)type;

/**
 * Initializes predicate with filter string without any objects.
 * @param filterString The filter string that will be returned in as predicate generated query.
 * @return Initialized predicate.
 */
- (id)initWithFilterString:(NSString *)filterString;

/**
 * Returns expression that equals this predicate.
 */
- (SFODataExpression *)expression;

@end
