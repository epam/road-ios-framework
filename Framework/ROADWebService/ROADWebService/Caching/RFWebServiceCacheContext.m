//
//  RFWebServiceCacheContext.m
//  ROADWebService
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


#import "RFWebServiceCacheContext.h"
#import <ROAD/ROADCore.h>

#import "RFWebServiceLog.h"


static NSString * const kRFWebServiceCachingDirectory = @"RFCachingDirecory";
static NSString * const kRFWebServiceCachingModelName = @"RFWebServiceCachingModel";
static NSString * const kRFWebServiceCachingModelExtension = @"momd";
static NSString * const kRFWebServiceCachingStorageName = @"RFWebServiceCache.coredata";

@implementation RFWebServiceCacheContext {
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
    NSManagedObjectContext *_managedObjectContext;
}

- (NSManagedObjectContext *)context {
    return [self managedObjectContext];
}

#pragma mark - Core Data Utitlity

- (NSPersistentStoreCoordinator *)persisitentStoreCoordinator {
    if (!_persistentStoreCoordinator) {
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        [self bindStore];
    }
    
    return _persistentStoreCoordinator;
}

- (void)bindStore {
    if ([_persistentStoreCoordinator.persistentStores count] > 0) {
        return;
    }
    
    NSArray *cachingFolderList = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *webServiceCachingPath = [cachingFolderList lastObject];
    
    webServiceCachingPath = [webServiceCachingPath stringByAppendingPathComponent:kRFWebServiceCachingDirectory];
    if (![[NSFileManager defaultManager] fileExistsAtPath:webServiceCachingPath]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:webServiceCachingPath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            RFWSLogError(@"Directory for web service cache was not created with error: %@", error);
        }
    }
    
    webServiceCachingPath = [webServiceCachingPath stringByAppendingPathComponent:kRFWebServiceCachingStorageName];
    _storeURL = [NSURL fileURLWithPath:webServiceCachingPath];
    NSString *storeType = NSSQLiteStoreType;
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption : @YES,
                              NSInferMappingModelAutomaticallyOption : @YES
                              };
    NSError *error;

    if (![_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil
                                                             URL:_storeURL options:options error:&error]) {
        error = nil;
        [[NSFileManager defaultManager] removeItemAtURL:_storeURL error:&error];
        if (![_persistentStoreCoordinator addPersistentStoreWithType:storeType configuration:nil
                                                                 URL:_storeURL options:options error:&error]) {
            _persistentStoreCoordinator = nil;
            RFWSLogError(@"RFWebServiceCachingManager error: persistent storage creating was failed with error: %@", [error localizedDescription]);
        }
    }
}

- (NSManagedObjectModel *)managedObjectModel {
    if (!_managedObjectModel) {
        NSString *modelPath = [[NSBundle bundleForClass:self.class] pathForResource:kRFWebServiceCachingModelName ofType:kRFWebServiceCachingModelExtension];
        NSString *escapedModelPath = [modelPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURL *url = [[NSURL alloc] initWithString:escapedModelPath];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    }
    
    return _managedObjectModel;
}

- (NSManagedObjectContext *)managedObjectContext {
    if (!_managedObjectContext) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:[self persisitentStoreCoordinator]];
    }
    
    return _managedObjectContext;
}

@end
