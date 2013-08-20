//
//  ACLoggerFilter.m
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


#import "ACLogFilter.h"
#import "ACLogMessage.h"

/**
 The ACLoggerFilter is a filer base class for the ACLogger tool.
 */
@implementation ACLogFilter {
    NSPredicate *filterPredicate;
    BOOL (^passTestBlock)(ACLogMessage *);
}

- (id)initWithPredicateFormat:(NSString *)format, ... {
    
    self = [super init];
    
    if (self) {
        
        NSMutableArray *args = [[NSMutableArray alloc] init];
        va_list ap;
        va_start(ap, format);
        for (NSString *arg = format; arg != nil; arg = va_arg(ap, NSString *)) {
            
            if ([arg isEqualToString:format] == NO) {
                [args addObject:arg];
            }
        }
        va_end(ap);
        
        filterPredicate = [NSPredicate predicateWithFormat:format argumentArray:args];
    }
    
    return self;
}

- (id)initWithFilterBlock:(BOOL (^)(ACLogMessage *message))block {

    self = [super init];
    
    if (self) {
        
        passTestBlock = [block copy];
    }
    
    return self;
}

- (BOOL)isMessagePassingFilter:(ACLogMessage *)message {
    
    BOOL passing = NO;
    
    if (passTestBlock) {
        
        passing = passTestBlock(message);
    }
    
    if (filterPredicate) {
        
        passing = [filterPredicate evaluateWithObject:message];
    }
    
    return passing;
}


#pragma mark - Static constructors


+ (ACLogFilter *)debugFilter {
    
    ACLogFilter *filter = [[ACLogFilter alloc] initWithFilterBlock:^BOOL(ACLogMessage *message) {
        
        return ([message logLevel] == ACLogLevelDebug);
    }];
    
    return filter;
}

+ (ACLogFilter *)warningFilter {

    ACLogFilter *filter = [[ACLogFilter alloc] initWithFilterBlock:^BOOL(ACLogMessage *message) {
        
        return ([message logLevel] == ACLogLevelError || [message logLevel] == ACLogLevelWarning);
    }];
    
    return filter;
}

+ (ACLogFilter *)infoFilter {
    
    ACLogFilter *filter = [[ACLogFilter alloc] initWithFilterBlock:^BOOL(ACLogMessage *message) {
        
        return ([message logLevel] == ACLogLevelInfo);
    }];
    
    return filter;
}

@end
