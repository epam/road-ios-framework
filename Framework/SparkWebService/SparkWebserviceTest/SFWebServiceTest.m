//
//  SFWebServiceTest.h
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

#import <Spark/SparkLogger.h>
#import "SFWebServiceTest.h"
#import "SFWebServiceClient+DynamicTest.h"
#import "SFAuthenticating.h"
#import "SFServiceProvider+ConcreteWebServiceClient.h"
#import "SFDownloader.h"

#import "SFBasicAuthenticationProvider.h"
#import "SFDigestAuthenticationProvider.h"

@interface SFWebServiceTest ()
{
    NSCondition * condition;
    BOOL authenticationFinished;
}
@end

@implementation SFWebServiceTest

- (void)testHTTPBasicAuthentication {
    //[[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://httpbin.org/"];
    client.authenticationProvider = [[SFBasicAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
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
    //[[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"https://httpbin.org/"];
    client.authenticationProvider = [[SFBasicAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];

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
    //[[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    authenticationFinished = NO;
    __block BOOL isFinished = false;
    
    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://httpbin.org/"];
    client.authenticationProvider = [[SFDigestAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
    
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
    //[[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"https://httpbin.org/"];
    client.authenticationProvider = [[SFDigestAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
    
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

//- (void)testAuthentication {
//    authenticationFinished = NO;
//    __block BOOL isFinished = false;
//    
//    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://ephubudw0817.budapest.epam.com:1337"];
//    client.authenticationProvider = [[SFBasicAuthenticationProvider alloc] initWithUser:@"epam" password:@"epam"];
//    client.authenticationProvider.successBlock = ^(id result) {
//        NSLog(@"%@", result);
//    };
//    client.authenticationProvider.failureBlock = ^(NSError *error) {
//        NSLog(@"%@", error);
//    };
//    [client dynamicDownloadTest:@"TestParameterValue" callbackBlock:^(id list, NSError *error) {
//        isFinished = YES;
//    }];
//    
//    while (!isFinished) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
//    
//    STAssertTrue([client.authenticationProvider isSessionOpened], @"Authentication was failed and session was not opened.");
//}
//
//
//- (void)testDynamicResolution {
//    
//    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://ephubudw0817.budapest.epam.com:1337"];
//    SFDownloader *request = [client dynamicDownloadTest:@"TestParameterValue" callbackBlock:^(id list, NSError *error) {
//    }];
//
//    sleep(1);
//    
//    STAssertTrue([[[request.request URL] absoluteString] hasSuffix:@"example=TestParameterValue"], @"Assertion: dynamic method resolution NOT works for GET parameter list");
//}
//
//
//- (void)testDownload {
//
//    __block BOOL isFinished = false;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//    
//        SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://ephubudw0817.budapest.epam.com:1337"];
//        [client downloadJSONWithCallbackBlock:^(id response, NSError *error) {
//            SFLogInternalError(@"response: %@ error: %@", response, error);
//            STAssertTrue(error == NULL, @"Assertion: download failing");
//            isFinished = YES;
//        }];
//        
//    });
//    while (!isFinished) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
//}
//
//- (void)testCancel {
//    __block BOOL isFinished = false;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://ephubudw0817.budapest.epam.com:1337"];
//        SFDownloader *request = [client dynamicDownloadTest:@"TestParameterValue" callbackBlock:^(id list, NSError *error) {
//            STAssertTrue(error.code == 1001, @"Assertation: Not cancelled");
//            isFinished = YES;
//        }];
//        [request cancel];
//    });
//    while (!isFinished) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
//}
//
//- (void)testDynamicHeaders {
//    __block BOOL isFinished = false;
//    __block BOOL prepareBlockExecuted = NO;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
//        SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://ephubudw0817.budapest.epam.com:1337"];
//        [client loadListWithHeaderValueForTestKey1:@"headerValue1"
//                                      prepareBlock:^(NSMutableURLRequest *serviceRequest) {
//                                          prepareBlockExecuted = YES;
//                                          NSMutableDictionary* headers = [[serviceRequest allHTTPHeaderFields] mutableCopy];
//                                          [headers setObject:@"headerValue2" forKey:@"testKey2"];
//                                          [serviceRequest setAllHTTPHeaderFields:headers];                                          
//                                          NSAssert([[[serviceRequest allHTTPHeaderFields] valueForKey:@"testKey1"] isEqual:@"headerValue1"], @"Assertion: Attributes dynamic header test failed");
//                                          NSAssert([[[serviceRequest allHTTPHeaderFields] valueForKey:@"testKey2"] isEqual:@"headerValue2"], @"Assertion: Changes in prepareBlock wasn't applied");
//                                      } completionBlock:^(id list, NSError *error) {
//                                          isFinished = YES;
//                                      }];        
//    });
//    while (!isFinished) {
//        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
//    }
//    NSAssert(prepareBlockExecuted, @"Assertion: PrepareBlock not called");
//}
//
- (void)testWebServiceManagement {
    SFConcreteWebServiceClient *client = [[SFServiceProvider sharedProvider] concreteWebServiceClient];
    STAssertTrue(client != nil, @"Concrete web service client was not created properly.");
    
    client.sharedHeaders = [@{@"key1" : @"value1"} mutableCopy];
    SFConcreteWebServiceClient *theSameClient = [[SFServiceProvider sharedProvider] concreteWebServiceClient];
    STAssertTrue([theSameClient.sharedHeaders count], @"Shared headers has not been saved.");
}

- (void)testSerializationRootAttribute {
    __block BOOL isFinished = NO;
    __block id requestResult = nil;
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://api.openweathermap.org/data/2.5/weather?q=London,uk"];
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
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://api.openweathermap.org/data/2.5/weather?q=London,uk"];
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
    [[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    
    __block BOOL isFinished = NO;
    __block NSError *receivedError;
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://services.odata.org/V3/(S(plcxuejnllfvrrecpvqbehxz))/OData/OData.svc/Product(1)"];
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
    [[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    
    __block BOOL isFinished = NO;
    __block NSError *receivedError;
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://services.odata.org/V3/(S(plcxuejnllfvrrecpvqbehxz))/OData/OData.svc/Product(1)"];
    SFAttachment *attachment = [[SFAttachment alloc] initWithName:@"image" fileName:@"imageName.jpg" data:[[NSData alloc] init]];
    [webClient testMultipartDataWithAttachment:attachment success:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        receivedError = error;
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
}

- (void)testMultipartDataArray {
    [[[SFServiceProvider sharedProvider] logger] addWriter:[SFConsoleLogWriter new]];
    
    __block BOOL isFinished = NO;
    __block NSError *receivedError;
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://services.odata.org/V3/(S(plcxuejnllfvrrecpvqbehxz))/OData/OData.svc/Product(1)"];
    NSArray *attachments = @[[[SFAttachment alloc] initWithName:@"image" fileName:@"imageName.jpg" data:[[NSData alloc] init]],
                             [[SFAttachment alloc] initWithName:@"image" fileName:@"imageName2.jpg" data:[[NSData alloc] init]]];
    [webClient testMultipartDataWithAttachments:attachments success:^(id result) {
        isFinished = YES;
    } failure:^(NSError *error) {
        receivedError = error;
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
    }
}

@end
