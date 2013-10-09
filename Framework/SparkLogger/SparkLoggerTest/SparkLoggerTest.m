//
//  ROADLoggerTest.m
//  ROADLoggerTest
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
//
// See the NOTICE file and the LICENSE file distributed with this work
// for additional information regarding copyright ownership and licensing

#import "ROADLoggerTest.h"
#import <ROAD/ROADServices.h>
#import <ROAD/ROADLogger.h>
#import <ROAD/SFServiceProvider+LoggingService.h>

@implementation ROADLoggerTest

- (void)setUp {
    [super setUp];
    // Set-up code here.
}

- (void)tearDown {
    // Tear-down code here.
    [super tearDown];
}

- (void)testInstanceAsService {
    
    id <SFLogging> logger = [SFServiceProvider logger];
    STAssertNotNil(logger, @"Logger as service has not been initialised.");
}

- (void)testInstanceWriters {
    // reset queue of writers
    [[SFServiceProvider logger] setWriters:@[]];
    
    [[SFServiceProvider logger] addWriter:[SFConsoleLogWriter new]];
    [[SFServiceProvider logger] addWriter:[SFConsoleLogWriter plainConsoleWriter]];
    [[SFServiceProvider logger] addWriter:[SFConsoleLogWriter plainConsoleWriter]];
    
    STAssertTrue([[[SFServiceProvider logger] writers] count] == 3, @"The number of the writers (added) doesn't coincide");
}

- (void)testFilters {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SFLogMessage *evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject.type isEqualToString:kSFLogMessageTypeNetworkOnly];
    }];
    SFLogFilter *logFilter = [SFLogFilter filterWithPrediate:predicate];
    
    SFLogMessage *validLogMessage = [SFLogMessage logMessage:@"Simple message" type:kSFLogMessageTypeNetworkOnly level:SFLogLevelWarning userInfo:nil];
    SFLogMessage *invalidLogMessage = [SFLogMessage logMessage:@"Simple message" type:kSFLogMessageTypeFileOnly level:SFLogLevelWarning userInfo:nil];
    
    STAssertTrue([logFilter hasMessagePassedTest:validLogMessage], @"Valid message have not passed test!");
    STAssertFalse([logFilter hasMessagePassedTest:invalidLogMessage], @"Invalid message have passed test!");
}

- (void)testMacroses {
    // reset queue of writers
    [[SFServiceProvider logger] setWriters:@[]];
    
    SFLogWriter *writer = [SFConsoleLogWriter new];
    // add console writer
    [[SFServiceProvider logger] addWriter:writer];
    [[SFServiceProvider logger] setLogLevel:SFLogLevelWarning];
    
    SFLogInfo(@"I 234242%@", @"87686");
    SFLogDebug(@"D 098765, %d", 2342);
    SFLogWarning(@"W 12345%@", [[NSObject alloc] init]);
    SFLogError(@"E 345678%2.6f", 234.234626);
    
    SFLogTypedInfo(kSFLogMessageTypeAllLoggers, @"I 234242%2.6f", 234.234626);
    SFLogTypedDebug(kSFLogMessageTypeAllLoggers, @"D 234242%@", [[NSObject alloc] init]);
    SFLogTypedWarning(kSFLogMessageTypeAllLoggers, @"W 234242%@", @"87686");
    SFLogTypedError(kSFLogMessageTypeAllLoggers, @"E 234242");
    
    BOOL isFinished = NO;
    while (!isFinished) {
        [[NSRunLoop mainRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
        if ([[writer messageQueue] count] == 0) {
            isFinished = YES;
        }
    }
}

- (void)testSimpleSendInfoMessage {
    // reset queue of writers
    [[SFServiceProvider logger] setWriters:@[]];

    SFLogWriter *writer = [SFConsoleLogWriter new];
    // add console writer
    [[SFServiceProvider logger] addWriter:writer];
    
    NSString *simpleMessage = @"Simple test message";
    
    [[SFServiceProvider logger] logInfoMessage:simpleMessage];
    
    STAssertFalse([[writer messageQueue] count] == 0, @"The queue of messages is empty");
    STAssertEquals(simpleMessage, [[[writer messageQueue] objectAtIndex:0] message], @"Values are not equals");
    
    BOOL isFinished = NO;
    while (!isFinished) {
        [[NSRunLoop mainRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
        isFinished = YES;
        STAssertTrue([[writer messageQueue] count] == 0, @"The queue of messages is not empty");
    }
}

- (void)testCustomFormatter {
    
    NSString *message1 = @"It's right";
    NSString *message2 = @"It's not right";
    NSString *symbol = @"not ";

    SFLogWriter *writer = [SFConsoleLogWriter new];
    writer.formatter = [SFLogFormatter formatterWithBlock:^NSString *(SFLogMessage *const message) {
        
        if ([message.message rangeOfString:symbol].location == NSNotFound) {
            return message.message;
        } else {
            return [message.message stringByReplacingOccurrencesOfString:symbol withString:@""];
        }
    }];
    
    STAssertTrue([[writer formattedMessage:[SFLogMessage infoMessage:message2]] isEqualToString:message1] , @"Values are not equals");
}

@end
