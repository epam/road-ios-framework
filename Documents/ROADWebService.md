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
* Then you need to implement `- (id<RFWebServiceCancellable>)authenticateWithSuccessBlock:(void(^)(id result))successBlock failureBlock:(void(^)(NSError *error))failureBlock;` method to make some steps to authenticate user on web service. In authentication process you can use `webServiceClient` property to reach web service client related to this provider. But we recommend to use another web client class only for authentication purposes in order to separate authentication logic (in majority of cases it will have different url and need different settings, so it makes sense).
The method returns an object that implements `RFWebServiceCancellable` protocol and allows you to cancel authentication process. You are responsible for creating the object in your implementation of `RFAuthenticating` and using it properly to cancel the process of authentication. We suggest you to implement `RFWebServiceCancellable` protocol in your Authentication Provider and return `self` from this method.
You don't have to finish authentication straight away (some authentication have few steps and can not be done immediately), but when you finished you need to notify client via appropriate block: success or failure.
`- (id<RFWebServiceCancellable>)authenticate;` should perform the same action but without callback blocks.
* You need to write some session invalidation logic and put it into `- (id<RFWebServiceCancellable>)invalidate;` method.
The method is assumed to be non-atomic, so it also returns an object that implements RFWebServiceCancellable protocol to let you cancel the process.
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

##Request processing
Users can modify the NSMutableURLRequest created during the invocation of dynamic methods by supplying an object conforming the RFWebserviceRequestProcessing protocol to the requestProcessor property of the instance. The protocol has only one mandatory method:
```objc
- (void)processRequest:(NSMutableURLRequest *)request attributesOnMethod:(NSArray *)attributes;
```
This method will be invoked with the generated NSMutableURLRequest and with all the attributes attached to the original stub method. Via this optional callback, one can completely customize the generated request.

See the following code from the related test for more info:

In the dynamic method definition stub file:
```objc
RF_ATTRIBUTE(RFWebServiceCall, method = @"GET", relativePath = @"/test")
- (id<RFWebServiceCancellable>)processingRequest:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;
```
In the code where the user is invoking the dynamic method:
```objc
RFRequestTestProcessor *testRequestProcessor = [[RFRequestTestProcessor alloc] init];
    RFWebServiceClient *client = [[RFWebServiceClient alloc] initWithServiceRoot:@"http://httpbin.org/"];
    
    client.requestProcessor = testRequestProcessor;
    
    [client processingRequest:^(id result) {
        /* succcess logic */
    } failure:^(NSError *error) {
        /* failure logic */
    }];
```


##Download Progress Tracking

Users can monitor and, if necessary, display the download process in the UI, using the `RFWebServiceClientDownloadProgressBlock`.

To use `RFWebServiceClientDownloadProgressBlock`, you need to pass it as one of the parameters. Then set the parameter index of the block in the `progressBlockParameter` (`RFWebServiceCall` attribute).

```objc
@property (assign, nonatomic) int progressBlockParameter;

RF_ATTRIBUTE(RFWebServiceCall, progressBlockParameter = 0)
- (id<RFWebServiceCancellable>)testDownloadingWithProgressBlock:(void(^)(float progress, long long expectedContentLenght))progressBlock
                                                        success:(void(^)(NSDictionary *albumsInfo))successBlock 
                                                        failure:(void(^)(NSError *error))failureBlock;
```

* `progress` - the download status with the value from 0.0 to 1.0;
* `expectedContentLenght` - the total size of your data downloads. Return `-1` if the size of query results are not known.

`RFWebServiceClientDownloadProgressBlock` is executed in the main thread and called at least 2 times:

* Once the request to web service is started (with parameters `(0. -1)` );
* Once the request to web service is finished (with parameters `(1, expectedContentLenght)` );
* Several times when new portion of data is downloaded.

Note: `RFWebServiceClientDownloadProgressBlock` should be placed before preparation, success and failure block, in order to work properly. 

```objc
RFWebServiceClient *webClient = [[RFWebServiceClient alloc] init];
[webClient downloadingWithProgressBlock:^(float progress, long long expectedContentLenght) {
	/* track your progress here */
} success:^(id response) {
     /* succcess logic */
} failure:^(NSError *error) {
     /* failure logic */
}];
```



[1]:./ROADLogger.md#predefined-logging-types
[2]:http://www.odata.org
