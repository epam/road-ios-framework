//
//  SFObservationTest.m
//  ROADObservation
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

#import "SFObservationTest.h"
#import "SFObserver.h"

@implementation SFObservationTest {
    SFObserver *observer;
    NSString *old;
    NSString *new;
}

- (void)setUp {
    observer = [[SFObserver alloc] initWithTarget:self keyPath:@"string" handler:^(id oldValue, id newValue) {
        old = [oldValue copy];
        new = [newValue copy];
    }];
}

- (void)tearDown {
    observer = nil;
}

- (void)testObservation {
    old = nil;
    new = nil;
    
    self.string = @"value";
    STAssertTrue([new isEqualToString:@"value"], @"Assertion: observation did execute block. Result: %@", new);
    
    self.string = @"new value";
    STAssertTrue([old isEqualToString:@"value"], @"Assertion: observation did conserv old value. Result: %@", old);
    STAssertTrue([new isEqualToString:@"new value"], @"Assertion: observation did update to new value. Result: %@", new);
}

- (void)testTargetChange {
    old = nil;
    new = nil;
    
    self.string = @"value";
    observer.observationTarget = self;
    self.string = @"new value";
    
    STAssertTrue([new isEqualToString:@"new value"] && [old isEqualToString:@"value"], @"Assertion: observer did update to new target and did update value change.");
}

@end
