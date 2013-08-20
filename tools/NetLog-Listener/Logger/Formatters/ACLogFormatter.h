//
//  ACLogFormatter.h
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

typedef NSString * (^formatterBlock)(ACLogMessage *);

/**
 Represents a log formatter object capable of returning a well formatted string from the log message container.
 */
@interface ACLogFormatter : NSObject

/**
 Returns the formatted string from the message.
 @param message The log messae object to format.
 */
- (NSString *)formatMessage:(ACLogMessage *)message;

/**
 Adds a formatter block to a given type of log message to be used.
 @param messageType The message type to format with the supplied block. The block is copied and retained for the lifetime of the formatter or until the formatter block is not removed by -removeFormatForType. Thus special considerations should be taken which objects should be captured by the block. Ideally none.
 @param formatBlock The block containing the code to format the message.
 */
- (void)addFormatForType:(NSString *)messageType usingBlock:(formatterBlock)formatBlock;

/**
 Removes a formatter block for a given type.
 @param messageType The message type the formatter should cease to format specially.
 */
- (void)removeFormatForType:(NSString *)messageType;

@end
