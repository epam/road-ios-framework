//
//  ESLookupViewController.m
//  ITunesSearch
//
//  Copyright (c) 2014 EPAM Systems, Inc. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//  Redistributions in binary form must reproduce the above copyright notice, this
//  list of conditions and the following disclaimer in the documentation and/or
//  other materials provided with the distribution.
//  Neither the name of the EPAM Systems, Inc.  nor the names of its contributors
//  may be used to endorse or promote products derived from this software without
//  specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
//  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
//  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//  See the NOTICE file and the LICENSE file distributed with this work
//  for additional information regarding copyright ownership and licensing


#import "ESLookupViewController.h"

#import "RFServiceProvider+ESITunesWebClient.h"
#import "ESLookupCell.h"
#import "ESArtist.h"
#import <ROAD/NSError+RFWebService.h>


@interface ESLookupViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *amgTextField;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistGenreLabel;

@property (nonatomic) NSArray *albums;
@property (nonatomic) ESArtist *artist;
@property (weak, nonatomic) id<RFWebServiceCancellable> currentOperation;

- (IBAction)lookupAlbums:(id)sender;

@end


@implementation ESLookupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.amgTextField.text = @"468749"; // Initial value
    [self lookupAlbums:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.currentOperation cancel];
}

- (void)updateArtist:(ESArtist *)artist {
    self.artist = artist;
    self.artistNameLabel.text = self.artist.name;
    self.artistGenreLabel.text = self.artist.genre;
}


#pragma mark - IBActions

- (IBAction)lookupAlbums:(id)sender {
    [self.currentOperation cancel]; // Cancel last running operation if it exists. It force web client to execute failure block, so be sure that you handle it gracefully.
    __weak ESLookupViewController *weakSelf = self;
    self.currentOperation = [[RFServiceProvider iTunesWebClient] lookupAmgArtistId:self.amgTextField.text success:^(NSDictionary *albumsInfo) {// Here we have already processed entities, so we just save it and update UI
        ESLookupViewController *strongSelf = weakSelf;
        strongSelf.albums = albumsInfo[@"Albums"]; // In our custom serializer we put result into dictionary
        [strongSelf updateArtist:albumsInfo[@"Artist"]]; // And now we get these result with the same keys
        [strongSelf.tableView reloadData];
    } failure:^(NSError *error) {
        if ([error code] != kRFWebServiceErrorCodeCancel && weakSelf) { // We want to show to user any error excep cancel error
            [[[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }
    }];
    [self.amgTextField resignFirstResponder]; // Hide keyboard
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *lookupCellIdentifier = @"lookupCellIdentifier";
    ESLookupCell *cell = [tableView dequeueReusableCellWithIdentifier:lookupCellIdentifier];
    [cell configureCellWithAlbum:self.albums[indexPath.row]];
    
    return cell;
}

@end
