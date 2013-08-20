//
//  NLViewModel.m
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


#import "NLViewModel.h"
#import "NLChain.h"
#import "ACLogMessage.h"
#import "NLBindingDataSource.h"
#import "NLLogMessageWrapper.h"

NSString * const kNLServiceListLogLevels = @"NLServiceListLogLevels";
NSString * const plist = @"plist";
NSString * const kNLInfoLogLevelKey = @"Info";

@implementation NLViewModel {
    
    NSMutableDictionary *logLevels;
    NSMutableDictionary *deviceContainers;
}

@synthesize dataSource;
@synthesize logLevels;

- (id)init {

    self = [super init];
    
    if (self) {
        
        dataSource = [[NLBindingDataSource alloc] initWithModel:self];
        [self setupContainers];
    }
    
    return self;
}

#pragma mark - Delegate methods

// Netservice invoked method indicating a new log message has been received.
- (void)didReceiveLogMessage:(NLLogMessageWrapper *)logMessageWrapper {
    
    [[self containerForDevice:logMessageWrapper] addObject:logMessageWrapper.message forIdentifier:[self levelIdentifierFromLogLevel:logMessageWrapper.message.logLevel]];
    [dataSource updateContent];
}

// Datasource-invoked method used to ask the model to load new content into the bound array, due to some UI setting changes
- (void)updateSelectedMessages:(NSArray *__autoreleasing *)arrayOfMessages {
    
    NLChain *chain = [deviceContainers objectForKey:dataSource.selectedDeviceId];
    *arrayOfMessages = [chain objectsForIdentifier:dataSource.selectedLogLevel];
}

// invoked when a connection is about to close
- (void)willTerminateConnectionWithUniqueId:(NSString *)uniqueId {
    
    [deviceContainers removeObjectForKey:uniqueId];
    [dataSource removeDevice:uniqueId];
    [dataSource updateContent];
}

#pragma mark - Private methods

// Sets up the collections used to manage log message storage.
- (void)setupContainers {

    NSString *dictPath = [[NSBundle mainBundle] pathForResource:kNLServiceListLogLevels ofType:plist];
    logLevels = [NSMutableDictionary dictionaryWithContentsOfFile:dictPath];
    deviceContainers = [NSMutableDictionary dictionary];
}

// Allocates a new container hierarchy for a new connection.
- (void)addNewDevice:(NLLogMessageWrapper *)wrapper {
    
    NSArray *sortedKeys = [[logLevels allValues] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSArray *collectionOfLogContainers = [NLChain chainHierarchyForIdentifiers:sortedKeys];
    NLChain *infoLogMessages = [collectionOfLogContainers objectAtIndex:0];
    [deviceContainers setObject:infoLogMessages forKey:wrapper.uniqueId];
}

// Translates the integer log level into a string.
- (NSString *)levelIdentifierFromLogLevel:(int)logLevel {
    
    return [NSString stringWithFormat:@"%d", logLevel];
}

// Returns an existing one or creates a new container hierarchy for the given message.
- (NLChain *)containerForDevice:(NLLogMessageWrapper *)wrapper {
    
    NLChain *rootContainer = [deviceContainers objectForKey:wrapper.uniqueId];
    
    if (rootContainer == nil) {
        
        [self setupNewConnection:wrapper];
        rootContainer = [deviceContainers objectForKey:wrapper.uniqueId];
    }
    
    return rootContainer;
}

// Instructs the datasource to add a new connection to the available list.
- (void)setupNewConnection:(NLLogMessageWrapper *)wrapper {
    
    [self addNewDevice:wrapper];

    [dataSource updateDeviceListWithId:wrapper.uniqueId name:[NSString stringWithFormat:@"%@ - %@", wrapper.deviceName, wrapper.applicationName]];
}

// Iterates through the log message container hierarchy and removes all messages.
- (void)clearContent {
    
    for (NLChain *aRootLink in [deviceContainers allValues]) {
        
        [aRootLink removeAllObjectsForIdentifier:aRootLink.containerIdentifier];
    }
    
    [dataSource updateContent];
}

@end
