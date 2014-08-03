//
//  RFODataTest.m
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


#import <XCTest/XCTest.h>

#import "RFODataTestEntity.h"
#import "RFODataFetchRequest.h"
#import "RFODataTestEntity.h"
#import "RFConcreteWebServiceClient.h"
#import "RFWebServiceCancellable.h"
#import "RFDownloader.h"


@interface RFODataTest : XCTestCase

@end


@implementation RFODataTest {
    RFConcreteWebServiceClient * _webClient;
}

- (void)setUp {
    _webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://fakeurl.com/mashups/mashupengine"];
}

- (void)testODataFetchRequest {
    RFODataExpression *leftExpression = [[RFODataExpression alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"name"]];
    RFODataExpression *rightExpression = [[RFODataExpression alloc] initWithValue:@"Paul"];
    RFODataPredicate *firstPredicate = [[RFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:RFEqualToODataPredicateOperatorType];
    
    leftExpression = [[RFODataExpression alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"total"]];
    rightExpression = [[RFODataExpression alloc] initWithValue:@"32"];
    RFODataPredicate *secondPredicate = [[RFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:RFLessThanOrEqualToODataPredicateOperatorType];
    
    RFODataPredicate *predicate = [[RFODataPredicate alloc] initWithLeftExpression:[firstPredicate expression] rightExpression:[secondPredicate expression] type:RFLogicalOrODataPredicateOperatorType];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"total"] ascending:YES];
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName] predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    XCTAssertTrue([[fetchRequest generateQueryString] isEqualToString:@"$orderby=TotalCost asc&$filter=(Name eq Paul) or (TotalCost le 32)"], @"OData fetch request generated incorrect result");
}

- (void)testODataRequestClearURL {
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName]];
    
    __block BOOL isFinished = NO;
    
    __block RFDownloader *downloader = (RFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity"], @"URL was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity"], @"URL was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [downloader cancel];
    }
}

- (void)testODataRequestURL {
    RFODataExpression *leftExpression = [[RFODataExpression alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"name"]];
    RFODataExpression *rightExpression = [[RFODataExpression alloc] initWithValue:@"Paul"];
    RFODataPrioritizedPredicate *predicate = [[RFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:RFEqualToODataPredicateOperatorType];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"total"] ascending:YES];
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName] predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    __block BOOL isFinished = NO;
    
    __block RFDownloader *downloader = (RFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithParams {
    RFODataExpression *leftExpression = [[RFODataExpression alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"name"]];
    RFODataExpression *rightExpression = [[RFODataExpression alloc] initWithValue:@"Paul"];
    RFODataPrioritizedPredicate *predicate = [[RFODataPrioritizedPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:RFEqualToODataPredicateOperatorType];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"total"] ascending:YES];
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName] predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    __block BOOL isFinished = NO;
    
    __block RFDownloader *downloader = (RFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL with parameter was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$orderby=TotalCost%20asc&$filter=(Name%20eq%20Paul)"], @"URL with parameter was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithPagination {
    RFODataExpression *leftExpression = [[RFODataExpression alloc] initWithProperty:[RFODataTestEntity RF_propertyNamed:@"name"]];
    RFODataExpression *rightExpression = [[RFODataExpression alloc] initWithValue:@"Paul"];
    RFODataPredicate *predicate = [[RFODataPredicate alloc] initWithLeftExpression:leftExpression rightExpression:rightExpression type:RFEqualToODataPredicateOperatorType];
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName] predicate:predicate];
    fetchRequest.fetchOffset = 2;
    fetchRequest.fetchLimit = 3;
    
    __block BOOL isFinished = NO;
    
    __block RFDownloader *downloader = (RFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$top=3&$skip=2&$filter=Name%20eq%20Paul"], @"URL with pagination was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$top=3&$skip=2&$filter=Name%20eq%20Paul"], @"URL with pagination was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithExpandOption {
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName]];
    [fetchRequest expandWithEntity:[RFODataTestEntity entityName]];
    [fetchRequest expandWithEntity:@"SomeEntity"];
    [fetchRequest expandWithEntity:@"AnotheEntity"];
    
    __block BOOL isFinished = NO;
    
    __block RFDownloader *downloader = (RFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity,SomeEntity,AnotheEntity"], @"URL with expand was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity,SomeEntity,AnotheEntity"], @"URL with expand was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [downloader cancel];
    }
}

- (void)testODataRequestURLWithMultipleExpandOption {
    RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName]];
    [fetchRequest expandWithMultiLevelEntities:@[[RFODataTestEntity entityName], @"SomeEntity", @"AnotheEntity"]];
    
    __block BOOL isFinished = NO;
    
    __block RFDownloader *downloader = (RFDownloader *)[_webClient loadDataWithFetchRequest:fetchRequest someImportantParameter:@"value1" success:^(id result) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity/SomeEntity/AnotheEntity"], @"URL with multi level expand was built incorrectly");
        isFinished = YES;
    } failure:^(NSError *error) {
        NSLog(@"%@", downloader.request.URL);
        XCTAssertTrue([downloader.request.URL.absoluteString isEqualToString:@"http://fakeurl.com/mashups/mashupengine/TestEntity?importantParameter=value1&$expand=TestEntity/SomeEntity/AnotheEntity"], @"URL with multi level expand was built incorrectly");
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
        [downloader cancel];
    }
}

- (void)testODataErrorHandling {
    __block BOOL isFinished = NO;
    __block NSError *receivedError;

    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://services.odata.org/V3/(S(plcxuejnllfvrrecpvqbehxz))/OData/OData.svc/Product(1)"];
    [webClient testErrorHandlerRootWithSuccess:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        receivedError = error;
        isFinished = YES;
    }];

    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }

    XCTAssertTrue(receivedError != nil, @"Error've not been generated!");
    XCTAssertTrue(receivedError.localizedDescription != nil, @"Localized description've not been filled for generated error!");
    XCTAssertTrue(receivedError.code, @"Code've not been filled for generated error!");
}

@end
