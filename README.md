#Spark iOS Framework [![Build Status](https://magnum.travis-ci.com/epam/spark-ios-framework.png?token=o3R2wxGct9xoZkZhni3K&branch=dev)](https://magnum.travis-ci.com/epam/spark-ios-framework)
===================
A set of reusable components taking advantage of extra dimension [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) adds.

* Source: [github.com/epam/spark-ios-framework](github.com/epam/spark-ios-framework)
* Homepage: [sparkiosframework.com](http://sparkiosframework.com)


##Components

**Core** - support for attributes, reflection and helper-extensions on Foundation classes.  
**Services** - implementation of Service Locator pattern, centralized replacement for singletons.  
**Serialization** - attribute-based JSON and XML parsers for easy DOM (de)serializations.  
**Web Services** - attribute-based HTTP client API.  
**Logger** - attribute-based logger.  
**Observation** - unification of KVO and NSNotifications with block-based callbacks.  

##Requirements

Spark requires **iOS 5.0** and above. Compatibility with **4.3** and older is not tested.

Spark initially designed to use **ARC**. 

##Jump Start
Download [`Podfile`](https://github.com/epam/spark-ios-framework/tree/dev/Cocoapods/Podfile) and add it's contents to yours if you already use **CocoaPods**.

Otherwise follow next steps:

* Create a project
* Download [`Podfile`](https://github.com/epam/spark-ios-framework/tree/dev/Cocoapods/Podfile) to the project root.

* Go to project root in terminal and install dependencies:

        $ pod install

*From now, use generated Xcode workspace instead of the project file only*
 
* Copy [`SparkAttributesCodeGenerator`](https://github.com/epam/spark-ios-framework/tree/master/tools/binaries) into new directory `binaries` in project root. It will be used for **attributes** preprocessing.

* Verify that **Run Script** with `SparkAttributesCodeGenerator` is in **"Build Phases"** before **Compile Sources** for all targets including `Pods.xcodeproj` points to valid path.

**Using components separately**  
If you'd like to embed only specific components from the framework it can be done with CocoaPods as well.

        pod 'spark-ios-framework/SparkServices'
        pod 'spark-ios-framework/SparkWebService'
        
##Documentation

Documentation for all components can be found in **Documents** folder.

_coming soon in [cocoadocs.org](http://cocoadocs.org)_

##License
Spark is made available under the terms of the [BSD v3](http://opensource.org/licenses/BSD-3-Clause). See the LICENSE file that accompanies this distribution for the full text of the license.
