//
//  ViewController.m
//  ObjCAttrPerformanceTest
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


#import "MainViewController.h"
#import "AttributeViewController.h"
#import "ReflectionViewController.h"


@interface MainViewController ()

@property (nonatomic, strong) ReflectionViewController *reflectionViewController;
@property (nonatomic, strong) AttributeViewController *attributeViewController;
@property (nonatomic, strong) UIViewController *currentViewController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)changeTestView:(id)sender;
@end

@implementation MainViewController


#pragma mark - Initialization

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self showRelatedView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


#pragma mark - Logic for test selection

static const NSInteger kSegmentIndexReflection = 0;
static const NSInteger kSegmentIndexAttribute = 1;

- (void)showRelatedView {
    [self.currentViewController willMoveToParentViewController:self.currentViewController];
    [self.currentViewController.view removeFromSuperview];

    if (self.segmentedControl.selectedSegmentIndex == kSegmentIndexReflection) {
        self.currentViewController = self.reflectionViewController;
        CGRect frame = self.reflectionViewController.view.frame;
        frame.size = CGSizeMake(320.0f, 712.0f);
        self.reflectionViewController.view.frame = frame;
    }
    else if (self.segmentedControl.selectedSegmentIndex == kSegmentIndexAttribute) {
        self.currentViewController = self.attributeViewController;
        CGRect frame = self.attributeViewController.view.frame;
        frame.size = CGSizeMake(320.0f, 520.0f);
        self.attributeViewController.view.frame = frame;
    }

    [self.scrollView addSubview:self.currentViewController.view];
    [self.currentViewController didMoveToParentViewController:self];
    self.scrollView.contentSize = self.currentViewController.view.frame.size;
}

- (IBAction)changeTestView:(id)sender {
    [self showRelatedView];
}


#pragma mark - On demand getters

- (ReflectionViewController *)reflectionViewController {
    if (!_reflectionViewController) {
        _reflectionViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ReflectionViewController class])];
    }

    return _reflectionViewController;
}

- (AttributeViewController *)attributeViewController {
    if (!_attributeViewController) {
        _attributeViewController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([AttributeViewController class])];
    }

    return _attributeViewController;
}

@end
