//
//  ViewController.m
//  ObjCAttrPerformanceTest
//
//  Created by Yuru Taustahuzau on 4/2/14.
//  Copyright (c) 2014 EPAM Systems. All rights reserved.
//

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
