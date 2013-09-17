#Web Services

Component strikes to provide zero-coding client to remote web services by annotating responsible classes with specific  **SFAttributes**.

It features:

* Basic & digest authentication
* Custom HTTP Headers configuration
* Multipart data
* On-fly serialization and deserialization
* Error handling
* Direct logging to remote server
* Open Data Protocol support

Web Services are represented by `SFWebServiceClient`. Instance is created in place or used as a shared service via **SFServices**.

Snippet below illustrates basic authentication:

    authenticationFinished = NO;
    __block BOOL isFinished = NO;
    
    SFWebServiceClient *client = [[SFWebServiceClient alloc] initWithServiceRoot:@"http://httpbin.org/"];
    client.authenticationProvider = [[SFBasicAuthenticationProvider alloc] initWithUser:@"user" password:@"passwd"];
    [client dynamicTestHttpRequestPath:@"basic-auth/user/passwd" success:^(id result) {
        isFinished = YES; /* received data ... */ 
    } failure:^(NSError *error) {
        isFinished = YES;
    }];
    
    while (!isFinished) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }

##Architecture
Core idea of API is to reduce amount of customization code. This is achieved by taking advantage of dynamic method invocation in Objective-C runtime in conjunction with Attribute-Oriented paradigm. 
Custom annotated methods are added to subclass or category on `SFWebServiceClient`. Template for dynamic methods is as follows:

	- (id<SFWebServiceCancellable>)[param1:(NSString *)param1 ... paramN:(NSString*)paramN]
                          [prepareBlock:(void(^)(NSMutableURLRequest* serviceRequest)requestBlock]
                        completionBlock:(void(^)(id object, NSError *error))callbackBlock;

All specified params are passed to method attributes which support wildcards:

* `ESDWebServiceCall`
* `ESDWebServiceHeader`

e.g. 

	SFWebServiceHeader(headerKey1 : %%0%%)]

means that first method parameter will used as value for `headerKey1` key 

`dynamicTestHttpRequestPath` from **Snippet** is not implemented actually. It is defined and annotated in `SFWebServiceClient` interface to give client a clue what to do when invoked.

	SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = YES, method = @"GET", relativePath = @"%%0%%")
	- (id<SFWebServiceCancellable>)dynamicTestHttpRequestPath:(NSString *)path success:(void(^)(id result))successBlock failure:(void(^)(NSError *error))failureBlock;

`SFWebServiceCall` configures that method implementing remote request should return result data as is (no deserialization), and request type is "GET".

##Interface

`SFWebServiceClient` interface is tiny and self-documented:

	@interface SFWebServiceClient : SFService
	
	@property (strong, nonatomic) id<SFSerializationDelegate> serializationDelegate;
	@property (copy, nonatomic) NSString *serviceRoot;
	@property (strong, atomic) NSMutableDictionary *sharedHeaders;
	@property (strong, nonatomic) id<SFAuthenticating> authenticationProvider;
	
	- (id)initWithServiceRoot:(NSString *)serviceRoot;
	
	@end
	
##Defined Attributes

* `ESDWebServiceClientStatusCodes`. Specify valid status for the client. Class-level only.
* `SFWebServiceCall`. Request description. 
	- List valid status codes of response for annotated method (array of `NSNumber` or `NSValue` range values);
	- Define whether locally defined status codes override global values;
	- Define HTTP method;
	- Whether result should be deserialized (Allowed by default); 
	- Prototype class for deserialization;
* `SFWebServiceHeader`. Define HTTP headers for request.
* `SFWebServiceLogger`. Define logging for request.
* `SFWebServiceErrorHandler`. Define class for error handler instance.
* `SFWebServiceURLBuilder`. Define class for request URL builder.
* `SFWebServiceURLBuilderParameter`. Marks class as a parameter for URL builder.
* `SFMultipartData`. Set boundaries for multipart data

##Basic & digest authentication
Authentication is implemented one by one of the providers:

* SFBasicAuthenticationProvider
* SFDigestAuthenticationProvider

by setting it to web client's `authenticationProvider` property.

##Headers customization
Header fields can be customized by addding `SFWebServiceHeader` to request definition:

	SF_ATTRIBUTE(SFWebServiceHeader, hearderFields = @{@"Accept" : @"application/json"})
	
##Multipart data
Requests with multipart data results are marked with `SFMultipartData` with customizable `boundary` string.

##On-fly serialization and deserialization
If client's property `serializationDelegate` is set to `id<SFSerializationDelegate>` instance it is asked to serialize objects passed as request parameters.

Deserialization of request result is automatically done by the same `serializationDelegate` and passed to callback block.

Default serializer uses `SFAttributedCoder` and attempts to performs deserialization from JSON data.

##Error handling
Implemented by `SFWebServiceErrorHandler` attribute and applied to request. Error handler should conform to `SFWebServiceErrorHandling` protocol and implement

	+ (id)validateResponse:(NSURLResponse *)response withData:(NSData *)data;

returning `NSError` object on error.

##Direct logging to remote server

Logging is implemented by `SFWebServiceLogger` and extends `SFLogger` with remote logging functionality.


##Open Data Protocol support
Web service partially implements [Open Data Protocol](http://en.wikipedia.org/wiki/Open_Data_Protocol) specification.

Example below initializes request with `entityName` and handles result in a callback block.  

    webClient = [[SFConcreteWebServiceClient alloc] initWithServiceRoot:@"http://fakeurl.com/mashups/mashupengine"];
    
    SFODataFetchRequest *fetchRequest = [[SFODataFetchRequest alloc] initWithEntityName:[SFODataTestEntity entityName]];

	[webClient loadDataWithFetchRequest:fetchRequest success:^(id result) {
		// Success
    } failure:^(NSError *error) {
        // Failure
    }];