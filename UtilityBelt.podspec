Pod::Spec.new do |spec|
  # Root Specification
  spec.name = 'UtilityBelt'
  spec.version = '0.2.0'

  spec.author = 'SpotHero, Inc.'
  spec.homepage = 'https://github.com/spothero/UtilityBelt-iOS'
  spec.license = 'Commercial'
  spec.source = { :git => 'https://github.com/spothero/UtilityBelt-iOS.git',
                  :tag => "#{spec.version}" }
  spec.summary = 'UtilityBelt is a collection of common Swift utility files.'

  # Platform
  spec.ios.deployment_target = '8.0'
  spec.osx.deployment_target = '10.10'
  spec.tvos.deployment_target = '9.0'
  spec.watchos.deployment_target = '2.0'

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
end
