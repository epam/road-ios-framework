//
//  SFWebServiceTest.m
//  SparkWebService
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
#import "SFDownloader+FakeRequest.h"

#import "SFBasicAuthenticationProvider.h"
#import "SFDigestAuthenticationProvider.h"
#import <objc/runtime.h>

@interface SFWebServiceTest ()
{
    NSCondition * condition;
    BOOL authenticationFinished;
}
@end

@implementation SFWebServiceTest

+ (void)setUp {
    [[SFServiceProvider logger] addWriter:[SFConsoleLogWriter new]];
    
    SEL originalSelector = @selector(start);
    SEL overrideSelector = @selector(fakeStart);
    Method originalMethod = class_getInstanceMethod([SFDownloader class], originalSelector);
    Method overrideMethod = class_getInstanceMethod([SFDownloader class], overrideSelector);
    method_exchangeImplementations(originalMethod, overrideMethod);
}

- (void)testHTTPBasicAuthentication {
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

- (void)testWebServiceManagement {
    SFConcreteWebServiceClient *client = [SFServiceProvider concreteWebServiceClient];
    STAssertTrue(client != nil, @"Concrete web service client was not created properly.");
    
    client.sharedHeaders = [@{@"key1" : @"value1"} mutableCopy];
    SFConcreteWebServiceClient *theSameClient = [SFServiceProvider concreteWebServiceClient];
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
    __block BOOL isFinished = NO;
    __block BOOL isSuccess = NO;
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.multipart.data"];
    SFFormData *attachment = [[SFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"];
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
    
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.multipart.data"];
    NSArray *attachments = @[[[SFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"],
                             [[SFFormData alloc] initWithName:@"image" data:[@"Random data 2" dataUsingEncoding:NSUTF8StringEncoding]],
                             [[SFFormData alloc] initWithName:@"image" data:[@"Random data 3" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName2.jpg"]];
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
    SFConcreteWebServiceClient *webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://test.method.without.blocks"];
    SFFormData *attachment = [[SFFormData alloc] initWithName:@"image" data:[@"Random data 1" dataUsingEncoding:NSUTF8StringEncoding] fileName:@"imageName.jpg"];
    [webClient testMultipartDataWithAttachment:attachment success:nil failure:nil];
    
    __block BOOL isFinished = NO;
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[[NSDate alloc] initWithTimeIntervalSinceNow:1]];
        isFinished = YES;
    }
}

@end
