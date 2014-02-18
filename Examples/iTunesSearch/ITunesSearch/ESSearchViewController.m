//
//  ESSearchViewController.m
//  ITunesSearch
//
//  Copyright (c) 2014 Epam Systems. All rights reserved.
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


#import "ESSearchViewController.h"

#import "RFServiceProvider+ESITunesWebClient.h"
#import "ESSearchCell.h"
#import <ROAD/NSError+RFROADWebService.h>


@interface ESSearchViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;

@property (nonatomic) NSArray *apps;
@property (weak, nonatomic) id<RFWebServiceCancellable> currentOperation; // Saved reference to current web client operation. We don't want to keep it after operation will finish, so we mark this property with weak attribute.

- (IBAction)searchApps:(id)sender;

@end


@implementation ESSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.searchTextField.text = @"SEC"; // Initail value
    [self searchApps:nil];
}


#pragma mark - IBActions

- (IBAction)searchApps:(id)sender {
    [self.currentOperation cancel]; // Cancel last running operation if it exists. It force web client to execute failure block, so be sure that you handle it gracefully.
    __weak ESSearchViewController *weakSelf = self;
    self.currentOperation = [[RFServiceProvider iTunesWebClient] searchAppsWithName:self.searchTextField.text success:^(NSArray *apps) {// Here we have already processed entities, so we just save it and update UI
        ESSearchViewController *strongSelf = weakSelf;
        strongSelf.apps = apps;
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if ([error domain] != kRFWebServiceErrorDomain && weakSelf) { // kRFWebServiceErrorDomain - it's all errors from web service client, including cancel error, in your app check by code to get more precise filtration
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.apps count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *searchCellIdentifier = @"searchCellIdentifier";
    ESSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:searchCellIdentifier];
    [cell configureCellWithApp:self.apps[indexPath.row]];
    
    return cell;
}

@end
