# Spark Objective-C Style Guide

This style guide describes the coding conventions for Spark iOS Framework.

Most of these guidelines match Apple's documentation and community-accepted best practices, however some guidelines are derived from personal preferences. This document aims to set a standard way of doing things so that everyone can do things the same way. If there is some rule you are not particularly fond of, it is encouraged to follow this rule anyway to stay consistent with everyone else.

## Table of Contents

* [Naming](#naming)
* [Project](#project)
* [Files](#files)
  * [Compiler Directives](#compiler-directives)
      * [Import](#import)
      * [Pragma](#pragma)
  * [Comments](#comments)
      * [Comment Types](#comment-types)
      * [Pre and Postconditions](#pre-and-postconditions)
      * [Thread Safety](#thread-safety)
* [Classes](#classes)
* [Categories](#categories)
* [Methods](#methods)
  * [Initialization & Deallocation](#initialization-and-deallocation)
  * [Conditionals](#conditionals)
      * [Booleans](#booleans)
      * [Ternary Operator](#ternary-operator)
  * [Logging](#logging)
  * [Error Handling](#error-handling)
  * [Assertion](#assertion)
* [Properties](#properties)
  * [Dot-Notation Syntax](#dot-notation-syntax)
  * [Private Properties](#private-properties)
* [Variables](#variables)
  * [Literals](#literals)
  * [Constants](#constants)
  * [Enumerated Types](#enumerated-types)
* [Blocks](#blocks)
* [Resources](#resources)
  * [Image Naming](#image-naming)
* [C Language](#c-language)
  * [Functions](#functions)
* [C++ Language](#c-language)

## Naming

* Apple's [Coding Guidelines for Cocoa](https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CodingGuidelines/) covers most of the naming rules that need to be followed.
* Naming conventions related to [Memory Management Rules](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/MemoryMgmt/Articles/mmRules.html) should also be followed.
* `SF` prefix should always be used for class names and constants, however may be omitted for Core Data entity names. This prefix stands for "Spark Framework".

## Project

* The physical files should be kept in sync with the Xcode project files in order to avoid file sprawl. Any Xcode groups created should be reflected by folders in the filesystem. Code should be grouped not only by type, but also by feature for greater clarity.
* When possible, always turn on "Treat Warnings as Errors" in the target's Build Settings and enable as many [additional warnings](http://boredzo.org/blog/archives/2009-11-07/warnings) as possible. If you need to ignore a specific warning, use [Clang's pragma feature](http://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas).

## Files
* There is no restriction on code line length. Xcode built-in support for wrapping lines works best for all resolutions. So you should not manually wrap long lines.
* Indent using 4 spaces instead of tabs. This is the default Xcode setting.
* Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.
**For example:**
```objc
- (void)someMethod {
//Do something
}
```

* There should be exactly one blank line between methods in implementation file to aid in visual clarity and organization.
* Whitespace should be avoided in blank lines. Blank line should only have new line symbol and no other invisible symbols.
* Avoid adding blank lines at the end of files.
* Implementation files should be no longer than 2000 lines. If a source file becomes very long it is hard to understand. Therefore long classes should usually be refactored into several individual classes that focus on a specific task.

### Compiler Directives

#### Import
* Imports follow the below pattern: own header import is the first followed by system framework imports. All other imports are separated by a newline, grouped together and ordered alphabetically:

	```Objective-C
	#import "ThisClass.h"
	#import <dispatch/dispatch.h>
	
	#import "AnotherClass.h"
	#import "OtherClass.h"
	```

* Use class/protocol forward declarations instead if imports in header files whenever possible to reduce compilation time.
* `#import` Objective-C/Objective-C++ headers, and `#include` C/C++ headers. Objective-C headers usually do not have `#define` guards, and expect to be included only by `#import`. Standard C and C++ headers without any Objective-C in them can expect to be included by ordinary C and C++ files. Since there is no `#import` in standard C or C++, such files will be included by `#include` in those cases. Using `#include` for them in Objective-C source files as well means that these headers will always be included with the same semantics.

#### Pragma
* Use `#pragma mark` declarations in implementation file to categorize methods into functional groupings and protocol implementations.
**For example:**
```objc #pragma mark - Pool delegate methods```

* There should be two newlines before and after pragma marks.


### Comments

The format that is used for code comments can be found here: [appledoc](http://gentlebytes.com/appledoc/), however there are a couple of guidelines that developers should follow to make code commenting consistent.

* All class, protocol, method and property declarations should be documented using appledoc's format. Only header files must be commented using appledoc's format. The reason behind this is that the documentation generator script - which issues build warning for undocumented members - checks only the header files.
* Any implementation file should start with copyright comment.
* When commenting methods outside of the method (eg. at the top of the method) always write complete sentences beginning with a capital letter, and ending the sentence with a dot. 
* When writing comments inside a method's body start with a lower case letter and do not end the comment with a dot, and always leave a space after `//`.
* Leave an empty line before a comment block.
* Always write comments before the line that is commented, do not add a comment to the end of the line.
* Xcode uses text-wrapping by default. Code comments look best on different monitors when they do not have line breaks. Please consider writing comments that are not broke into a fix width column but is allowed to flow in the entire width of the IDE's (eg. when the window is resized Xcode automatically wraps the long lines).
* Use neutral language. Do not write `this simple code` or `this small component` - but instead write a neutral sentence like `the component is used in ...` and do not speak unfavorably about development tools, competitors, employers or working conditions
* **Do** explain the code, but don't repeat what it does.
* **Do** answer the <u>**why**</u> of the code rather than the **how**.
* **Do** comment <u>surprise</u> code, or <u>workarounds</u> to known bugs.  
* As a rule of thumb your comment should never be shorter than a sentence. So two or three words will not do. It would be even better for class or method comments to be a full-blown paragraph.
* Use only English for code comments.
* Use 3rd person (declarative descriptive) not 2nd person (imperative prescriptive): `Formats the paragraph`, not `Format the paragraph`
* Method descriptions begin with a verb phrase: `Formats the text of this paragraph`, not `This method is formatting the text of this paragraph`
* Use `this` instead of `the` when referring to an object created from the current class: `Uses the toolkit for this component to …`, not `Uses the toolkit for the component to …`.
* There should be no commented out code. Or at least there should be `TODO` comment or `#pragma warning` directive that explains why is this code left commented out.

#### Comment Types
***TBD***
* TODO(date,author)
* DESNOTE(date,author)

#### Pre and Postconditions
***TBD***

#### Thread Safety
***TBD***

## Classes
* Interface declaration follows the below example:

	```Objective-C
	@interface NSString : NSObject <NSCopying, NSMutableCopying, NSCoding>
	```
* Omit the empty set of braces on interfaces that do not declare any instance variables.

## Categories
* Category file name should follow the next pattern: `ClassName+CategoryName.h` and `ClassName+CategoryName.m`
* Categories should be named for the sort of functionality they provide. Don't create umbrella categories.

## Methods

* In method signatures, there should be a space after the scope (-/+) symbol. There should also be space between the method segments.
**For Example**:
```objc
- (void)setExampleText:(NSString *)text image:(UIImage *)image;
```

* Interface methods could only have maximum four parameters. Long parameter list are hard to understand and difficult to use. Therefore long list of parameters should usually be replaced with one parameter object with appropriate properties.
* Interface methods should only have maximum one block type parameter and it must be the last one. Invocation of a method with more than one block parameter may look very complex.
* There should be one newline before and after block statements (if, for, while, etc.) and also method and function calls that ends with a block parameter type.
* There should be one space around arithmetic operators, boolean operators, comparison operators and assignments.
* There should be no spaces after "(" and "[", and before ")" and "]".
* Use exactly one blank line within a method to separate functionality where necessary. However usually it is better to create another method for this purpose.
* Avoid multiple `return` statements in one method. Multiple return statements might make it hard to understand execution flow of a method. 
* Method length should be no longer than 40 lines. It is preferable to keep method length below 30 lines. If a method becomes very long it is hard to understand. Therefore long methods should usually be refactored into several individual methods that focus on a specific task.

### Initialization and Deallocation

* Comment and clearly identify your designated initializer. It is important for those who might be subclassing your class that the designated initializer be clearly identified. That way, they only need to subclass a single initializer (of potentially several) to guarantee their subclass' initializer is called. It also helps those debugging your class in the future understand the flow of initialization code if they need to step through it.
* `init` methods should be placed at the top of the implementation, directly after the `@synthesize` and `@dynamic` statements.
* `init` methods should be structured like this:

```objc
- (instancetype)init {
    self = [super init]; // or call the designated initalizer
    if (self) {
        // Custom initialization
    }

    return self;
}
```

* Don't initialize variables to `0` or `nil` in the init method, it's redundant. All memory for a newly allocated object is initialized to `0` (except for isa), so don't clutter up the init method by re-initializing variables to `0` or `nil`.
* Do not invoke the `NSObject` class method `new`, nor override it in a subclass. Instead, use `alloc` and `init` methods to instantiate retained objects. Modern Objective-C code explicitly calls `alloc` and an `init` method to create and retain an object. As the `new` class method is rarely used, it makes reviewing code for correct memory management more difficult.
* `dealloc` method should be placed directly below the `init` methods of a class.
* `dealloc` should process instance variables in the same order the they were declared, so it is easier for a reviewer to verify.

### Conditionals

* Conditional bodies should always use braces even when a conditional body could be written without braces (e.g., it is one line only), because absence of brackets may cause different types of programming errors. These errors include adding a second line and expecting it to be part of the if-statement. Another, [even more dangerous defect](http://programmers.stackexchange.com/a/16530) may happen where the line "inside" the if-statement is commented out, and the next line unwittingly becomes part of the if-statement. In addition, this style is more consistent with all other conditionals, and therefore more easily scannable.
**For example:**
```objc
if (!error) {
    return success;
}
```
**Not:**
```objc
if (!error)
    return success;
```
***or***
```objc
if (!error) return success;
```

* `else` and `if else` should appear in the same line as closing brace.
**For example:**
```objc
if (user.isHappy) {
//Do something
} else {
//Do something else
}
```

* There should be no assignment operator in if conditions.
* Use `nil` checks for logic flow of the application, not for crash prevention. Sending a message to a `nil` object is handled by the Objective-C runtime.

#### Booleans

* Since `nil` resolves to `NO` it is unnecessary to compare it in conditions.
**For example:**
```objc
if (!someObject) {
}
```
**Not:**
```objc
if (someObject == nil) {
}
```

* Never compare something directly to `YES`, because `YES` is defined to 1 and a `BOOL` can be up to 8 bits. This allows for more consistency across files and greater visual clarity.
**For example:**
```objc
if (isAwesome)
if (![someObject boolValue])
```
**Not:**
```objc
if ([someObject boolValue] == NO)
if (isAwesome == YES) // Never do this.
```

* Prefer positive comparisons to negative since it improves code clarity.

#### Ternary Operator

* The Ternary operator, ? , should be used when it increases clarity or code neatness. A single condition is usually all that should be evaluated. Evaluating multiple conditions is usually more understandable as an if statement, or refactored into instance variables.
**For example:**
```objc
result = a > b ? x : y;
```
**Not:**
```objc
result = a > b ? x = c > d ? c : d : y;
```

### Logging
* There should be no log statements in the code. We only use log statements for debugging.

### Error Handling
* To indicate errors, use an `NSError **` method argument.
* Don't use exceptions for flow control, use exceptions only to indicate programmer error.

### Assertion
***TBD***

## Properties
* Properties should be camel-case with the leading word being lowercase. Use of automatically synthesized instance variables is preferred. Otherwise, in order to be consistent, the backing instance variables for these properties should be camel-case with the leading word being lowercase and a leading underscore. This is the same format as Xcode's default synthesis.
* Order of property specifiers follow the below example:

	```Objective-C
	@property (strong, nonatomic, readonly) NSArray *array;
	```
	
* Always declare memory-management semantics even on readonly properties.
* Declare properties readonly if they are only set once in `init` method.
* Declare properties `copy` if they return immutable objects and aren't ever mutated in the implementation.
* `@synthesize` and `@dynamic` should each be declared on new lines in the implementation.
* Property definitions should be used in place of naked instance variables whenever possible to promote encapsulation.
* Prefer exposing an immutable type for a property to promote encapsulation.
* When using properties, instance variables should always be accessed and mutated using `self.`. This means that all properties will be visually distinct, as they will all be prefaced with `self.`. Direct instance variable access should be avoided except in initializer methods (`init`, `initWithCoder:`, etc…), `dealloc` methods and within custom setters and getters. For more information on using Accessor Methods in Initializer Methods and dealloc, see [here](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmPractical.html#//apple_ref/doc/uid/TP40004447-SW6).

### Dot-Notation Syntax

* Dot-notation should be used for accessing and mutating properties. Bracket notation is preferred in all other instances.
**For example:**
```objc
view.backgroundColor = [UIColor orangeColor];
[UIApplication sharedApplication].delegate;
```
**Not:**
```objc
[view setBackgroundColor:[UIColor orangeColor]];
UIApplication.sharedApplication.delegate;
```

### Private Properties

* Private properties should be declared in class extensions (anonymous categories) in the implementation file of a class. Named categories (such as `SFTPrivate` or `private`) should never be used unless extending another class.
**For example:**
```objc
@interface ESDXMLParser ()
@property (strong, nonatomic) NSMutableArray *parserStack;
@property (strong, nonatomic) ESDXMLElement *rootElement;
@end
```

## Variables

* Variables should be named as descriptively as possible. This will result in self-documented easy to understand code. Single letter variable names should be avoided except in `for()` loops.
* There should be no instance variable declarations in header files. Instance variables belong to implementation details and should therefore be declared in implementation file.
* Asterisks indicating pointers belong with the variable, e.g., `NSString *text` not `NSString* text` or `NSString * text`, except in the case of constant pointers.

### Literals

* Avoid making numbers a specific type unless necessary (for example, prefer `5` to `5.0`, and `5.3` to `5.3f`).
* `NSString`, `NSDictionary`, `NSArray`, and `NSNumber` literals should be used whenever creating immutable instances of those objects. Pay special care that `nil` values not be passed into `NSArray` and `NSDictionary` literals, as this will cause a crash.
**For example:**
```objc
NSArray *names = @[@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul"];
NSDictionary *productManagers = @{@"iPhone" : @"Kate", @"iPad" : @"Kamal", @"Mobile Web" : @"Bill"};
NSNumber *shouldUseLiterals = @YES;
NSNumber *buildingZIPCode = @10018;
```
**Not:**
```objc
NSArray *names = [NSArray arrayWithObjects:@"Brian", @"Matt", @"Chris", @"Alex", @"Steve", @"Paul", nil];
NSDictionary *productManagers = [NSDictionary dictionaryWithObjectsAndKeys: @"Kate", @"iPhone", @"Kamal", @"iPad", @"Bill", @"Mobile Web", nil];
NSNumber *shouldUseLiterals = [NSNumber numberWithBool:YES];
NSNumber *buildingZIPCode = [NSNumber numberWithInteger:10018];
```

### Constants

* Constants are preferred over in-line string literals or numbers, as they allow for easy reproduction of commonly used variables and can be quickly changed without the need for find and replace. Constants should be declared as `static` constants and not `#define`s unless explicitly being used as a macro.
**For example:**
```objc
static NSString * const SFNetLogServiceType = @"_appalocalnetwork._tcp.";
```
**Not:**
```objc #define SFNetLogServiceType @"_appalocalnetwork._tcp."```

* Scope / lifetime specifiers should always stand before const specifier. 

	```Objective-C
	static const MyClass *const
	```

### Enumerated Types

* When you have several related constants, you should prefer to use enumeration type to define all this constants instead of defining all these constants separately.

## Blocks
* If the block is large, e.g. more than 15 lines, it is recommended to move it out-of-line into a local variable.

## Resources
### Image Naming

* Image names should be named consistently to preserve organization and developer sanity. They should be named as one camel case string with a description of their purpose, followed by the un-prefixed name of the class or property they are customizing (if there is one), followed by a further description of colour and/or placement, and finally their state.
**For example:**
* `RefreshBarButtonItem` / `RefreshBarButtonItem@2x` and `RefreshBarButtonItemSelected` / `RefreshBarButtonItemSelected@2x`
* `ArticleNavigationBarWhite` / `ArticleNavigationBarWhite@2x` and `ArticleNavigationBarBlackSelected` / `ArticleNavigationBarBlackSelected@2x`.

## C Language
### Functions

* C function declarations should start with a capital letter.
* C function declarations in header files should have `SF` prefix: 
***For example***
`void SFAwesomeFunction(BOOL hasSomeArgs);`

## Objective-C++
* Objective-C++ implementation file should have `.mm` extension

# Reference

Style guides that were used to create this document:

* [NYTimes Objective-C Style Guide](https://github.com/NYTimes/objective-c-style-guide#nytimes-objective-c-style-guide)
* [Github Coding Conventions for Objective-C Projects](https://github.com/github/objective-c-conventions)
* [Google Objective-C Style Guide](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml)
