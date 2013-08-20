//
//  ACLoggerFilter.h
//  APPA-Core
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

@class ACLogMessage;

/**
 Log filter baseclass to define the way how log messages are filtered. Instances of this class can be injected into active log writers to apply the specified filtering behavior.
 */
@interface ACLogFilter : NSObject

/**
 Initializes the filter with a predicate format string and optional arguments to evaluate.
 @param format The format string.
 @param ... The optional variable argument list for objects to be substituted into the format specification.
 */
- (id)initWithPredicateFormat:(NSString *)format, ... NS_REQUIRES_NIL_TERMINATION;

/**
 Initializes the filter with a block that evaluates the message and returns YES/NO for the message passing the filter.
 @param block The filter block to decide whether a message has passed the filter.
 */
- (id)initWithFilterBlock:(BOOL (^)(ACLogMessage *message))block;

/**
 Returns whether a message has passed the filter.
 @param message A log message to be tested.
 */
- (BOOL)isMessagePassingFilter:(ACLogMessage *)message;


#pragma mark - Convenience initializers for special filters


/**
 Returns a special debug filter that only allows debug messages to pass.
 */
+ (ACLogFilter *)debugFilter;

/**
 Returns a special filter that only allows warnings or errors to pass.
 */
+ (ACLogFilter *)warningFilter;

/**
 Returns a special filter that only allows info logs to pass.
 */
+ (ACLogFilter *)infoFilter;

@end
