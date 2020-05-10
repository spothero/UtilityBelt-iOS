# UtilityBelt-iOS

[![Build Status](https://app.bitrise.io/app/998bf00ec3834716/status.svg?token=afkazBEiSRY9D1wIn9OpgQ&branch=master)](https://app.bitrise.io/app/998bf00ec3834716)

UtilityBelt is a collection of utilities used across various applications and libraries.

>:warning: The code in this library has been provided as-is. SpotHero uses this library in Production, but it may lack the documentation, stability, and functionality necessary to support external use. While we work on improving this codebase, **use this library at your own risk** and please [reach out](#communication) if you have any questions or feedback.

- [Installation](#installation)
- [Communication](#communication)

## Installation

### Swift Package Manager

[Swift Package Manager](https://swift.org/package-manager/) is built into the Swift toolchain and is our preferred way of integrating the SDK.

For Swift package projects, simply add the following line to your `Package.swift` file in the `dependencies` section:

```swift
dependencies: [
  .package(url: "https://github.com/spothero/UtilityBelt-iOS", .upToNextMajor(from: "<version>")),
]
```

For app projects, simply follow the [Apple documentation](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) on adding package dependencies to your app.

## Communication

For all bug reports, feature requests, and general communication, please open an issue to get in contact with us.
