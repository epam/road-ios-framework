//
//  RFWebServiceTest.m
//  ROADWebService
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


#import <SenTestingKit/SenTestingKit.h>

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


@interface RFWebServiceTest : SenTestCase
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
    STAssertEqualObjects(webServiceClientWithRoot.serviceRoot, @"http://google.com", @"Service root was not initialized by a correct value from an attribute.");

    webServiceClientWithRoot = [[RFWebServiceClientWithRoot alloc] initWithServiceRoot:@"http://yahoo.com"];
    STAssertEqualObjects(webServiceClientWithRoot.serviceRoot, @"http://yahoo.com", @"Service root from attribute was not overrided by a init method parameter.");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    STAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    STAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    STAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    STAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
}

- (void)testWebServiceManagement {
    RFConcreteWebServiceClient *client = [RFServiceProvider concreteWebServiceClient];
    STAssertTrue(client != nil, @"Concrete web service client was not created properly.");
    
    client.sharedHeaders = [@{@"key1" : @"value1"} mutableCopy];
    RFConcreteWebServiceClient *theSameClient = [RFServiceProvider concreteWebServiceClient];
    STAssertTrue([theSameClient.sharedHeaders count], @"Shared headers has not been saved.");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
    STAssertTrue([requestResult isKindOfClass:[NSNumber class]], @"Serialization root return wrong object");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    STAssertTrue(requestResult == nil, @"Wrong serialization root does not return null");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    
    STAssertTrue(receivedError != nil, @"Error've not been generated!");
    STAssertTrue(receivedError.localizedDescription != nil, @"Localized description've not been filled for generated error!");
    STAssertTrue(receivedError.code, @"Code've not been filled for generated error!");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    
    STAssertTrue(isSuccess, @"Multipart form data request is failed");
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
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    
    STAssertTrue(isSuccess, @"Multipart form data request is failed");
}

- (void)testNilsInCompletionBlocks {
    RFConcreteWebServiceClient *webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.method.without.blocks"];
    RFFormData *attachment = [[RFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"];
    [webClient testMultipartDataWithAttachment:attachment success:nil failure:nil];
    
    __block BOOL isFinished = NO;
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
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
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
    
    STAssertTrue(isSuccess, @"Custom serialization of web service request is failed!");
    STAssertTrue([testObject isEqual:customSerializationResult], @"Custom deserialization of web service response is failed!");
}

- (void)testSharedHeaderAttribute {
    RFWebClientWithSharedHeader *webClient = [[RFWebClientWithSharedHeader alloc] init];
    STAssertTrue([webClient.sharedHeaders isEqualToDictionary:@{@"key1" : @"value1"}], @"Shared headers was not configured via attributes");
}

- (void)testWebClientSerializationDelegateAttribute {
    RFWebClientWithSharedHeader *webClient = [[RFWebClientWithSharedHeader alloc] init];
    STAssertTrue([webClient.serializationDelegate isKindOfClass:[RFXMLSerializer class]], @"Serialization delegate was set incorrectly and has wrong type.");
}

@end
