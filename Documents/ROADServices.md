#Services

**Services** implements access of application-wide objects via [Service Locator](http://en.wikipedia.org/wiki/Service_locator_pattern) acting as a gathering and decorating point. Public interface exposed in `RFServiceProvider`.

##Registering a service

Registering a service requires 2 simple steps:

* Add category to `RFServiceProvider` with a getter for the service.
  
  ```objc
@interface SFServiceProvider (SampleService)
- (id<SampleServiceInterface>)watchListService;
@end	
  ```
	`SampleServiceInterface` is a placeholder for any abstraction protocol to the service.
	
* Annotate getter with `RFService` **attribute** specifying service class.
  ```objc
RF_ATTRIBUTE(RFService, serviceClass = [SampleService class])
- (id<SampleServiceInterface>)watchListService;
  ```

##Example

**Logger** shared instance created using *Service Locator* looks like:
```objc
#import <ROAD/ROADServices.h>
#import "RFLogger.h"

@interface RFServiceProvider (LoggingService)

RF_ATTRIBUTE(RFService, serviceClass = [RFLogger class])
+ (id<RFLogging>)logger;

@end
```
And used as:
```objc
id <RFLogging> logger = [RFServiceProvider logger];
```
##Dependencies

**Services** are build on top of **Attributes** to specify service class for each specific case.

`RFService` attribute with single 'serviceClass' property serves for this. `Class` object as a parameter value is passed.