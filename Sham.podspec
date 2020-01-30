Pod::Spec.new do |spec|
  # Root Specification
  spec.name = 'Sham'
  spec.version = '0.5.0'

  spec.author   = { 'SpotHero' => 'ios@spothero.com' }
  spec.homepage = 'https://github.com/spothero/UtilityBelt-iOS'
  spec.license = 'Commercial'
  spec.source = { :git => 'https://github.com/spothero/UtilityBelt-iOS.git',
                  :tag => "#{spec.version}" }
  spec.summary = 'UtilityBelt is a collection of common Swift utility files.'

  # Platform
  spec.ios.deployment_target = '10.0'
  spec.osx.deployment_target = '10.12'
  spec.tvos.deployment_target = '10.0'
  spec.watchos.deployment_target = '3.0'
  spec.swift_versions = ['5.0', '5.1']

  # Build Settings
  spec.dependency = 'UtilityBeltNetworking'
  spec.module_name = 'Sham'

  # File Patterns
  spec.source_files = 'Sources/Sham/**/*.swift'
  spec.exclude_files = 'Sources/Sham/Extensions/XCTestCase+Stub.swift'
end
