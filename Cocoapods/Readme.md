Using with Cocoapods
========================
The way to manage library dependencies in Objective-C projects.

## Sharing pod specifications with yourself ##

required [gem](http://rubygems.org):

* install cocoapods

        $ [sudo] gem install cocoapods
        $ pod setup

* add `SparkFramework.podspec`:

        $ pod repo add spark-ios-framework https://github.com/epam/spark-ios-framework.git
        $ pod push spark-ios-framework --allow-warnings --local-only

* create a project and copy `Podfile`

* install dependencies:

        $ pod install

 _Now, we need work with Xcode workspace instead of the project file_
 
* copy `SparkAttributesCodeGenerator` (https://github.com/edl00k/spark-ios-framework/tree/master/tools/binaries) file into new directory `binaries` in your own project

* adjust `Run Script` in _"Build Phases"_ before `Compile Sources` for all targets _including Pods.xcodeproj_

