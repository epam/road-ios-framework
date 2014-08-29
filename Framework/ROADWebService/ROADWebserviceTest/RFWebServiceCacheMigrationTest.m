//
//  NSArray+RFEmptyArrayChecks.h
//  ROADCore
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


#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>

#import "RFWebServiceCacheContext.h"

@interface RFWebServiceCacheContext(PrivateForTests)
+ (NSURL*)persistentStoreURL;
@end

@interface RFWebServiceCacheMigrationTest : XCTestCase
@end

@implementation RFWebServiceCacheMigrationTest

- (void)setUp {
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    
    NSURL* resourceDBURL = [bundle URLForResource:@"RFWebServiceCache" withExtension:@"coredata"];
    NSURL* persistentStoreURL = [RFWebServiceCacheContext persistentStoreURL];
    
    NSError* error;
    if ([[NSFileManager defaultManager] fileExistsAtPath:persistentStoreURL.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:persistentStoreURL error:&error];
    }
    
    [[NSFileManager defaultManager] copyItemAtURL:resourceDBURL toURL:persistentStoreURL error:&error];
}

- (void)tearDown {
}

- (void)testSmokeOldBase {
    
    NSError* error;
    NSBundle* bundle = [NSBundle bundleForClass:[self class]];
    
    NSURL* momdURL = [bundle URLForResource:@"RFWebServiceCachingModel" withExtension:@"momd"];
    NSString* momPath = [bundle pathForResource:@"RFWebServiceCachingModel_v3" ofType:@"mom" inDirectory:momdURL.lastPathComponent];
    
    NSURL* persistentStoreURL = [RFWebServiceCacheContext persistentStoreURL];
    
    NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:momPath]];
    
    NSPersistentStoreCoordinator* sourceCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
    
    [sourceCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                         configuration:nil
                                                   URL:persistentStoreURL
                                               options:nil
                                                 error:&error];
    
    XCTAssertNotNil(sourceCoordinator, @"V3 cache database has not been opened.");
}

- (void)testMigration {

    RFWebServiceCacheContext* context = [[RFWebServiceCacheContext alloc] init];
    NSPersistentStoreCoordinator* coordinator = context.persisitentStoreCoordinator;
    
    XCTAssertTrue(coordinator.persistentStores.count == 1, @"Migration was unsuccessful.");
}

@end
