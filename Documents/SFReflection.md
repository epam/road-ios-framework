#Reflection

**Reflection** provides API to access to class metadata on ivars, methods and properties by wrapping low-level Objective-C runtime functions.

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

