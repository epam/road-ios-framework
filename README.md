Master: [![Build Status](https://magnum.travis-ci.com/epam/spark-ios-framework.png?token=o3R2wxGct9xoZkZhni3K)](https://magnum.travis-ci.com/epam/spark-ios-framework) Dev: [![Build Status](https://magnum.travis-ci.com/epam/spark-ios-framework.png?token=o3R2wxGct9xoZkZhni3K&branch=dev)](https://magnum.travis-ci.com/epam/spark-ios-framework)
#Spark iOS Framework

A set of reusable components taking advantage of extra dimension [Attribute-Oriented Programming](https://en.wikipedia.org/wiki/Attribute-oriented_programming) adds.

##Components

**Core** - support for attributes, reflection and helper-extensions on Foundation classes.  
**Services** - implementation of Service Locator pattern, centralized replacement for singletons.  
**Serialization** - attribute-based JSON and XML parsers for easy DOM (de)serializations.  
**Web Services** - attribute-based HTTP client API.  
**Logger** - attribute-based logger.  
**Observation** - unification of KVO and NSNotifications with block-based callbacks.  

##Snippet
Connection to some sweety HTTP server could look like:

 


##Requirements

Spark requires **iOS 5.0** and above. Compatibility with **4.3** and older is not tested.

Spark initially designed to use **ARC**. 

##Jump Start
[CocoaPods](http://cocoapods.org) the only recommended way of Spark integration. Besides standard configuration of pod dependencies pod_install hook definition required as shown below. Typical Podfile will looks like following:

	platform :ios, '5.0'

	pod 'SparkFramework', '~> 1.1.0'

	post_install do |installer|
	  require File.expand_path('./', 'SparkConfigurator.rb')
	  SparkConfigurator::post_install(installer)
	end


Download [`SparkConfigurator.rb`](./Cocoapods/Podfile) and put it right near your `Podfile`

**Using components separately**  
If you'd like to embed only specific components from the framework it can be done with CocoaPods as well.

        pod 'spark-ios-framework/SparkServices'
        pod 'spark-ios-framework/SparkWebService'

Detail information on internals of Spark integration as well as advanced topics like integration with predefined workspace, multiple projects or targets available in [documentation](./Documents/Configuration/Cocoapods.md).        
        
##Documentation

User documentation for following components available in **Documents** folder:

* [Core](./Documents/SparkCore.md)
* [Services](./Documents/SparkServices.md)
* [Serialization](./Documents/SparkSerialization.md)
* [Web Services](./Documents/SparkWebSwervices.md)
* [Logger](./Documents/SparkLogger.md)
* [Observation](./Documents/SparkObservation.md)

Classes reference available in [cocoadocs.org](http://cocoadocs.org/docsets/spark-ios-framework/)

##License
Spark is made available under the terms of the [BSD v3](http://opensource.org/licenses/BSD-3-Clause). See the LICENSE file that accompanies this distribution for the full text of the license.
