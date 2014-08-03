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

#import "RFWebServiceClientWithRoot.h"
#import "RFWebServiceClient+DynamicTest.h"
#import "RFAuthenticating.h"
#import "RFServiceProvider+ConcreteWebServiceClient.h"
#import "RFSerializableTestObject.h"
#import "RFBasicAuthenticationProvider.h"
#import "RFDigestAuthenticationProvider.h"
#import "RFDownloadFaker.h"
#import "RFDownloader.h"
#import "RFWebClientWithSharedHeader.h"
#import "RFWebServiceSerializer.h"
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

- (void)testServiceRootAttribute {
    RFWebServiceClientWithRoot *webServiceClientWithRoot = [[RFWebServiceClientWithRoot alloc] init];
    XCTAssertEqualObjects(webServiceClientWithRoot.serviceRoot, @"http://google.com", @"Service root was not initialized by a correct value from an attribute.");

    webServiceClientWithRoot = [[RFWebServiceClientWithRoot alloc] initWithServiceRoot:@"http://yahoo.com"];
    XCTAssertEqualObjects(webServiceClientWithRoot.serviceRoot, @"http://yahoo.com", @"Service root from attribute was not overrided by a init method parameter.");
}

- (void)testHTTPBasicAuthentication {
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    RFWebServiceClient *client = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://httpbin.org/"];
    client.authenticationProvider = [[RFBasicAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
    [client dynamicTestHttpRequestPath:@"basic-auth/user/passwd" success:^(id result) {
        isFinished = YES; /* reveived data ... */ 
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
}

- (void)testHTTPBasicAuthenticationInConjunctionWithSSL {
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    RFWebServiceClient *client = [[RFWebServiceClient alloc] initWithServiceRoot:@"https://httpbin.org/"];
    client.authenticationProvider = [[RFBasicAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];

    [client dynamicTestHttpsRequestPath:@"basic-auth/user/passwd" success:^(id result) {
        isFinished = YES; /* reveived data ... */
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
}

- (void)testHTTPDigestAuthentication {
    authenticationFinished = NO;
    __block BOOL isFinished = false;
    
    RFWebServiceClient *client = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://httpbin.org/"];
    client.authenticationProvider = [[RFDigestAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
    
    [client dynamicTestHttpRequestPath:@"digest-auth/auth/user/passwd" success:^(id result) {
        isFinished = YES; /* reveived data ... */
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
}

- (void)testHTTPDigestAuthenticationInConjunctionWithSSL {
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    RFWebServiceClient *client = [[RFWebServiceClient alloc] initWithServiceRoot:@"https://httpbin.org/"];
    client.authenticationProvider = [[RFDigestAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
    
    [client dynamicTestHttpsRequestPath:@"digest-auth/auth/user/passwd" success:^(id result) {
        isFinished = YES; /* reveived data ... */
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
}

- (void)testWebServiceManagement {
    RFConcreteWebServiceClient *client = [RFServiceProvider concreteWebServiceClient];
    XCTAssertTrue(client != nil, @"Concrete web service client was not created properly.");
    
    client.sharedHeaders = [@{@"key1" : @"value1"} mutableCopy];
    RFConcreteWebServiceClient *theSameClient = [RFServiceProvider concreteWebServiceClient];
    XCTAssertTrue([theSameClient.sharedHeaders count], @"Shared headers has not been saved.");
}

- (void)testSerializationRootAttribute {
    __block BOOL isFinished = NO;
    __block id requestResult = nil;
    
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://api.openweathermap.org/data/2.5/weather?q=London,uk"];
    [webClient testSerializationRootWithSuccess:^(id result) {
        requestResult = result;
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue([requestResult isKindOfClass:[NSNumber class]], @"Serialization root return wrong object");
}

- (void)testWrongSerializationRootAttribute {
    __block BOOL isFinished = NO;
    __block id requestResult = nil;
    
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://api.openweathermap.org/data/2.5/weather?q=London,uk"];
    [webClient testWrongSerializationRootWithSuccess:^(id result) {
        requestResult = result;
        isFinished = YES;
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:0.2]];
    }
    XCTAssertTrue(requestResult == nil, @"Wrong serialization root does not return null");
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

- (void)testSharedHeaderAttribute {
    RFWebClientWithSharedHeader *webClient = [[RFWebClientWithSharedHeader alloc] init];
    XCTAssertTrue([webClient.sharedHeaders isEqualToDictionary:@{@"key1" : @"value1"}], @"Shared headers was not configured via attributes");
}

- (void)testWebClientSerializationDelegateAttribute {
    RFWebClientWithSharedHeader *webClient = [[RFWebClientWithSharedHeader alloc] init];
    XCTAssertTrue([webClient.serializationDelegate isKindOfClass:[RFXMLSerializer class]], @"Serialization delegate was set incorrectly and has wrong type.");
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

- (void)testURLBuilderEncodingParameter {
    NSString *unprocessed = @"http://online.store.com/storefront/?request=get-document&doi=10.1175%2F1520-0426(2005)014%3C1157:DODADSS%3E2.0.CO%3B2";
    NSString *processed = [unprocessed stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:processed];
    RFDownloader *downloader = (RFDownloader *)[webClient testURLEscapingEncodingWithSuccess:nil failure:nil];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    [downloader cancel];

    XCTAssertEqualObjects([downloader.request.URL absoluteString], @"http://online.store.com/storefront/?request=get-document&doi=10.1175/1520-0426(2005)014%3C1157:DODADSS%3E2.0.CO;2", @"URL string escaping via encoding is done incorectly");
}

- (void)testURLBuilderAllowedCharsetParameter {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://PERSISTING.for.escaping"];
    RFDownloader *downloader = (RFDownloader *)[webClient testURLEscapingAllowedCharsetWithSuccess:nil failure:nil];

    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
    [downloader cancel];
    XCTAssertEqualObjects([downloader.request.URL absoluteString], @"%68%74%74%70%3A%2F%2FPERSISTING%2E%66%6F%72%2E%65%73%63%61%70%69%6E%67", @"URL string escaping via charset is done incorrectly!");
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

@end
