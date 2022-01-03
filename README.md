# UtilityBelt-iOS

[![CI Status](https://github.com/spothero/UtilityBelt-iOS/workflows/CI/badge.svg)](https://github.com/spothero/UtilityBelt-iOS/actions?query=workflow%3A%22CI%22)
[![Latest Release](https://img.shields.io/github/v/tag/spothero/UtilityBelt-iOS?color=blue&label=latest)](https://github.com/spothero/UtilityBelt-iOS/releases)
[![Swift Version](https://img.shields.io/static/v1?label=swift&message=5.2&color=red&logo=swift&logoColor=white)](https://developer.apple.com/swift)
[![Platform Support](https://img.shields.io/static/v1?label=platform&message=iOS%20|%20macOS%20|%20watchOS%20|%20tvOS&color=darkgray)](https://github.com/spothero/UtilityBelt-iOS/blob/main/Package.swift)
[![License](https://img.shields.io/github/license/spothero/UtilityBelt-iOS)](https://github.com/spothero/UtilityBelt-iOS/blob/main/LICENSE)

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

## Libraries
UtilityBelt contains the following libraries:

- [UtilityBeltNetworking](./Sources/UtilityBeltNetworking): A lightweight HTTP client.
- [Sham](./Sources/Sham): A tool to enable mocking network requests.
- [Sham_XCTestSupport](./Sources/Sham_XCTestSupport): Sham extensions for XCTest.

## Communication

For all bug reports, feature requests, and general communication, please open an issue to get in contact with us.
