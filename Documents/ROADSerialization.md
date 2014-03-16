#Serialization

**Attribute**-based JSON and XML serializers. 

#1. JSON

Component takes advantages of properties annotations to define serialization options with **RFAttribute**s.

Encoding and decoding entry points are provided by correspondening classes: 

* `RFAttributedCoder` encodes serializable object into JSON stored in `NSString`, `NSData` or `NSDictionary`.

  ```objc
  + (id)encodeRootObject:(id const)rootObject;
  ```	
* `RFAttributedDecoder` acts in a reverse direction.
  
  ```objc
  + (id)decodeJSONString:(NSString *const)jsonString withRootClassNamed:(NSString * const)rootClassName;
  ```
Where *rootClassName* is a name of any `NSObject` subclass with serialization attributes defined.

##Defined Attributes

* `RFDerived`. Annotates property to mark it as 'not serializable' in a serializable class. 
* `RFSerializable`. Marks class or property serializable. Sets all properties as serializable when annotates class declaration.
* `RFSerializableCollection`. Marks a collection of serializable items.
* `RFSerializableDate`. Defines format for serializable NSDate property or for all date properties on the class level.
* `RFSerializableBoolean`. Defines custom serialization behaviour for boolean values.
* `RFSerializationCustomHandler`. Defines custom serialization handler class. The handler class has to conform to RFJSONSerializationHandling protocol for JSON serialization.



##Sample
Serializable `Person` object can look like:
```objc
RF_ATTRIBUTE(RFSerializable)
@interface Person : NSObject
	
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
	
// firstName + lastName. Not serialized
RF_ATTRIBUTE(RFDerived)
@property (copy, nonatomic) NSString *fullName;
	
RF_ATTRIBUTE(RFSerializableDate, format = @"dd/MM/yyyy HH:mm:ss Z", encodingFormat = @"MM.dd.yyyy HH:mm:ss.AAA Z")
@property (strong, nonatomic) NSDate *birthday;
	
RF_ATTRIBUTE(RFSerializableCollection, collectionClass = [Car class])
@property (strong, nonatomic) NSArray *cars;
	
@end
```

where `RF_ATTRIBUTE(RFSerializable)` defines that class with all it's properties should be serialized. 
`fullName` is annotated as `RFDerived` which means that it should be omitted for encoding.
`birthday` is annotated with encoding **date** type and encoding format.
`cars` property marked as a serializable collection containing `Car` objects.

#2. XML
Serializer implements SAX-based XML deserialization into **attributed** object tree on top of `NSXMLParser` and XML serialization with `libxml2`. 

API is similar to JSON serializer: 

* `RFAttributedXMLCoder` encodes serializable object into XML stored in `NSString`, `NSData` or `NSDictionary`.

  ```objc
  - (id)encodeRootObject:(id const)rootObject;
  ```	
* `RFAttributedXMLDecoder` acts in a reverse direction.

  ```objc
  - (id)decodeData:(NSData *)xmlData withRootObjectClass:(Class)rootObjectClass;
  ```
Where *rootClassName* is a name of any `NSObject` subclass with serialization attributes defined.

##Defined Attributes

**JSON** parsing attributes are derived and extended with:

* `RFXMLSerializable`. 
	* *isTagAttribute* Applied to object property and defines whether it is stored in parent tag as attribute or as a child.
* `RFXMLSerializableCollection`. Applied to object property of *NSArray* or *NSDictionary* type when it should be serialized directly into parent's tag.
	* *itemTag* sets tag name for collection items.

##Sample
```xml
<person age="54" name="John Doe" city="Boyarka">
  <children>
    <person age="25" name="Mary Doe" city="Boyarka"/>
    <person age="13" name="Chris Doe" city="Boyarka"/>
  </children>
</person>	
```
XML above can be annotated in code in the following way:
```objc
RF_ATTRIBUTE(RFSerializable)
@interface Person : NSObject
	
RF_ATTRIBUTE(RFXMLSerializable, isTagAttribute = YES);
@property (copy, nonatomic) NSString *name;
RF_ATTRIBUTE(RFXMLSerializable, isTagAttribute = YES);
@property (copy, nonatomic) NSString *city;
RF_ATTRIBUTE(RFXMLSerializable, isTagAttribute = YES);
@property (assign, nonatomic) int age;
	
RF_ATTRIBUTE(RFSerializableCollection, collectionClass = [Person class])
@property (copy, nonatomic) NSArray *children;
```
If children of `John` are stored without container tag:
```xml
<person age="54" name="John Doe" city="Boyarka">
  <person age="25" name="Mary Doe" city="Boyarka"/>
  <person age="13" name="Chris Doe" city="Boyarka"/>
</person>	
```	
`children` property can be annotated that content of it's subtags with 'person' key is associated with the `children` array:
```objc
RF_ATTRIBUTE(RFXMLSerializableCollection, collectionClass = [Person class], itemTag = @"person")
@property (copy, nonatomic) NSArray *children;
```
Serialization works in the same way.

[1]:https://developer.apple.com/library/mac/documentation/cocoa/conceptual/DataFormatting/Articles/dfDateFormatting10_4.html