#Web Service

Component strikes to provide zero-coding client to remote web services by annotating responsible classes with specific  **RFAttributes**.

It features:

* Basic & digest authentication
* Custom HTTP Headers configuration
* Multipart data
* On-fly serialization and deserialization
* Error handling
* Direct logging to remote server
* [Open Data Protocol][2] support

Web Services are represented by `RFWebServiceClient`. Instance is created in place or used as a shared service via **RFServices**.

Snippet below illustrates basic authentication (this example of the code you can see in tests for ROADWebService project):

**RFWebServiceClient+DynamicTest.h**
```objc
#import <ROAD/ROADWebservice.h>

@interface RFWebServiceClient (DynamicTest)

RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES, method = @"GET", relativePath = @"%%0%%")
- (id<RFWebServiceCancellable>)dynamicTestHttpRequestPath:(NSString *)path success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

@end
```
**Implementation of authentication logic:**
```objc
#import "RFWebServiceClient+DynamicTest.h"
	
... 	
- (void)authentication {
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
  	if ([client.authenticationProvider isSessionOpened]) {
      	// Session is opened. You can write your code here.
  	}
}
```
##Architecture
Core idea of API is to reduce amount of customization code. This is achieved by taking advantage of dynamic method invocation in Objective-C runtime in conjunction with Attribute-Oriented paradigm. 
Custom annotated methods are added to subclass or category on `RFWebServiceClient`. Template for dynamic methods is as follows:
```objc
- (id<RFWebServiceCancellable>)[param1:(NSString *)param1 ... paramN:(NSString*)paramN]
                      [prepareBlock:(void(^)(NSMutableURLRequest* serviceRequest)requestBlock]
                      success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;
```
All specified params are passed to method attributes which support wildcards:

* `RFWebServiceCall`
* `RFWebServiceHeader`

e.g. 
```objc
RF_ATTRIBUTE(RFWebServiceHeader, headerFields = @{ @"headerKey1" : @"%%0%%@"})
```
means that first method parameter will used as value for `headerKey1` key 

`dynamicTestHttpRequestPath` from **Snippet** has no implementation actually. It is defined and annotated in `RFWebServiceClient` interface to give client a clue what to do when invoked.
```objc
RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = YES, method = @"GET", relativePath = @"%%0%%")
- (id<RFWebServiceCancellable>)dynamicTestHttpRequestPath:(NSString *)path success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;
```
`RFWebServiceCall` configures that method implementing remote request should return result data as is (no deserialization), and request type is `GET`.

##Interface

`RFWebServiceClient` interface is tiny and self-documented:
```objc
@interface RFWebServiceClient : RFService
	
@property (copy, nonatomic) NSString *serviceRoot;
@property (strong, atomic) NSMutableDictionary *sharedHeaders;
@property (strong, nonatomic) id<RFSerializationDelegate> serializationDelegate;
@property (strong, nonatomic) id<RFAuthenticating> authenticationProvider;
@property (strong, nonatomic) id<RFWebServiceRequestProcessing> requestProcessor;
	
- (id)initWithServiceRoot:(NSString *)serviceRoot;
	
@end
```
##Defined Attributes

* `RFWebServiceClientStatusCodes`. Specify valid status for the client. Class-level only.
* `RFWebServiceCall`. Request description. 
    - `relativePath` - Specify path relative to service root of web service client for current method;
	- `successCodes` - List valid status codes of response for annotated method (array of `NSNumber` or `NSValue` range values);
	- `overrideGlobalSuccessCodes` - Define whether locally defined status codes override global values;
	- `method` - Define HTTP method;
	- `serializationRoot` - Whether result should be deserialized (Allowed by default); 
	- `prototypeClass` - Prototype class for deserialization;
	- `postParameter` - Specify number of parameter which will be user as HTTP request body. Numeration starts from 0.
* `RFWebServiceHeader`. Define HTTP headers for request.
* `RFWebServiceLogger`. Define logging for request. Types listed [here][1].
* `RFWebService`. Attribute for web service client class. It allows to specify service root URL.
* `RFWebServiceErrorHandler`. Define class for error handling. This handler class must implement protocol `RFWebServiceErrorHandling`
* `RFWebServiceURLBuilder`. Define class for request URL builder.
* `RFWebServiceURLBuilderParameter`. Marks class as a parameter for URL builder. It will not be serialized or altered with standard mechanism. 
* `RFMultipartData`. Set boundaries and, in future, other parameter of multipart request.
* `RFWebServiceSerializer`. Specify custom request serializer. Serializer class must conform `RFSerializationDelegate` protocol.
* `RFWebServiceCache`. Alter standard behaviour of caching HTTP responses.
    - `maxAge` - Cache expiration time for marked web response.
    - `cacheDisabled` - Disables caching for marked web request.

##Basic & digest authentication
Authentication is implemented one by one of the providers:

* `RFBasicAuthenticationProvider`;
* `RFDigestAuthenticationProvider`.

by setting it to web client's `authenticationProvider` property.

##Custom authentication
The very common case is to implement protocol `RFAuthenticating`. The main idea behind it is following:

* You implement custom init method to supply your provider with necessary data.
* Then you need to implement `- (void)authenticateWithSuccessBlock:(void(^)(id result))successBlock failureBlock:(void(^)(NSError *error))failureBlock;` method to make some steps to authenticate user on web service. In authentication process you can use `webServiceClient` property to reach web service client related to this provider. But we recommend to use another web client class only for authentication purposes in order to separate authentication logic (in majority of cases it will have different url and need different settings, so it makes sense).
You don't have to finish authentication straight away (some authentication have few steps and can not be done immediately), but when you finished you need to notify client via appropriate block: success or failure.
`- (void)authenticate;` should perform the same action but without callback blocks.
* You need to write some session invalidation logic and put it into `- (void)invalidate;` method.
* Optionally you can implement `- (BOOL)isSessionOpened;` to return current state of authentication.
* You can check problems with authentication in `- (void)checkResponse:(NSURLResponse *)response forConnection:(NSURLConnection *)connection;`. This method will be performed after every response from web service client, authentication provider works with.
* If you authentication provider need to analyze and respond to authentication challenges, you need to implement `- (void)processAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge forConnection:(NSURLConnection *)connection;`.
* If you need to modify somehow request data every time you can implement `- (void)addAuthenticationDataToRequest:(NSMutableURLRequest *)request;`.

Or you can implement custom authentication based on one of following classes: 

* `RFAuthenticationProvider`. Has session invalidation in case of authentication challenge in `-processAuthenticationChallenge:`, convenient methods to invoke and release callback blocks and so on.
* `RFConcurrentAuthenticationProvider`, based on `RFAuthenticationProvider` and implements concurrent invocation of `-authenticate` method.
* Or even on top of `RFBasicAuthenticationProvider` or `RFDigestAuthenticationProvider`.

##Headers customization
Header fields can be customized by addding `RFWebServiceHeader` to request definition:
```objc
RF_ATTRIBUTE(RFWebServiceHeader, hearderFields = @{@"Accept" : @"application/json"})
```

In case, there's need to have the same headers in every request in one specific web service client. These header fields can be set in `sharedHeaders` propery of your web service client instance.

##Multipart data
Request is counted as multipart data request if it has `RFFormData` parameters in method declaration. 
`RFFormData` has set of basic parameters:

* name;
* data;
* fileName (*optional*);
* contentType (*optional*). Default value is `application/octet-stream`.

Multipart request builder will use these parameter to create request like this:
```objc
@"\r\n--boundary\r\n" // boundary some random boundary or boundary string from attribute RFMultipartData
@"Content-Disposition: form-data; name=\"name\"; filename=\"fileName\"\r\n" // name and fileName from RFFormData
@"Content-Type: contentType\r\n\r\n" // contentType from RFFormData parameter
... data ... // data from data property of RFFormData parameter
@"\r\n--boundary\r\n"
// Next parameter
```

Requests with multipart data can be marked with `RFMultipartData` with customizable `boundary` string.
RFFormData instances could be embedded in `NSArray` container.

##On-fly serialization and deserialization
If client's property `serializationDelegate` is set to `id<RFSerializationDelegate>` instance it is asked to serialize objects passed as request parameters.
Deserialization of request result is automatically done by the same `serializationDelegate` and passed to callback block.

Default serializer uses `RFAttributedCoder` and attempts to performs deserialization from JSON data.

`serializationDelegate` can be specified via attributes too. For example, let's change default JSON serialization/deserializaton on XML:

```objc
RF_ATTRIBUTE(RFWebServiceSerializer, serializerClass = [RFXMLSerializer class])
```


##Error handling
Implemented by `RFWebServiceErrorHandler` attribute and applied to request. Error handler should conform to `RFWebServiceErrorHandling` protocol and implement
```objc
+ (id)validateResponse:(NSURLResponse *)response withData:(NSData *)data;
```
and return `NSError` object on error.
Example of custom error handling is OData error handler - `RFODataErrorHandler`.

##Direct logging to remote server

Logging is implemented by `RFWebServiceLogger` and extends `RFLogger` with remote logging functionality.

##Web Service Caching

By default web service client will cache data getting into account standard rules of HTTP protocol caching. Web service client react on following headers:

* Pragma
* Cache-Control
* Expires
* ETag
* Last-Modified

This behaviour can be modified via `RFWebServiceCache` attribute.

##Open Data Protocol support
Web service partially implements [Open Data Protocol](http://en.wikipedia.org/wiki/Open_Data_Protocol) specification.

Example below initializes request with `entityName` and handles result in a callback block.  
```objc
webClient = [[RFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://fakeurl.com/mashups/mashupengine"];
    
RFODataFetchRequest *fetchRequest = [[RFODataFetchRequest alloc] initWithEntityName:[RFODataTestEntity entityName]];

[webClient loadDataWithFetchRequest:fetchRequest success:^(id result) {
  // Success
} failure:^(NSError *error) {
  // Failure
}];
```
```objc
@interface RFConcreteWebServiceClient : RFWebServiceClient
...
RF_ATTRIBUTE(RFWebServiceCall)
RF_ATTRIBUTE(RFWebServiceHeader, hearderFields = @{@"Accept": @"application/json"})
RF_ATTRIBUTE(RFWebServiceURLBuilder, builderClass = [RFODataWebServiceURLBuilder class])
- (id<RFWebServiceCancellable>)loadDataWithFetchRequest:(RFODataFetchRequest *)fetchRequest success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;
...
@end
```

[1]:./ROADLogger.md#predefined-logging-types
[2]:http://www.odata.org
