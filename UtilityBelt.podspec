Pod::Spec.new do |spec|
  spec.name = 'UtilityBelt'
  spec.version = '0.1.0'

  spec.author = 'SpotHero, Inc.'
  spec.homepage = 'https://github.com/spothero/UtilityBelt-iOS'
  spec.license = 'Commercial'
  spec.summary = 'UtilityBelt is a collection of common Swift utility files.'

  spec.ios.deployment_target = '11.0'
  spec.watchos.deployment_target = '3.0'

  spec.source = { :git => 'https://github.com/spothero/UtilityBelt-iOS.git', :tag => "#{spec.version}" }

  # We might need to use an xcconfig to get compatibility with Xcode 10.2 / iOS 12
  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  # When we have Core files (files shared across multiple subspecs/modules), this subspec will be required
  # spec.subspec 'Core' do |s|
  #   s.source_files = 'Sources/UtilityBeltCore/**/*.swift'
  # end

  spec.subspec 'Networking' do |s|
    # When we have Core files (files shared across multiple subspecs/modules), this dependency will likely be required
    # s.dependency 'UtilityBelt/Core'
    s.source_files = 'Sources/UtilityBeltNetworking/**/*.swift'
  end
end
