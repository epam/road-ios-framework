//
//  NLServiceListViewController.m
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


#import "NLServiceListViewController.h"
#import "NLLogMessageWrapper.h"
#import "ACLogMessage.h"
#import "NLLogListenerService.h"
#import "NLLogFileManager.h"
#import "NLViewModel.h"
#import "NLBindingDataSource.h"

NSString * const kServiceNamePattern = @"kServiceNamePattern";
NSString * const kServiceNameSuffix = @"_netLog_srv";

@interface NLServiceListViewController () {
    NLLogListenerService *logListenerService;
    BOOL isPaused;
}

@end

@implementation NLServiceListViewController

@synthesize serviceNamePattern;
@synthesize startButton;
@synthesize stopButton;
@synthesize model;
@synthesize sourceButton;
@synthesize levelButton;

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    model = [[NLViewModel alloc] init];
    
    logListenerService = [[NLLogListenerService alloc] init];
    [logListenerService setDelegate:model];
    
    NSString *savedServiceNamePattern = [[NSUserDefaults standardUserDefaults] objectForKey:kServiceNamePattern];
    
    if (savedServiceNamePattern != nil) {
        [serviceNamePattern setStringValue:savedServiceNamePattern];
    }
}

// Checks if the service name has been submitted, or throws an alert box to warn the user.
// If successful, it initiates the listener netservice, and publishes it to the local network.
- (IBAction)startService:(id)sender {
    
    if ([[serviceNamePattern stringValue] length] == 0) {
        [[NSAlert alertWithMessageText:@"Service name pattern must be set" 
                         defaultButton:@"Ok" 
                       alternateButton:nil 
                           otherButton:nil 
             informativeTextWithFormat:@"Service name pattern must be set"] runModal];
    }
    else {
        [[NSUserDefaults standardUserDefaults] setObject:[serviceNamePattern stringValue] forKey:kServiceNamePattern];
        
        NSString *serviceName = [[serviceNamePattern stringValue] stringByAppendingString:kServiceNameSuffix];
        [logListenerService setServiceName:serviceName];
        [logListenerService startService];
        [startButton setEnabled:NO];
        [stopButton setEnabled:YES];
        [serviceNamePattern setEnabled:NO];
    }
}

// Stops the active netservice and toggles the button states to reflect this change.
- (IBAction)stopService:(id)sender {
    [logListenerService stopService];
    [startButton setEnabled:YES];
    [stopButton setEnabled:NO];
    [serviceNamePattern setEnabled:YES];
}

- (void)applicationWillTerminate {
    
    [logListenerService stopService];
    logListenerService = nil;
}

- (IBAction)pauseChanged:(id)sender {
    isPaused = !isPaused;
    [self.model.dataSource setPaused:isPaused];
}

// Runs a modal save file dialog to save the current log contents into a text file.
- (IBAction)saveContent:(NSButton *)sender {
    
    NSSavePanel *panel = [[NSSavePanel alloc] init];
    
    panel.allowedFileTypes = [NSArray arrayWithObject:@"txt"];
    panel.allowsOtherFileTypes = NO;
    panel.directoryURL = nil;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    panel.directoryURL = [NSURL fileURLWithPath:basePath];
    
    if ([panel runModal] == NSFileHandlingPanelOKButton) {
        
        NSURL *pathUrl = panel.URL;
        
        NLLogFileManager *manager = [[NLLogFileManager alloc] initWithUrl:pathUrl];
        [manager saveLogs:[model.dataSource.selectedLogMessages copy]];
    }
}

- (IBAction)clearContent:(id)sender {
    
    [self.model clearContent];
}

@end
