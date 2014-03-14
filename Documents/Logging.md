#Logging in ROAD

We want our framework works so intuitive and flawless that there will be no necessity in logging. But sometimes you need to know what's happening inside framework or maybe you want to catch some error in parameters or data you passing in. For these purposes we have log statements in framework code. 

##Configuration

We try to reduce impact of logging on your performance, so we have different options to log all operation, filter them or even strip all log statements from the code (and eventually from result binary).

By default framework don't log anything and you don't want it, that's fine, you're done. To turn on logging you need to setup preprocessor macros. Currently we support only one option for logging:

* **ROAD_LOGGING_NSLOG**. Logging framework log messages via standard NSLog function.

Because of our framework installation preferred method limitation (it builds framework in its own generated target) you need to set this preprocessor macros in *Preprocessor macros* section in *Build Setting* of *Pods-ROADFramework* target. If you can't find this section, try to switch filtration of setting to *All* instead of *Basic*.

You can set this macros to have infuence only in Debug and only Release configuration, as well as following options.

Framework divide all its log messages into 5 types:

* Error
* Warn
* Info
* Debug
* Verbose

They listed in priority order. If you want to filter out some of them you can specify one more macros from following options:

* **ROAD_LOGGING_LEVEL_ERROR**
* **ROAD_LOGGING_LEVEL_WARN**
* **ROAD_LOGGING_LEVEL_INFO**
* **ROAD_LOGGING_LEVEL_DEBUG**

Each of these options shut out log messages with less priority than specified. But we also have one more option for filtering:

* **ROAD_LOGGING_SERIALIZATION_DISABLED**
* **ROAD_LOGGING_WEB_SERVICE_DISABLED**

With these options you could disable log messages from one of component: Serialization or Web Service.

###CocoaPods

If you use preferred method of installation - via CocoaPods - you may probably wonder how to persist your logging setting between `pod install`. The answer is `post_install` hook. With already existing configuration your post install hook should look like: 

```ruby
post_install do |installer|
    require File.expand_path('ROADConfigurator.rb', './Pods/libObjCAttr/libObjCAttr/Resources/')
    ROADConfigurator::post_install(installer)
   installer.project.targets.each do |target|
    if (target.name == 'Pods-ROADFramework')
      target.build_configurations.each do |config|
        # if you want to have logging for all configuration, feel free to remove this following if clause
        if (config.name == 'Debug')
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited) DEBUG=1 ROAD_LOGGING_NSLOG' # list all settings here
        end
      end
    end
  end
end
```
