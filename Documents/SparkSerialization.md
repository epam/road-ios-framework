#Serialization

**Attribute**-based JSON and XML serializers. 

#1. JSON

Component takes advantages of properties annotations to define  serialization options with **SFAttribute**s.

Encoding and decoding entry points are provided by correspondening classes: 

* `SFAttributedCoder` encodes serializable object into JSON stored in `NSString`, `NSData` or `NSDictionary`. 
		+ (id)encodeRootObject:(id const)rootObject;
		…
	
* `SFAttributedDecoder` acts in a reverse direction.
		 + (id)decodeJSONString:(NSString * const)jsonString;
		…

Where by *serializable object* meant any `NSObject` subclass with serialization attributes defined.

##Defined Attributes

* `SFDerived`. Annotates property to mark it as 'not serializable' in a serializable class. 
* `SFSerializable`. Marks class or property serializable. Sets all properties as serializable when annotates class declaration.
* `SFSerializableCollection`. Marks a collection of serializable items.
* `SFSerializableDate`. Defines format for serializable NSDate property or for all date properties on the class level.


##Sample
Serializable `Person` object can look like:

	SF_ATTRIBUTE(SFSerializable)
	@interface Person : NSObject
	
	@property (strong, nonatomic) NSString *firstName;
	@property (strong, nonatomic) NSString *lastName;
	
	// firstName + lastName. Not serialized
	SF_ATTRIBUTE(SFDerived)
	@property (copy, nonatomic) NSString *fullName;
	
	SF_ATTRIBUTE(SFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z", encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z")
	@property (strong, nonatomic) NSDate *birthday;
	
	SF_ATTRIBUTE(SFSerializableCollection, collectionClass = [Car class])
	@property (strong, nonatomic) NSArray *cars;
	
	@end


where `SF_ATTRIBUTE(SFSerializable)` defines that class with all it's properties should be serialized. 
`fullName` is annotated as `SFDerived` which means that it should be omitted for encoding.
`birthday` is annotated with encoding **date** type and encoding format.
`cars` property marked as a serializable collection containing `Car` objects.

#2. XML
Serializer implements SAX-based XML deserialization into **attributed** object tree on top of `NSXMLParser` and XML serialization with `libxml2`. 

API is similar to JSON serializer: 

* `SFAttributedXMLCoder` encodes serializable object into XML stored in `NSString`, `NSData` or `NSDictionary`. 
		+ (id)encodeRootObject:(id const)rootObject;
		…
	
* `SFAttributedDecoder` acts in a reverse direction.
		 + (id)decodeXMLString:(NSString * const)xmlString;
		…

Where by *serializable object* meant any `NSObject` subclass with serialization attributes defined.

##Defined Attributes

**JSON** parsing attributes are derived and extended with:

* `SFExternal`. Marks entity as saved externally and adds link to it.
* `SFNamespace`. Defines namespace and prefix relation of the entity.
* `SFSavedAsXMLAttributes`. Marks that entity or attribute prefers  to be save in XML attributes when possible. 
* `SFEntityIdentifier`. Sets the name of XML attribute where entity identifier is stored, e.g. `@"Name"` should be set as property identification:

		<Property Name="ID" Type="Edm.Int32" Nullable="false"/>
	

