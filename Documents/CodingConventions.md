# Spark Objective-C Style Guide

This style guide describes the coding conventions for Spark iOS Framework.

Most of these guidelines match Apple's documentation and community-accepted best practices, however some guidelines are derived from personal preferences. This document aims to set a standard way of doing things so that everyone can do things the same way. If there is some rule you are not particularly fond of, it is encouraged to follow this rule anyway to stay consistent with everyone else.

## Table of Contents

1. [Naming](#1naming)
2. [Project](#2project)
    1. [Third Party Sources](#21third-party-sources)
3. [Files](#3files)
    1. [Compiler Directives](#31compiler-directives)
        1. [Import](#311import)
        2. [Pragma](#312pragma)
    2. [Comments](#32comments)
        1. [Comment Types](#321comment-types)
        2. [Pre and Postconditions](#322pre-and-postconditions)
        3. [Thread Safety](#323thread-safety)
4. [Classes](#4classes)
5. [Categories](#5categories)
6. [Methods](#6methods)
    1. [Initialization & Deallocation](#61initialization-and-deallocation)
    2. [Conditionals](#62conditionals)
        1. [Booleans](#621booleans)
        2. [Ternary Operator](#622ternary-operator)
    3. [Logging](#63logging)
    4. [Error Handling](#64error-handling)
    5. [Assertion](#65assertion)
7. [Properties](#7properties)
    1. [Dot-Notation Syntax](#71dot-notation-syntax)
    2. [Private Properties](#72private-properties)
8. [Variables](#8variables)
    1. [Literals](#81literals)
    2. [Constants](#82constants)
    3. [Enumerated Types](#83enumerated-types)
9. [Blocks](#9blocks)
10. [Resources](#10resources)
    1. [Image Naming](#101image-naming)
11. [C Language](#11c-language)
    1. [Functions](#111functions)
12. [Objective-C++](#12objective-c)

## 1.Naming

1. Apple's [Coding Guidelines for Cocoa](https://developer.apple.com/library/ios/#documentation/Cocoa/Conceptual/CodingGuidelines/) covers most of the naming rules that need to be followed.
2. Naming conventions related to [Memory Management Rules](https://developer.apple.com/library/mac/documentation/cocoa/conceptual/MemoryMgmt/Articles/mmRules.html) should also be followed.
3. `SF` prefix should always be used for class names and constants. This prefix stands for "Spark Framework".

## 2.Project

1. The physical files should be kept in sync with the Xcode project files in order to avoid file sprawl. Any Xcode groups created should be reflected by folders in the filesystem. Code should be grouped not only by type, but also by feature for greater clarity.
2. Always turn on "Treat Warnings as Errors" in the target's Build Settings and enable as many [additional warnings](http://boredzo.org/blog/archives/2009-11-07/warnings) as possible. If you need to ignore a specific warning, use [Clang's pragma feature](http://clang.llvm.org/docs/UsersManual.html#controlling-diagnostics-via-pragmas).

### 2.1.Third Party Sources
1. It is recommended to put 3rd party source files into a separate folder with a distinct name like "ThirdParty", so that 3rd party code do not mix up with the rest of the source files.
2. It is forbidden to delete or modify any license related comments from 3rd party code.
3. It is recommended to avoid any modifications in 3rd party code and keep it intact. If you absolutely need to modify some 3rd party code then add a comment to explain your changes.
4. If you insert some third-party code snippet or method into you source file then add THIRDPARTY_START, THIRDPARTY_END or THIRDPARTY comments (see [Comment Types](#321comment-types) section).

## 3.Files
1. There is no restriction on code line length. Xcode built-in support for wrapping lines works best for all resolutions. So you should not manually wrap long lines.
2. Indent using 4 spaces instead of tabs. This is the default Xcode setting.
3. Method braces and other braces (`if`/`else`/`switch`/`while` etc.) always open on the same line as the statement but close on a new line.
**For example:**
```objc
- (void)someMethod {
//Do something
}
```

4. There should be exactly one blank line between methods in implementation file to aid in visual clarity and organization.
5. Whitespace should be avoided in blank lines. Blank line should only have new line symbol and no other invisible symbols.
6. Avoid adding blank lines at the end of files.
7. Implementation files should be no longer than 2000 lines. If a source file becomes very long it is hard to understand. Therefore long classes should usually be refactored into several individual classes that focus on a specific task.

### 3.1.Compiler Directives

#### 3.1.1.Import
1. Imports follow the below pattern: own header import is the first followed by system framework imports. All other imports are separated by a newline, grouped together and ordered alphabetically:

	```Objective-C
	#import "ThisClass.h"
	#import <dispatch/dispatch.h>
	
	#import "AnotherClass.h"
	#import "OtherClass.h"
	```

2. Use class/protocol forward declarations instead of imports in header files whenever possible to reduce compilation time.
3. `#import` Objective-C/Objective-C++ headers, and `#include` C/C++ headers. Objective-C headers should not have `#define` guards as they are already encapsulated in `#import`. Standard C and C++ headers without any Objective-C in them can expect to be included by ordinary C and C++ files. Since there is no `#import` in standard C or C++, such files will be included by `#include` in those cases. Using `#include` for them in Objective-C source files as well means that these headers will always be included with the same semantics.

#### 3.1.2.Pragma
1. Use `#pragma mark` declarations in implementation file to categorize methods into functional groupings and protocol implementations.
**For example:**
`#pragma mark - Pool delegate methods`
2. There should be two newlines before and after pragma marks.


### 3.2.Comments

The format that is used for code comments can be found here: [appledoc](http://gentlebytes.com/appledoc/), however there are a couple of guidelines that developers should follow to make code commenting consistent.

1. All class, protocol, method and property declarations should be documented using appledoc's format. Only header files must be commented using appledoc's format. The reason behind this is that the documentation generator script - which issues build warning for undocumented members - checks only the header files.
2. Any implementation file should start with copyright comment.
3. Leave an empty line before a comment block. Leave one space after `//`.
4. Always write comments before the line that is commented, do not add a comment to the end of the line.
5. Xcode uses text-wrapping by default. Code comments look best on different monitors when they do not have line breaks. Please consider writing comments that are not broke into a fix width column but is allowed to flow in the entire width of the IDE's (eg. when the window is resized Xcode automatically wraps the long lines).
6. Use neutral language. Do not write `this simple code` or `this small component` - but instead write a neutral sentence like `the component is used in ...` and do not speak unfavorably about development tools, competitors, employers or working conditions
7. **Do** explain the code, but don't repeat what it does.
8. **Do** answer the <u>**why**</u> of the code rather than the **how**.
9. Add information that the best comment to a workaround or some strange bug-fix is an issue to link in issue tracking system or some place where this issue were found (stack overflow etc).  
10. Your comment should never be shorter than a sentence, so two or three words will not do. Comments should start with a capital letter, and end the sentence with a dot. It would be even better for class or method comments to be a full-blown paragraph.
11. Use only English for code comments.
12. Use 3rd person (declarative descriptive) not 2nd person (imperative prescriptive): `Formats the paragraph`, not `Format the paragraph`
13. Method descriptions begin with a verb phrase: `Formats the text of this paragraph`, not `This method is formatting the text of this paragraph`
14. Use `this` instead of `the` when referring to an object created from the current class: `Uses the toolkit for this component to …`, not `Uses the toolkit for the component to …`.
15. Source repository capabilities should be leveraged for storing source-code branches, so commented-out code is not allowed. If there is a real need to keep code as comments it should be clearly stated.

#### 3.2.1.Comment Types
Every comment that you add should be either appledoc in header files or should start with a comment type description mark. Here is the list of possible comment type description marks:
1. TODO(date_added,author) - todo item, describes something that needs to be done.
2. DESNOTE(date_added,author) - designers note, explain workaround, unexpected code, design decisions, etc.
3. THIRDPARTY_START(date_added,who_added,license_name_or_link,taken_from_link) and THIRDPARTY_END - delimits copy-pasted code snippet. Or use THIRDPARTY(date_added,who_added,license_name_or_link,taken_from_link) - to mark copy-pasted function.

#### 3.2.2.Pre and Postconditions
***TBD***

#### 3.2.3.Thread Safety
***TBD***

## 4.Classes
1. Interface declaration follows the below example:

	```Objective-C
	@interface NSString : NSObject <NSCopying, NSMutableCopying, NSCoding>
	```
2. Omit the empty set of braces on interfaces that do not declare any instance variables.

## 5.Categories
1. Category file name should follow the next pattern: `ClassName+CategoryName.h` and `ClassName+CategoryName.m`.
2. If you add a category to a class without `SF` prefix then the category name should have `SF` prefix. If the class name already has `SF` prefix the category name should not have `SF` prefix. ***For example*** `NSObject+SFAttributes`, but `SFServiceProvider+Logging`.
3. If you add a category to a class without `SF` prefix then the category method should have `sf` prefix to avoid method name collisions.
4. Categories should be named for the sort of functionality they provide. Don't create umbrella categories.

## 6.Methods

1. In method signatures, there should be a space after the scope (-/+) symbol. There should also be space between the method segments.
**For Example**:
```objc
- (void)setExampleText:(NSString *)text image:(UIImage *)image;
```

2. Interface methods could only have maximum four parameters. Long parameter list are hard to understand and difficult to use. Therefore long list of parameters should usually be replaced with one parameter object with appropriate properties.
3. It is recommended for interface methods to only have one block type parameter (the last one). Invocation of a method with more than one block parameter may look very complex.
4. There should be one newline before and after block statements (if, for, while, etc.) and also method and function calls that ends with a block parameter type.
5. There should be one space around arithmetic operators, boolean operators, comparison operators and assignments.
6. There should be no spaces after "(" and "[", and before ")" and "]".
7. Use exactly one blank line within a method to separate functionality where necessary. However usually it is better to create another method for this purpose.
8. Avoid multiple `return` statements in one method. Multiple return statements might make it hard to understand execution flow of a method. 
9. Method length should be no longer than 40 lines. It is preferable to keep method length below 30 lines. If a method becomes very long it is hard to understand. Therefore long methods should usually be refactored into several individual methods that focus on a specific task.

### 6.1.Initialization and Deallocation

1. Comment and clearly identify your designated initializer. It is important for those who might be subclassing your class that the designated initializer be clearly identified. That way, they only need to subclass a single initializer (of potentially several) to guarantee their subclass' initializer is called. It also helps those debugging your class in the future understand the flow of initialization code if they need to step through it.
2. `init` methods should be placed at the top of the implementation, directly after the `@synthesize` and `@dynamic` statements.
3. Don't initialize variables to `0` or `nil` in the init method, it's redundant. All memory for a newly allocated object is initialized to `0` (except for isa), so don't clutter up the init method by re-initializing variables to `0` or `nil`.
4. Do not invoke the `NSObject` class method `new`, nor override it in a subclass. Instead, use `alloc` and `init` methods to instantiate retained objects. Modern Objective-C code explicitly calls `alloc` and `init` methods to create and retain an object. `new` is a legacy method that comes from NeXT days and it is kept only for backward compatibility. As the `new` class method is rarely used, it makes searching for object allocation points and reviewing code for correct memory management more difficult.
5. `dealloc` method should be placed directly below the `init` methods of a class.
6. `dealloc` should process instance variables in the same order the they were declared, so it is easier for a reviewer to verify.
7. `init` methods should be structured like this:

```objc
- (instancetype)init {
    self = [super init]; // or call the designated initalizer
    if (self) {
        // Custom initialization
    }

    return self;
}
```

### 6.2.Conditionals

1. Conditional bodies should always use braces even when a conditional body could be written without braces (e.g., it is one line only), because absence of brackets may cause different types of programming errors. These errors include adding a second line and expecting it to be part of the if-statement. Another, [even more dangerous defect](http://programmers.stackexchange.com/a/16530) may happen where the line "inside" the if-statement is commented out, and the next line unwittingly becomes part of the if-statement. In addition, this style is more consistent with all other conditionals, and therefore more easily scannable.
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

2. `else` and `else if` should appear in the same line as closing brace.
**For example:**
```objc
if (user.isHappy) {
//Do something
} else {
//Do something else
}
```

3. There should be no assignment operator in if conditions.
4. Do not use `nil` checks for crash prevention, only use it for logic flow of the application. Sending a message to a `nil` object is handled by the Objective-C runtime.

#### 6.2.1.Booleans

1. Never compare something directly to `nil`, since `nil` resolves to `NO` it is unnecessary to compare it in conditions.
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

2. Never compare something directly to `YES`, because `YES` is defined to 1 and a `BOOL` can be up to 8 bits. This allows for more consistency across files and greater visual clarity.
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

3. Prefer positive comparisons to negative since it improves code clarity.

#### 6.2.2.Ternary Operator
1. The Ternary operator, ? , should be used when it increases clarity or code neatness. A single condition is usually all that should be evaluated. Evaluating multiple conditions is usually more understandable as an if statement, or refactored into instance variables.
**For example:**
`result = a > b ? x : y;`
**Not:**
`result = a > b ? x = c > d ? c : d : y;`

### 6.3.Logging
1. Choose an appropriate logging level (`info`, `debug`, `warning`, `error`) to reflect the severity of the log message.
2. Specify a distict log message type appropriate for your component (for instance `SparkCore`), so that your messages can be easily filtered out from a user's logs.

### 6.4.Error Handling
1. To indicate errors, use an `NSError **` method argument.
2. Don't use exceptions for flow control, use exceptions only to indicate programmer error such as out-of-bounds collection access, attempts to mutate immutable objects, sending an invalid message, etc. These sorts of errors should be taken care of when an application is being developed, rather than in production.

### 6.5.Assertion
***TBD***

## 7.Properties
1. Properties should be camel-case with the leading word being lowercase. Use of automatically synthesized instance variables is preferred. Otherwise, in order to be consistent, the backing instance variables for these properties should be camel-case with the leading word being lowercase and a leading underscore. This is the same format as Xcode's default synthesis.
2. Order of property specifiers follow the below example:

	```Objective-C
	@property (strong, nonatomic, readonly) NSArray *array;
	```
	
3. Always declare memory-management semantics even on readonly properties.
4. Declare properties readonly if they are only set once in `init` method.
5. Declare properties `copy` if they return immutable objects and aren't ever mutated in the implementation.
6. `@synthesize` and `@dynamic` should each be declared on new lines in the implementation.
7. Property definitions should be used in place of naked instance variables whenever possible to promote encapsulation.
8. Prefer exposing an immutable type for a property to promote encapsulation.
9. When using properties, instance variables should always be accessed and mutated using `self.`. This means that all properties will be visually distinct, as they will all be prefaced with `self.`. Direct instance variable access should be avoided except in initializer methods (`init`, `initWithCoder:`, etc…), `dealloc` methods and within custom setters and getters. For more information on using Accessor Methods in Initializer Methods and dealloc, see [here](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/mmPractical.html#//apple_ref/doc/uid/TP40004447-SW6).

### 7.1.Dot-Notation Syntax
1. Dot-notation should be used for accessing and mutating properties. Bracket notation is preferred in all other instances.

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

### 7.2.Private Properties

1. Private properties should be declared in class extensions (anonymous categories) in the implementation file of a class. Named categories (such as `SFTPrivate` or `private`) should never be used unless extending another class.

**For example:**
```objc
@interface ESDXMLParser ()
@property (strong, nonatomic) NSMutableArray *parserStack;
@property (strong, nonatomic) ESDXMLElement *rootElement;
@end
```

## 8.Variables

1. Variables should be named as descriptively as possible. This will result in self-documented easy to understand code. Single letter variable names should be avoided except in `for()` loops.
2. The variable that you return from a method should also be named descriptively, its name should explain what the method return. Generic variable names like `result`, `retVal` should be avoided.
3. There should be no instance variable declarations in header files. Instance variables belong to implementation details and should therefore be declared in class extension (anonymous categories) in implementation file.
4. Asterisks indicating pointers belong with the variable, e.g., `NSString *text` not `NSString* text` or `NSString * text`, except in the case of constant pointers.

### 8.1.Literals

1. Avoid making numbers a specific type unless necessary (for example, prefer `5` to `5.0`, and `5.3` to `5.3f`).
2. `NSString`, `NSDictionary`, `NSArray`, and `NSNumber` literals should be used whenever creating immutable instances of those objects. Pay special care that `nil` values not be passed into `NSArray` and `NSDictionary` literals, as this will cause a crash.

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

### 8.2.Constants

1. Constants are preferred over in-line string literals or numbers, as they allow for easy reproduction of commonly used variables and can be quickly changed without the need for find and replace. Constants should be declared as `static` constants and not `#define`s unless explicitly being used as a macro.
**For example:**
```objc
static NSString * const SFNetLogServiceType = @"_appalocalnetwork._tcp.";
```
**Not:**
```objc
#define SFNetLogServiceType @"_appalocalnetwork._tcp."
```

2. Scope / lifetime specifiers should always stand before const specifier. 

	```Objective-C
	static const MyClass *const
	```

### 8.3.Enumerated Types

1. When you have several related constants, you should prefer to use enumeration type to define all this constants instead of defining all these constants separately.

## 9.Blocks
1. If the block is large, e.g. more than 15 lines, it is recommended to move it out-of-line into a local variable.

## 10.Resources
### 10.1.Image Naming

1. It is recommended to put all resources in asset catalogs.
2. Image names should be named consistently to preserve organization and developer sanity. They should be named as one camel case string with a description of their purpose, followed by the un-prefixed name of the class or property they are customizing (if there is one), followed by a further description of colour and/or placement, and finally their state.
**For example:**
3. `RefreshBarButtonItem` / `RefreshBarButtonItem@2x` and `RefreshBarButtonItemSelected` / `RefreshBarButtonItemSelected@2x`
4. `ArticleNavigationBarWhite` / `ArticleNavigationBarWhite@2x` and `ArticleNavigationBarBlackSelected` / `ArticleNavigationBarBlackSelected@2x`.

## 11.C Language
### 11.1.Functions

1. C function declarations should start with a capital letter.
2. C function declarations in header files should have `SF` prefix: 
***For example***
`void SFAwesomeFunction(BOOL hasSomeArgs);`

## 12.Objective-C++
1. Objective-C++ implementation file should have `.mm` extension

# Reference

Style guides that were used to create this document:

1. [NYTimes Objective-C Style Guide](https://github.com/NYTimes/objective-c-style-guide#nytimes-objective-c-style-guide)
2. [Github Coding Conventions for Objective-C Projects](https://github.com/github/objective-c-conventions)
3. [Google Objective-C Style Guide](http://google-styleguide.googlecode.com/svn/trunk/objcguide.xml)
