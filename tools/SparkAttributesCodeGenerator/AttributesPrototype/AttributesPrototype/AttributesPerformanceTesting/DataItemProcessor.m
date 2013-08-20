//
//  DataItemProcessor.m
//  AttributesPrototype
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

#import "DataItemProcessor.h"

@interface DataItemProcessor() {
    NSString* _spentTime;
}

@end

@implementation DataItemProcessor

@synthesize spentTime = _spentTime;

- (id)init
{
    self = [super init];
    if (self == nil) {
        return self;
    }
    
    _spentTime = nil;
    
    return self;
}


- (void)processDateItem:(DataItem *)dataItem {
    IncrementValueESDAttribute *incrementValueAttr = nil;
    
    NSArray *propertyAttributes = [[DataItem class] attributesForProperty:@"intProperty1" withType:[IncrementValueESDAttribute class]];
    
    if ([propertyAttributes count] == 1) {
        
        incrementValueAttr = [propertyAttributes lastObject];
        dataItem.intProperty1 += incrementValueAttr.intValue;
        
    } else {
        [NSException raise:NSInvalidArgumentException
                    format:@"Check properties"];
        
        return;
    }
    
    
    propertyAttributes = [[DataItem class] attributesForProperty:@"intProperty2" withType:[IncrementValueESDAttribute class]];
    
    if ([propertyAttributes count] == 1) {
        
        incrementValueAttr = [propertyAttributes lastObject];
        dataItem.intProperty2 += incrementValueAttr.intValue;
        
    } else {
        [NSException raise:NSInvalidArgumentException
                    format:@"Check properties"];
        
        return;
    }
    
    propertyAttributes = [[DataItem class] attributesForProperty:@"intProperty3" withType:[IncrementValueESDAttribute class]];
    
    if ([propertyAttributes count] == 1) {
        
        incrementValueAttr = [propertyAttributes lastObject];
        dataItem.intProperty3 += incrementValueAttr.intValue;
        
    } else {
        [NSException raise:NSInvalidArgumentException
                    format:@"Check properties"];
        
        return;
    }
}

- (void)processDateItems:(NSArray *)dataItems {
    if (dataItems == nil || [dataItems count] == 0) {
        _spentTime = nil;
        return;
    }
    
    NSDate *startDate = [NSDate date];
    
    for (DataItem *dataItem in dataItems) {
        [self processDateItem:dataItem];
    }
    
    NSDate *stopDate = [NSDate date];
    _spentTime = [NSString stringWithFormat:@"%f seconds", [stopDate timeIntervalSinceDate:startDate]];
}

@end
