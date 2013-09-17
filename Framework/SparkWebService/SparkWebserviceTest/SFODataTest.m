//
//  SFODataTest.m
//  SparkWebservice
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

#import "SFODataTest.h"

#import "SFODataTestEntity.h"
#import "SFODataFetchRequest.h"
#import "SFODataTestEntity.h"
#import "SFConcreteWebServiceClient.h"
#import "SFWebServiceCancellable.h"
#import "SFDownloader.h"

@implementation SFODataTest {
    SFConcreteWebServiceClient * _webClient;
}

- (void)setUp {
    _webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://fakeurl.com/mashups/mashupengine"];
}

- (void)testODataFetchRequest {
    SFODataExpression *leftExpression = [[SFODataExpression alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"name"]];
    SFODataExpression *rightExpression = [[SFODataExpression alloc] initWithValue:@"Paul"];
    SFODataPredicate *firstPredicate = [[SFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:SFEqualToODataPredicateOperatorType];
    
    leftExpression = [[SFODataExpression alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"total"]];
    rightExpression = [[SFODataExpression alloc] initWithValue:@"32"];
    SFODataPredicate *secondPredicate = [[SFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:SFLessThanOrEqualToODataPredicateOperatorType];
    
    SFODataPredicate *predicate = [[SFODataPredicate alloc] initWithLeftExpression:[firstPredicate expression] rightExpression:[secondPredicate expression] type:SFLogicalOrODataPredicateOperatorType];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"total"] ascending:YES];
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName] predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    STAssertTrue([[fetchRequest generateQueryString] isEqualToString:@"$orderby=TotalCost asc&$filter=(Name eq Paul) or (TotalCost le 32)"], @"OData fetch request generated incorrect result");
}

- (void)testODataRequestClearURL {
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName]];
    
    __block BOOL isFinished = NO;
    
    __block SFDownloader *downloader = (SFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity"], @"URL was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity"], @"URL was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [downloader cancel];
    }
}

- (void)testODataRequestURL {
    SFODataExpression *leftExpression = [[SFODataExpression alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"name"]];
    SFODataExpression *rightExpression = [[SFODataExpression alloc] initWithValue:@"Paul"];
    SFODataPrioritizedPredicate *predicate = [[SFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:SFEqualToODataPredicateOperatorType];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"total"] ascending:YES];
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName] predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    __block BOOL isFinished = NO;
    
    __block SFDownloader *downloader = (SFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithParams {
    SFODataExpression *leftExpression = [[SFODataExpression alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"name"]];
    SFODataExpression *rightExpression = [[SFODataExpression alloc] initWithValue:@"Paul"];
    SFODataPrioritizedPredicate *predicate = [[SFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:SFEqualToODataPredicateOperatorType];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"total"] ascending:YES];
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName] predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    __block BOOL isFinished = NO;
    
    __block SFDownloader *downloader = (SFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL with parameter was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL with parameter was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithPagination {
    SFODataExpression *leftExpression = [[SFODataExpression alloc] initWithProperty:[SFODataTestEntity SF_propertyNamed:@"name"]];
    SFODataExpression *rightExpression = [[SFODataExpression alloc] initWithValue:@"Paul"];
    SFODataPredicate *predicate = [[SFODataPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:SFEqualToODataPredicateOperatorType];
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName] predicate:predicate];
    fetchRequest.fetchOffset = 2;
    fetchRequest.fetchLimit = 3;
    
    __block BOOL isFinished = NO;
    
    __block SFDownloader *downloader = (SFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$top=3&$skip=2&$filter=Name%20eq%20Paul"], @"URL with pagination was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$top=3&$skip=2&$filter=Name%20eq%20Paul"], @"URL with pagination was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithExpandOption {
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName]];
    [fetchRequest expandWithEntity:[SFODataTestEntity entityName]];
    [fetchRequest expandWithEntity:@"SomeEntity"];
    [fetchRequest expandWithEntity:@"AnotheEntity"];
    
    __block BOOL isFinished = NO;
    
    __block SFDownloader *downloader = (SFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity,SomeEntity,AnotheEntity"], @"URL with expand was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity,SomeEntity,AnotheEntity"], @"URL with expand was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithMultipleExpandOption {
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName]];
    [fetchRequest expandWithMultiLevelEntities:@[[SFODataTestEntity entityName], @"SomeEntity", @"AnotheEntity"]];
    
    __block BOOL isFinished = NO;
    
    __block SFDownloader *downloader = (SFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity/SomeEntity/AnotheEntity"], @"URL with multi level expand was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        STAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity/SomeEntity/AnotheEntity"], @"URL with multi level expand was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
        [downloader cancel];
    }
}

@end
