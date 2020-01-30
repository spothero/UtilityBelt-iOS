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
end
