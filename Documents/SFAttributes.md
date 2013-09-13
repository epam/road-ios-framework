#Attributes

Component implements Attribute-Oriented Programming paradigm in Objective-C. It allows to add various metadata to the class, each method, property or ivar of the class. 

E.g.

	@property (nonatomic, strong) NSDate *birthdayDate;

of some "Person" class could be annotated with "serializable"and format attributes to know whether and how to store object on disk.

	SF_ATTRIBUTE(SFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z", encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z")
	@property (nonatomic, strong) NSDate *birthdayDate;

Or attribute can declare particular class for logging service creation.  
	
	@interface SFServiceProvider (SFLogger)

	SF_ATTRIBUTE(SFService, serviceClass = [SFLogger class])
	- (id<SFLogging>)logger;
	..

In general attributes mark program elements (methods, properties and ivars) to indicate that they maintain specific application or domain semantics. Which is one more elegant way to separates business logic from app-specific semantics.

##Adding existing attributes to classes.

`SF_ATTRIBUTE` macro above the method declaration used to annotate a property, method or ivar with existing attributes.

	SF_ATTRIBUTE(AttributeClass, param1 = value1, param2 = value2, ..)
	- methodName;

where `AttributeClass` is a Objective-C class name representing particular attribute followed by attribute properties.

## Parameters

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
