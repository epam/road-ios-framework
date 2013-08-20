//
//  NLServiceListViewController.h
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


#import <Cocoa/Cocoa.h>
#import "NLBaseViewController.h"

@class NLServiceListViewModel;
@class NLViewModel;

/**
 The main viewcontroller of the log listener app.
 */
@interface NLServiceListViewController : NLBaseViewController

/**
 The text field outlet where the user can submit the name of the logging service.
 */
@property (strong, nonatomic) IBOutlet NSTextField *serviceNamePattern;

/**
 The start button outlet.
 */
@property (strong, nonatomic) IBOutlet NSButton *startButton;

/**
 The stop button outlet.
 */
@property (strong, nonatomic) IBOutlet NSButton *stopButton;

/**
 The popup button allowing the user to select from the available sources, which one to listen to.
 */
@property (strong, nonatomic) IBOutlet NSPopUpButton *sourceButton;

/**
 The popup button allowing the user to select from the available log levels (default values).
 */
@property (strong, nonatomic) IBOutlet NSPopUpButton *levelButton;

/**
 The view model.
 */
@property (strong, nonatomic) NLViewModel *model;

/**
 IBAction received when the user clicks the start button.
 */
- (IBAction)startService:(id)sender;

/**
 IBAction received when the user clicks the stop button.
 */
- (IBAction)stopService:(id)sender;

/**
 IBAction received when the user toggles the pause button.
 */
- (IBAction)pauseChanged:(NSButton *)pauseButton;

/**
 IBAction received when the user clicks the save button.
 */
- (IBAction)saveContent:(NSButton *)sender;

/**
 IBAction received when the user clicks the clear button.
 */
- (IBAction)clearContent:(id)sender;

@end
