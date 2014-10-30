//
//  RFWebServiceTest.m
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

#import "RFWebServiceClient+DynamicTest.h"
#import "RFServiceProvider+ConcreteWebServiceClient.h"
#import "RFSerializableTestObject.h"
#import "RFDownloadFaker.h"
#import "RFDownloader.h"
#import "NSError+RFWebService.h"
#import "RFRequestTestProcessor.h"
#import "RFRequestTestAttribute.h"


@interface RFWebServiceTest : XCTestCase
{
    NSCondition * condition;
    BOOL authenticationFinished;
}

@end


@implementation RFWebServiceTest

+ (void)setUp {
    [RFDownloadFaker setUp];
}

// Travis bug cause performing +setUp before each test
+ (void)tearDown {
    [RFDownloadFaker tearDown];
}

- (void)testHeaderFieldsDictionaryAttachment {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.headerfields.dictionary"];
    [webClient testHeaderFieldsDictionaryAttachmentWithSuccess:^(id result) {
        isFinished = YES;
        isSuccess = ([result objectForKey:kRFWebServiceClientHeaderFieldsKey] != nil);
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue(isSuccess, @"Header fields for dictionary attachment is failed");
}

- (void)testHeaderFieldsObjectAttachment {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.headerfields.object"];
    [webClient testHeaderFieldsObjectAttachmentWithSuccess:^(id result) {
        isFinished = YES;
        isSuccess = ([result valueForKey:kRFWebServiceClientHeaderFieldsKey] != nil);
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue(isSuccess, @"Header fields object attachment is failed");
}

- (void)testHeaderFieldsArrayAttachment {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.headerfields.array"];
    [webClient testHeaderFieldsArrayAttachmentWithSuccess:^(id result) {
        isFinished = YES;
        isSuccess = ([result valueForKey:kRFWebServiceClientHeaderFieldsKey] != nil);
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue(isSuccess, @"Header fields array attachment is failed");
}

- (void)testHeaderFieldsNoBodyAttachment {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.headerfields.nobody"];
    [webClient testHeaderFieldsNoBodyAttachmentWithSuccess:^(id result) {
        isFinished = YES;
        isSuccess = ([result valueForKey:kRFWebServiceClientHeaderFieldsKey] != nil);
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue(isSuccess, @"Header fields no body attachment is failed");
}

- (void)testMultipartData {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.multipart.data"];
    RFFormData *attachment = [[RFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"];
    [webClient testMultipartDataWithAttachment:attachment success:^(id result) {
        isFinished = YES;
        isSuccess = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertTrue(isSuccess, @"Multipart form data request is failed");
}

- (void)testMultipartDataArray {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.multipart.data"];
    NSArray *attachments = @[[[RFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"],
                             [[RFFormData alloc] initWithName:@"image" data:[@"Random data 2" dataUsingEncoding:NSUTF8StringEncoding]],
                             [[RFFormData alloc] initWithName:@"image" data:[@"Random data 3" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName2.jpg"]];
    [webClient testMultipartDataWithAttachments:attachments success:^(id result) {
        isFinished = YES;
        isSuccess = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertTrue(isSuccess, @"Multipart form data request is failed");
}

- (void)testNilsInCompletionBlocks {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.method.without.blocks"];
    RFFormData *attachment = [[RFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"];
    [webClient testMultipartDataWithAttachment:attachment success:nil failure:nil];
    
    __block BOOL isFinished = NO;
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
        isFinished = YES;
    }
}

- (void)testCustomSerializer {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    __block id customSerializationResult;
    
    RFSerializableTestObject *testObject = [RFSerializableTestObject testObject];
    
    RFWebServiceClient *webClient = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://test.serializer"];
    [webClient testXMLSerializerWithObject:testObject withSuccess:^(id result) {
        isSuccess = YES;
        customSerializationResult = result;
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertTrue(isSuccess, @"Custom serialization of web service request is failed!");
    XCTAssertTrue([testObject isEqual:customSerializationResult], @"Custom deserialization of web service response is failed!");
}

- (void)testJsonSerializationEncoding {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    __block id jsonSerializationResult;

    RFSerializableTestObject *testObject = [RFSerializableTestObject testObject];
    testObject.name = @"Ваня Кузнецов";
    testObject.city = @"Нью-Васюки";

    RFWebServiceClient *webClient = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://test.serializer"]; //@"http://127.0.0.1:8080/xml"];
    [webClient testJsonSerializationEncoding:testObject withSuccess:^(id result) {
        isSuccess = YES;
        jsonSerializationResult = result;
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];

    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }

    XCTAssertTrue(isSuccess, @"JSON serialization of web service request is failed!");
    XCTAssertTrue([testObject isEqual:jsonSerializationResult], @"JSON deserialization of web service response is failed!");
}

- (void)testXMLSerializationEncoding {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    __block id xmlSerializationResult;

    RFSerializableTestObject *testObject1 = [RFSerializableTestObject testObject];
    testObject1.name = @"Ваня Кузнецов";

    RFWebServiceClient *webClient = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://test.serializer"]; // @"http://127.0.0.1:8080/xml"
    [webClient testXMLSerializationEncoding:testObject1 withSuccess:^(id result) {
        isSuccess = YES;
        xmlSerializationResult = result;
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];

    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }

    XCTAssertTrue(isSuccess, @"XML serialization of web service request is failed!");
    XCTAssertTrue([testObject1 isEqual:xmlSerializationResult], @"XML deserialization of web service response is failed!");
}

- (void)testGetWithJsonSerializationEncoding {
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    __block id jsonSerializationResult1;

    RFSerializableTestObject *testObject2 = [RFSerializableTestObject testObject];
    testObject2.name = @"Ваня Кузнецов";
    testObject2.city = @"Нью-Васюки";

    RFWebServiceClient *webClient = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://test.serializer/"]; //@"http://127.0.0.1:8080/xml"];
    [webClient testGetWithJsonSerializationEncoding:testObject2 withSuccess:^(id result) {
        isSuccess = YES;
        jsonSerializationResult1 = result;
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];

    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }

    XCTAssertTrue(isSuccess, @"JSON serialization of web service URL is failed!");
    XCTAssertTrue([testObject2 isEqual:jsonSerializationResult1], @"JSON deserialization of web service response is failed!");
}

- (void)testDownloadingCancellation {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    __block BOOL isFinished = NO;
    __block int successFlag = 0;
    const int kSuccessValue = 1;
    id<RFWebServiceCancellable> downloadOperation = [webClient testSimpleWebServiceCallWithSuccess:^(id result) {
        successFlag += 2;
        isFinished = YES;
    } failure:^(NSError *error) {
        successFlag += 1;
        isFinished = YES;
    }];
    
    [(NSObject *)downloadOperation performSelector:@selector(cancel) withObject:nil afterDelay:0.0];
    [(NSObject *)downloadOperation performSelector:@selector(cancel) withObject:nil afterDelay:0.1];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:2]];
    }
    
    XCTAssertEqual(successFlag, kSuccessValue, @"Web service cancellation finished with unexpected result!");
}

- (void)testCancelWithReason {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    __block BOOL isFinished = NO;
    __block NSError *cancelWithReasonError;
    id<RFWebServiceCancellable> downloadOperation = [webClient testSimpleWebServiceCallWithSuccess:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        cancelWithReasonError = error;
        isFinished = YES;
    }];
    
    NSObject *reason = [[NSObject alloc] init];
    [downloadOperation cancelWithReason:reason];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:2]];
    }
    
    XCTAssertEqual([cancelWithReasonError code], kRFWebServiceErrorCodeCancel, @"Web service cancellation finished with unexpected code!");
    XCTAssertEqual([cancelWithReasonError userInfo][kRFWebServiceCancellationReason], reason, @"Web service cancellation finished with unexpected reason!");
}

- (void)testCancelWithoutReason {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    __block BOOL isFinished = NO;
    __block NSError *cancelError;
    id<RFWebServiceCancellable> downloadOperation = [webClient testSimpleWebServiceCallWithSuccess:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        cancelError = error;
        isFinished = YES;
    }];
    
    [downloadOperation cancel];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:2]];
    }
    
    XCTAssertEqual([cancelError code], kRFWebServiceErrorCodeCancel, @"Web service cancellation finished with unexpected code!");
    XCTAssertNil([cancelError userInfo][kRFWebServiceCancellationReason], @"Web service cancellation finished with unexpected reason!");
}

- (void)testRequestProcessorDelegate {
    
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    RFRequestTestProcessor *testRequestProcessor = [[RFRequestTestProcessor alloc] init];
    RFWebServiceClient *client = [[RFWebServiceClient alloc] initWithServiceRoot:@"https://test.simple.call/"];
    
    client.requestProcessor = testRequestProcessor;
    
    [client methodAttributeTestRequest:^(id result) {
        
        isFinished = YES; /* reveived data ... */
    } failure:^(NSError *error) {
        
        isFinished = YES; /* reveived data ... */
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertEqual(testRequestProcessor.passedAttributes.count, 2, @"Attributes are not passed to the request processor.");
    
    BOOL attributeFound = NO;
    for (NSObject *currentAttribute in testRequestProcessor.passedAttributes) {
        if ( [currentAttribute isKindOfClass:[RFRequestTestAttribute class]] ) {
            attributeFound = YES;
        }
    }
    
    XCTAssertTrue(attributeFound, @"Test attribute not passed to the request processor.");
}

- (void)testPutMethodToHaveBody {
    RFConcreteWebServiceClient *client = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"https://test.body.existence/"];
    
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    [client testPutBodyPresenceWithData:@"Body"
                                success:^(id result) {
                                    isSuccess = YES;
                                    isFinished = YES; /* reveived data ... */
                                } failure:^(NSError *error) {
                                    isFinished = YES; /* reveived data ... */
                                }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertTrue(isSuccess, @"Put methods did not have body.");
}

- (void)testDownloadingPrepareAndProgressBlock {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    __block BOOL isPrepareFinished = NO;
    __block int prepareBlockCounter = 0;
    __block BOOL isProgressFinished = NO;
    __block int progressBlockCounter = 0;
    __block BOOL isFinished = NO;
    [webClient testDownloadingWithProgressBlock:^(float progress, long long expectedContentLenght) {
        progressBlockCounter++;
        isProgressFinished = YES;
    } prepareBlock:^(NSMutableURLRequest *serviceRequest) {
        prepareBlockCounter++;
        isPrepareFinished = YES;
    } success:^(id response) {
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isPrepareFinished || !isProgressFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertTrue(isProgressFinished, @"Web service progress block was not executed");
    XCTAssertEqual(progressBlockCounter, 2, @"Web service progress block was unexpected number of times");
    XCTAssertEqual(prepareBlockCounter, 1, @"Web service prepare block was unexpected number of times");
    XCTAssertTrue(isPrepareFinished, @"Web service prepare block was not executed");
}

- (void)testPrepareBlockExecution {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    __block BOOL isPrepareFinished = NO;
    __block int prepareBlockCounter = 0;
    __block BOOL isFinished = NO;
    [webClient testDownloadingPrepareBlock:^(NSMutableURLRequest *serviceRequest) {
        prepareBlockCounter++;
        isPrepareFinished = YES;
    } success:^(id response) {
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isPrepareFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertEqual(prepareBlockCounter, 1, @"Web service prepare block was unexpected number of times");
    XCTAssertTrue(isPrepareFinished, @"Web service prepare block was not executed");
}

- (void)testDownloadingProgressBlock {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.simple.call"];
    __block BOOL isProgressFinished = NO;
    __block int progressBlockCounter = 0;
    __block BOOL isStartProgressNotified = NO;
    __block BOOL isEndProgressNotified = NO;
    __block BOOL isFinished = NO;
    [webClient testDownloadingProgressBlock:^(float progress, long long expectedContentLenght) {
        progressBlockCounter++;
        isProgressFinished = YES;
        if (progress == 0) {
            isStartProgressNotified = YES;
        }
        if (progress == 1.0) {
            isEndProgressNotified = YES;
        }
    } success:^(id response) {
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    
    XCTAssertTrue(isProgressFinished, @"Web service progress block was not executed");
    XCTAssertTrue(isStartProgressNotified, @"Web service progress block notified about start downloading");
    XCTAssertTrue(isEndProgressNotified, @"Web service progress block notified about finish downloading");
    XCTAssertEqual(progressBlockCounter, 2, @"Web service progress block was unexpected number of times");
}

@end
