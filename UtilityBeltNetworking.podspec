Pod::Spec.new do |spec|
  # Root Specification
  spec.name = 'UtilityBeltNetworking'
  spec.version = '0.5.0'

  spec.author   = { 'SpotHero' => 'ios@spothero.com' }
  spec.homepage = 'https://github.com/spothero/UtilityBelt-iOS'
  spec.license = 'Commercial'
  spec.source = { :git => 'https://github.com/spothero/UtilityBelt-iOS.git',
                  :tag => "#{spec.version}" }
  spec.summary = 'Sham is the SpotHero API Mocking layer for stubbing network responses.'

  # Platform
  spec.ios.deployment_target = '10.0'
  spec.osx.deployment_target = '10.12'
  spec.tvos.deployment_target = '10.0'
  spec.watchos.deployment_target = '3.0'
  spec.swift_versions = ['5.0', '5.1']

  # Build Settings
  spec.module_name = 'UtilityBeltNetworking'
  spec.source_files = 'Sources/UtilityBeltNetworking/**/*.swift'

  # Build Settings
  spec.module_name = 'UtilityBeltNetworking' # Temporary for SPM compatibility
  
  spec.default_subspec = 'Networking'

  # Subspecs
  # When we have Core files (files shared across multiple subspecs/modules), this subspec will be required
  # spec.subspec 'Core' do |s|
  #   s.source_files = 'Sources/UtilityBeltCore/**/*.swift'
  # end

  spec.subspec 'Networking' do |s|
    # When we have Core files (files shared across multiple subspecs/modules), this dependency will likely be required
    # s.dependency 'UtilityBelt/Core'
    s.source_files = 'Sources/UtilityBeltNetworking/**/*.swift'
  end
  
  spec.subspec 'Sham' do |s|
    # When we have Core files (files shared across multiple subspecs/modules), this dependency will likely be required
    # s.dependency 'UtilityBelt/Core'
    s.dependency 'UtilityBelt/Networking'
    s.source_files = 'Sources/Sham/**/*.swift'
    s.exclude_files = 'Sources/Sham/Extensions/XCTestCase+Stub.swift'
  end
end
