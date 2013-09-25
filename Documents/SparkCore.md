#Core
Basement for the Spark framework consisting of 3 major parts:

* [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) implementation in Objective-C
* [Reflection](""http://en.wikipedia.org/wiki/Reflection_(computer_programming)") pattern implementation to make **Attributes** possible
* Set of helper extensions on Foundation classes.

#Attributes

Component implements [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) paradigm in Objective-C. It allows to add various metadata to the class, each method, property or ivar of the class. 

Following basic example annotates `birthday` property with "serializable" and format attributes to know whether and how to store object on disk.

	SF_ATTRIBUTE(SFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z", encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z")
	@property (nonatomic, strong) NSDate *birthdayDate;

In other case attribute defines particular class for logging service creation.  
	
	@interface SFServiceProvider (SFLogger)

	SF_ATTRIBUTE(SFService, serviceClass = [SFLogger class])
	- (id<SFLogging>)logger;
	..

But in general attributes mark program elements (methods, properties and ivars) to indicate that they maintain specific application or domain semantics. Which is one more elegant way to separates business logic from app-specific semantics.

##Adding existing attributes to classes.

`SF_ATTRIBUTE` macro above the method declaration used to annotate a property, method or ivar with existing attributes.

	SF_ATTRIBUTE(Class, param1 = value1, param2 = value2, ..)
	- methodName;

where `Class` is a name of any Objective-C representing particular attribute followed by it's properties.

##Parameters

Parameters can get values with String:

	SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = NO, relativePath = @"%%0%%")
	
Array:

	SF_ATTRIBUTE(SFWebServiceCall, serializationDisabled = NO, serializationRoot = @"coord.lon", successCodes = @[[NSValue valueWithRange:NSMakeRange(200, 300)]])

or Dictionary type:

	SF_ATTRIBUTE(SFWebServiceHeader, hearderFields = @[@"Accept", @"application/json"])


##Compiling project with attributes.
Usage of attributes requires addition of code generation phase for build process. To do this:

- Add "Run Script" build phase to the target
- Add line with path to SparkAttributesCodeGenerator tool and path to your attributes:

E.g.

	"${SRCROOT}/../../tools/binaries/SparkAttributesCodeGenerator" -src="${SRCROOT}/" -dst="${SRCROOT}/SparkWebserviceTest/SparkGeneratedAttributes/"

Script generates support code for the classes where attributes are defined and adds 'em as files with categories to the classes in the specified `-dst` folder.

##Accesing attributes from code. 

API for accessing attributes from code declared in NSObject+SFAttributes.h. First group of methods returns all attributes for specific method:

	+ (NSArray *)attributesForMethod:(NSString *)methodName withAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)attributesForProperty:(NSString *)propertyName withAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)attributesForIvar:(NSString *)ivarName withAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)attributesForClassWithAttributeType:(Class)requiredClassOfAttribute;

Second group allows reverse fetch:

	+ (NSArray *)propertiesWithAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)ivarsWithAttributeType:(Class)requiredClassOfAttribute;
	+ (NSArray *)methodsWithAttributeType:(Class)requiredClassOfAttribute;

E.g getting of the header for web service will like:

    SFWebServiceHeader * const headerAttribute = [[_webServiceClient class] attributeForMethod:_methodName withAttributeType:[SFWebServiceHeader class]];
    
    
##Creating custom attributes

Adding own custom attributes to the project is simple and straightforward. Subclass `NSObject` and declare attribute properies. To use it reference to it's classname in `SF_ATTRIBUTE` macro. 

##Attributes in Spark 

Modules from the framework take advantage of the annotation model and define their own attributes:

**Logger**

* SFLoggerWebServicePath - define URL for web service

**Serialization**

* SFDerived - 'do not serialize' for property in a serializable class
* SFSerializable - mark as serializable (property or class-wide)
* SFSerializableCollection - mark property as containing collection of serializable items
* SFSerializableDate - define format for serializable NSDate property or for all date properties if applied to class 

**Services**

* SFService - define class for the service

**WebService**

* SFWebServiceCall - set specification for used service calls
* SFWebServiceClientStatusCodes - list calls status codes
* SFWebServiceErrorHandler - define error handler class
* SFWebServiceHeader - list fields of the header
* SFWebServiceLogger - define type of logging
* SFWebServiceURLBuilder - define url builder class
* SFWebServiceURLBuilderParameter

Detailed information on attributes can be found in corresponding documentation pages and API reference.

#Reflection

[Reflection](""http://en.wikipedia.org/wiki/Reflection_(computer_programming)") provides API to access to class metadata on ivars, methods and properties by wrapping low-level Objective-C runtime functions.

API is divided into `NSObject` categories: 

1. `MemberVariableReflection`
2. `MethodReflection`
3. `PropertyReflection`

**1. MemberVariableReflection**

It's possible to get all ivars all specific one by it's name wrapped into `SFIvarInfo` class.

	+ (SFIvarInfo *)ivarNamed:(NSString *)name;
	+ (NSArray *)ivars;

Convenience object methods provide equal results.

	- (SFIvarInfo *)ivarNamed:(NSString *)name;
	- (NSArray *)ivars;

**2. MethodReflection**

To get class or object methods use:

	- (SFMethodInfo *)classMethodForName:(NSString *)methodName;
	- (SFMethodInfo *)instanceMethodForName:(NSString *)methodName;
	
or

	- (NSArray *)methods;
	+ (NSArray *)methods;

which will return array of `SFMethodInfo` objects.  
*Methods of superclasses are not included in the list.*

**3. PropertyReflection**

Properties list accessed in the very same way:

	- (SFPropertyInfo *)propertyNamed:(NSString *)name;
	- (NSArray * const)properties;

operating with results of `SFPropertyInfo*` type.

Since there are no properties for classes, convenience class methods will return the same result.

