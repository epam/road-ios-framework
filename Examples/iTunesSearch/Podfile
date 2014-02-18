platform :ios, '5.0'

pod 'ROADFramework', '~> 1.2.1'

post_install do |installer|
  require File.expand_path('ROADConfigurator.rb', './Pods/ROADFramework/Framework/ROADCore/ROADCore/')
  ROADConfigurator::post_install(installer)
end