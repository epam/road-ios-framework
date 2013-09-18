//
//  NSArray+SFEmptyArrayChecks.h
//  SparkCore
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


/**
 Category to return array elements or nil, in case the specified index does not contain array element (out of range, or the array is empty).
 */
@interface NSArray (SFEmptyArrayChecks)

/**
 Returns the last object of a non-empty array or nil, if the array was empty.
 */
- (id)SF_lastElementIfNotEmpty;

/**
 Returns the elements specified by the index or nil, if the index is out of range for the array.
 @param index The index for which the element should be returned.
 @result The element at index or nil, if the index was out of range, or the array was empty.
 */
- (id)SF_elementAtIndexIfInRange:(NSUInteger)index;

/**
 Queries the array for an element what matches the predicate block specified and returns the first if found or nil, if none of the elements passed the test.
 @param evaluationBlock The predicate block.
 @result The first element passing the test or nil, if none of the elements passed the test.
 */
- (id)SF_elementWithPredicateBlock:(BOOL (^)(id evaluatedObject))evaluationBlock;

@end
