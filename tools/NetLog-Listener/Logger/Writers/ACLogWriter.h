//
//  ACLoggerWriter.h
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
#import "ACLogMessage.h"
#import "ACLogFilter.h"
#import "ACLogFormatter.h"

/**
 Abstract base class of all log writers, contains all the methods and the necessary implementations to make this class and its subclass function as log writers.
 */
@interface ACLogWriter : NSObject

/**
 Adds a filter to the filter list of this writer.
 @param aFilter The filter to be added.
 */
- (void)addFilter:(ACLogFilter *)aFilter;

/**
 Removes a filter from the filter list of this writer.
 @param aFilter The filter to be removed.
 */
- (void)removeFilter:(ACLogFilter *)aFilter;

/**
 Logs a message to this writer.
 @param aMessage The message to be logged.
 */
- (void)logMessage:(ACLogMessage *)aMessage;

/**
 Returns the formatted message from the log message object.
 @param aMessage The log message to format.
 */
- (NSString *)formattedMessage:(ACLogMessage *)aMessage;

/**
 The log formatter property for the specific writer. Optional, in its absence, the bare log message will be logged.
 */
@property (retain, nonatomic) ACLogFormatter *formatter;

@end
