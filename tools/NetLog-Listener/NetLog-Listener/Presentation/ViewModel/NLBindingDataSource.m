//
//  NLBindingDataSource.m
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


#import "NLBindingDataSource.h"

NSString * const kNLSelectedDeviceIdKeyPath = @"selectedDeviceId";
NSString * const kNLSelectedLogLevelKeyPath = @"selectedLogLevel";
NSString * const kNLSelectedLogMessagesKeyPath = @"selectedLogMessages";
NSString * const kNLDeviceNamesKeyPath = @"deviceNames";
NSString * const kDefaultSelectedLogLevel = @"-1000";

@implementation NLBindingDataSource {
    
    NSMutableDictionary *deviceNames;
}

@synthesize deviceNames;
@synthesize selectedDeviceId;
@synthesize selectedLogMessages;
@synthesize sortDescriptors;
@synthesize selectedLogLevel;
@synthesize paused;
@synthesize viewModel;

- (id)initWithModel:(id<NLViewModelling>)aModel {

    self = [super init];
    
    if (self) {
        
        self.viewModel = aModel;
        deviceNames = [NSMutableDictionary dictionary];
        [self addObserver:self forKeyPath:kNLSelectedDeviceIdKeyPath options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:kNLSelectedLogLevelKeyPath options:NSKeyValueObservingOptionNew context:nil];
        sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES]];
        selectedLogLevel = kDefaultSelectedLogLevel;
    }
    
    return self;
}

- (void)dealloc {
    
    [self removeObserver:self forKeyPath:kNLSelectedDeviceIdKeyPath];
    [self removeObserver:self forKeyPath:kNLSelectedLogLevelKeyPath];
}

// KVO callback method.
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    [self updateContent];
}

// Sorthand to conditionally send KVO messages.
- (void)willChangeValueForSelectedLogMessages {
    
    if (![self isPaused]) {
        
        [self willChangeValueForKey:kNLSelectedLogMessagesKeyPath];
    }
}

// Sorthand to conditionally send KVO messages.
- (void)didChangeValueForSelectedLogMessages {
    
    if (![self isPaused]) {
        
        [self didChangeValueForKey:kNLSelectedLogMessagesKeyPath];
    }
}

// Sends KVO messages and updates the available devices.
- (void)updateDeviceListWithId:(NSString *)uniqueId name:(NSString *)deviceName {
    
    [self willChangeValueForKey:kNLDeviceNamesKeyPath];
    [deviceNames setObject:deviceName forKey:uniqueId];
    [self didChangeValueForKey:kNLDeviceNamesKeyPath];
}

- (void)removeDevice:(NSString *)uniqueId {
    
    [self willChangeValueForKey:kNLDeviceNamesKeyPath];
    [deviceNames removeObjectForKey:uniqueId];
    [self didChangeValueForKey:kNLDeviceNamesKeyPath];
}

// Sends KVO messages and asks the model to update the visible contents.
- (void)updateContent {
    
    [self willChangeValueForSelectedLogMessages];
    
    NSArray *array = nil;
    [viewModel updateSelectedMessages:&array];
    selectedLogMessages = array;
    
    [self didChangeValueForSelectedLogMessages];
}

@end
