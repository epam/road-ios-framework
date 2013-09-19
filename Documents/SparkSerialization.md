#Serialization

**Attribute**-based JSON serializer and block-based XML deserialization. 

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
XML support is limited to deserialization only and uses [SAX](http://en.wikipedia.org/wiki/Simple_API_for_XML) in contrast to DOM-based built-in parser.

Entry point is a `SFXMLSpecificParser` class. It provides generic deserializing into built-in system types by invoking

		+ (void)parseXMLData:(NSData * const)xmlData completion:(parseHandler)completionBlock;

To handle elements parsing process

	- (void)childDidFinishParsing:(id<SFXMLParsing> const)aChild

should be overriden to handle parsing tags and reading values or attributes of `<SFXMLParsing>` node.

**SFXMLParsing protocol**

	@property (strong, nonatomic) SFXMLElement *element;
	@property (weak, nonatomic) SFXMLSpecificParser *parent; 
	- (NSArray *)children;

To give parser a clue about node names to custom classes map `initialize` in parser subclass should be overriden.

		- (void)initialize {
		    [super initialize];
		    [self registerParserClassNamed:@"MyNode" forElementName:@"myNodeObject"];
		}
As a result parser will invoke code passed in completion block :
	
	[YourParser parseXMLData:xmlDocumentData completion:^(SFXMLElement *rootElement, NSError *error) {
    [self handleParsedElements:rootElement];
}];