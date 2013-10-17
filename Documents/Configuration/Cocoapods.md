Advanced ROAD Integration 
========================
_ROAD Attribites_ are using code generation to provide attributes functionality. Such approach require running of additional tooling each time when you compile binary to generated necessary code augmentation. ROADConfigrator.rb automatically downloads all required tools and adds custom build-phase step into your project to handle attributes routine. 

With a basic configuration cocoapods generates workspace with the same name as the only project stored in a folder with Podfile. All dependencies will be integrated into the first target of the project. In case if you already using workspace or have multiple projects in the same folder additional configuration of podfile will be required. Following commands available for handling such cases:

* [workspace](http://docs.cocoapods.org/podfile.html#workspace) - defines workspace that should be used for integration
	
		workspace 'MyCustomWorkspace'

* [xcodeproj](http://docs.cocoapods.org/podfile.html#xcodeproj) - defines project that should include pod dependencies

		xcodeproj 'path\to\project\MyProject1'
		xcodeproj 'path\to\project\MyProject2'
		
* [target](http://docs.cocoapods.org/podfile.html#target) - provides a way to scope dependencies for further linking

		target :MyProject1 do
			pod 'spark-ios-framework/ROADServices'
		end

		target :MyProject2 do
			pod 'spark-ios-framework/ROADWebService'
		end

* [link_with](http://docs.cocoapods.org/podfile.html#link_with) - defines integration targets 

		link_with ['MyProject1', 'MyProject1Tests']		

With a commands above you may shape your dependencies as you want. Here is an example of a complex case:

		platform :ios, '6.0'
		workspace 'MyCustomWorkspace'

		target :MyProject1 do
			xcodeproj 'MyProject1/MyProject1'
			pod 'spark-ios-framework/ROADServices'
			link_with ['MyProject1', 'MyProject1Tests']
		end

		target :MyProject2 do
			xcodeproj 'MyProject2/MyProject2'
			pod 'spark-ios-framework/ROADWebService'
			#There is no link_with specified, so pod will be linked with a first target in a project
		end
		
		post_install do |installer|
		  require File.expand_path('./', 'ROADConfigurator.rb')
		  ROADConfigurator::post_install(installer)
		end
