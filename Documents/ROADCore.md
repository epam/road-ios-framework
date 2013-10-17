#Core
Basement for the ROAD framework consisting of 3 major parts:

* [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) implementation in Objective-C
* [Reflection](""http://en.wikipedia.org/wiki/Reflection_(computer_programming)") pattern implementation to make **Attributes** possible
* Set of helper extensions on Foundation classes.

#Attributes

Component implements [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) paradigm in Objective-C. It allows to add various metadata to the class, each method, property or ivar of the class. 

Following basic example annotates `birthday` property with "serializable" and format attributes to know whether and how to store object on disk.

	RF_ATTRIBUTE(RFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z", encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z")
	@property (nonatomic, strong) NSDate *birthdayDate;

In other case attribute defines particular class for logging service creation.  
	
	@interface RFServiceProvider (RFLogger)

	RF_ATTRIBUTE(RFService, serviceClass = [RFLogger class])
	- (id<RFLogging>)logger;
	..

But in general attributes mark program elements (methods, properties and ivars) to indicate that they maintain specific application or domain semantics. Which is one more elegant way to separates business logic from app-specific semantics.

##Adding existing attributes to classes.

`RF_ATTRIBUTE` macro above the method declaration used to annotate a property, method or ivar with existing attributes.

	RF_ATTRIBUTE(Class, param1 = value1, param2 = value2, ..)
	- methodName;

where `Class` is a name of any Objective-C representing particular attribute followed by it's properties.

##Parameters

Parameters can get values with String:

	RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, relativePath = @"%%0%%")
	
Array:

	RF_ATTRIBUTE(RFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])

or Dictionary type:

	RF_ATTRIBUTE(RFWebServiceHeader, hearderFields = @[@"Accept", @"application/json"])


##Compiling project with attributes.
Usage of attributes requires addition of code generation phase for build process. To do this:

- Add "Run Script" build phase to the target
- Add line with path to ROADAttributesCodeGenerator tool and path to your attributes:

E.g.

	"${SRCROOT}/../../tools/binaries/ROADAttributesCodeGenerator" -src="${SRCROOT}/" -dst="${SRCROOT}/ROADWebserviceTest/ROADGeneratedAttributes/"

Script generates support code for the classes where attributes are defined and adds 'em as files with categories to the classes in the specified `-dst` folder.

##Accesing attributes from code. 

API for accessing attributes from code declared in NSObject+RFAttributes.h. First group of methods returns all attributes for specific method:

	+ (NSArray *)attributesForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)attributesForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)attributesForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)attributesForClassWithAttributeType:(Class)requiredClassOfAttribute;

Second group allows reverse fetch:

	+ (NSArray *)propertiesWithAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)ivarsWithAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)methodsWithAttributeType:(Class)requiredClassOfAttribute;

E.g getting of the header for web service will like:

    RFWebServiceHeader * const headerAttribute = [[_webServiceClient class] attributeForMethod:_methodName withAttributeType:[RFWebServiceHeader class]];
    
    
##Creating custom attributes

Adding own custom attributes to the project is simple and straightforward. Subclass `NSObject` and declare attribute properies. To use it reference to it's classname in `RF_ATTRIBUTE` macro. 

##Attributes in ROAD 

Modules from the framework take advantage of the annotation model and define their own attributes:

**Logger**

* RFLoggerWebServicePath - define URL for web service

**Serialization**

* RFDerived - 'do not serialize' for property in a serializable class
* RFSerializable - mark as serializable (property or class-wide)
* RFSerializableCollection - mark property as containing collection of serializable items
* RFSerializableDate - define format for serializable NSDate property or for all date properties if applied to class 

**Services**

* RFService - define class for the service

**WebService**

* RFWebServiceCall - set specification for used service calls
* RFWebServiceClientStatusCodes - list calls status codes
* RFWebServiceErrorHandler - define error handler class
* RFWebServiceHeader - list fields of the header
* RFWebServiceLogger - define type of logging
* RFWebServiceURLBuilder - define url builder class
* RFWebServiceURLBuilderParameter

Detailed information on attributes can be found in corresponding documentation pages and API reference.

#Reflection

[Reflection](""http://en.wikipedia.org/wiki/Reflection_(computer_programming)") provides API to access to class metadata on ivars, methods and properties by wrapping low-level Objective-C runtime functions.

API is divided into `NSObject` categories: 

1. `MemberVariableReflection`
2. `MethodReflection`
3. `PropertyReflection`

**1. MemberVariableReflection**

It's possible to get all ivars all specific one by it's name wrapped into `RFIvarInfo` class.

	+ (RFIvarInfo *)ivarNamed:(NSString *)name;
	+ (NSArray *)ivars;

Convenience object methods provide equal results.

	- (RFIvarInfo *)ivarNamed:(NSString *)name;
	- (NSArray *)ivars;

**2. MethodReflection**

To get class or object methods use:

	- (RFMethodInfo *)classMethodForName:(NSString *)methodName;
	- (RFMethodInfo *)instanceMethodForName:(NSString *)methodName;
	
or

	- (NSArray *)methods;
	+ (NSArray *)methods;

which will return array of `RFMethodInfo` objects.  
*Methods of superclasses are not included in the list.*

**3. PropertyReflection**

Properties list accessed in the very same way:

	- (RFPropertyInfo *)propertyNamed:(NSString *)name;
	- (NSArray * const)properties;

operating with results of `RFPropertyInfo*` type.

Since there are no properties for classes, convenience class methods will return the same result.

