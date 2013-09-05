Pod::Spec.new do |s|

  s.name         = 'SparkFramework'
  s.version      = '0.0.1'
  s.summary      = 'Spark iOS Framework'

  s.description  = <<-DESC
                   Spark Framework is a collection of libraries, tools and guidelines to handle common routines like web services integration, serialization, logging and others. As result Spark accelerates development, streamline support and maintenance, enforce best practices as well as remove technology entropy and fragmentation. Framework architecture allows to use libraries in application independently as well as all together to benefit from capabilities of each other.
                   DESC
  s.homepage     = 'https://github.com/epam/spark-ios-framework'
  s.license      = 'Copyright (c) 2013 Epam Systems. All rights reserved'

  s.author       = { 'Epam Systems' => 'support.spark@epam.com' }

  s.platform = :ios
  s.ios.deployment_target = '5.0'

  s.requires_arc = true

  s.source       = { :git => 'https://github.com/edl00k/spark-ios-framework.git', :tag => '0.0.1' }
  

  s.subspec 'SparkReflection' do |rf|
    rf.source_files = 'Framework/SparkReflection/SparkReflection/**/*.{h,m}'
    rf.public_header_files = 'Framework/SparkReflection/SparkReflection/SparkReflection.h'
  end

  s.subspec 'SparkCore' do |core|
    core.source_files = 'Framework/SparkCore/SparkCore/**/*.{h,m}'
    core.public_header_files = 'Framework/SparkCore/SparkCore/SparkCore.h'
    core.dependency 'SparkFramework/SparkReflection'
  end

end