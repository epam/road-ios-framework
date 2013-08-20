//
//  NLBindingDataSource.h
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


#import "NLViewModelling.h"

/**
 Datasource class for the main view model, used to separate the collections and containers included in the cocoa bindings from the main model.
 The public properties of this class are bound to UI elements in the MainMenu.xib file.
 */
@interface NLBindingDataSource : NSObject

/**
 The id of the selected device.
 */
@property (nonatomic, copy) NSString *selectedDeviceId;

/**
 The array of the selected log messages - the contents of this array reflects the currently visible messages.
 */
@property (nonatomic, readonly) NSArray *selectedLogMessages;

/**
 Dictionary mapping the device names belonging to available connections.
 */
@property (nonatomic, readonly) NSDictionary *deviceNames;

/**
 The currently selected log level.
 */
@property (nonatomic, strong) NSString *selectedLogLevel;

/**
 Descriptor used to sort the log level options.
 */
@property (nonatomic, readonly) NSArray *sortDescriptors;

/**
 Indicates whether displaying new messages on the UI was paused. Does not stop collecting new messages in the background.
 */
@property (nonatomic, getter = isPaused) BOOL paused;

/**
 Weak reference to the main view model, used to ask the model to update the actively visible log messages.
 */
@property (nonatomic, weak) id<NLViewModelling> viewModel;

/**
 Designated initializer.
 */
- (id)initWithModel:(id<NLViewModelling>)aModel;

/**
 Method to invoke when the log messages have changed, and the UI should update itself accordingly.
 */
- (void)updateContent;

/**
 Method to invoke when a new connection/device is added.
 */
- (void)updateDeviceListWithId:(NSString *)uniqueId name:(NSString *)deviceName;

- (void)removeDevice:(NSString *)uniqueId;

@end

