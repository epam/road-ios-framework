#Services

**Services** implements access of application-wide objects via [Service Locator](http://en.wikipedia.org/wiki/Service_locator_pattern) acting as a gathering and decorating point. Public interface exposed in `SFServiceProvider`.

##Registering a service

Registering a service requires 2 simple steps:

* Add category to `SFServiceProvider` with a getter for the service.
	
		@interface SFServiceProvider (SampleService)
		 
		- (id<SampleServiceInterface>)watchListService;
		 
		@end	

	`SampleServiceInterface` is a placeholder for any abstraction protocol to the service.
	
* Annotate getter with `SFService` **attribute** specifying service class.

		SF_ATTRIBUTE(SFService, serviceClass = [SampleService class])
		- (id<SampleServiceInterface>)watchListService;


##Access to services
Registry items can be accessed via `+ sharedProvider` singleton accessor of `SFServiceProvider`.


##Example

**Logger** shared instance created using *Service Locator* looks like:

	@interface SFServiceProvider (SFLogger)
	
	SF_ATTRIBUTE(SFService, serviceClass = [SFLogger class])
	- (id<SFLogging>)logger;
	
	@end

And used as:

	    id <SFLogging> logger = [[SFServiceProvider sharedProvider] logger];

##Dependencies

**Services** are build on top of **Attributes** to specify service class for each specific case.

`SFService` attribute with single 'serviceClass' property serves for this. `Class` object as a parameter value is passed.
