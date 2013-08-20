//
//  NLChain.m
//  NetLog-Listener
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


#import "NLChain.h"

@implementation NLChain {
    
    NSMutableArray *collection;
    NLChain *childContainer;
}

@synthesize containerIdentifier;

- (id)initWithIdentifier:(NSString *)anIdentifier {
    
    self = [super init];
    
    if (self) {
        
        collection = [[NSMutableArray alloc] init];
        containerIdentifier = [anIdentifier copy];
    }
    
    return self;
}

- (void)addObject:(id)object forIdentifier:(NSString *)anIdentifier {
    
    if ([anIdentifier isEqualToString:containerIdentifier]) {
        [collection addObject:object];
    }
    else {
        if (childContainer == nil) {
            
            childContainer = [self childContainerWithIdentifier:anIdentifier];
        }
        [childContainer addObject:object forIdentifier:anIdentifier];
    }
}

- (NLChain *)childContainerWithIdentifier:(NSString *)anIdentifier {
    
    childContainer = [[NLChain alloc] initWithIdentifier:anIdentifier];
    return childContainer;
}

- (NSArray *)objectsForIdentifier:(NSString *)anIdentifier {
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    
    if ([anIdentifier isEqualToString:containerIdentifier]) {
        
        if (childContainer) {
            [result addObjectsFromArray:[childContainer objectsForIdentifier:childContainer.containerIdentifier]];            
        }
        [result addObjectsFromArray:collection];
    }
    else if (childContainer) {
        [result addObjectsFromArray:[childContainer objectsForIdentifier:anIdentifier]];
    }
    
    return result;
}

- (void)removeAllObjectsForIdentifier:(NSString *)anIdentifier {
    
    if ([anIdentifier isEqualToString:containerIdentifier]) {
        
        [childContainer removeAllObjectsForIdentifier:childContainer.containerIdentifier];
        [collection removeAllObjects];
    }
    else {
        [childContainer removeAllObjectsForIdentifier:anIdentifier];
    }
}

#pragma mark - Class methods

+ (NSArray *)chainHierarchyForIdentifiers:(NSArray *)arrayOfIds {
    
    NSString *anIdentifier = [arrayOfIds objectAtIndex:0];
    NSMutableArray *hierarchy = [[NSMutableArray alloc] init];
    
    NLChain *root = [[NLChain alloc] initWithIdentifier:anIdentifier];
    [hierarchy addObject:root];
    
    for (int index = 1; index < [arrayOfIds count]; index++) {
        
        anIdentifier = [arrayOfIds objectAtIndex:index];
        NLChain *aLink = [hierarchy objectAtIndex:index - 1];
        NLChain *newChild = [aLink childContainerWithIdentifier:anIdentifier];
        [hierarchy addObject:newChild];
    }
    
    return [NSArray arrayWithArray:hierarchy];
}

@end
