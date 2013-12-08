//
//  RFTestLog.m
//  ROADCore
//
//  Created by Yuru Taustahuzau on 12/8/13.
//  Copyright (c) 2013 Epam Systems. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

// GCOV Flush function
extern void __gcov_flush(void);

static id mainSuite = nil;

@interface RFTestLog : SenTestLog

@end

@implementation RFTestLog

+ (void)initialize
{
	[[NSUserDefaults standardUserDefaults] setValue:@"RFTestLog" forKey:SenTestObserverClassKey];
    
	[super initialize];
}

+ (void)testSuiteDidStart:(NSNotification *)notification
{
	[super testSuiteDidStart:notification];
    
	SenTestSuiteRun *suite = notification.object;
    
	if (mainSuite == nil)
	{
		mainSuite = suite;
	}
}

+ (void)testSuiteDidStop:(NSNotification *)notification
{
	[super testSuiteDidStop:notification];
    
	SenTestSuiteRun* suite = notification.object;
    
	if (mainSuite == suite)
	{
		// workaround for missing flush with iOS 7 Simulator
		__gcov_flush();
	}
}

@end
