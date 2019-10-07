// swift-tools-version:5.0

// Copyright © 2019 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    platforms: [
        .iOS(.v8),          // minimum supported version via SPM
        .macOS(.v10_10),    // minimum supported version via SPM
        .tvOS(.v9),         // minimum supported version via SPM
        .watchOS(.v2),      // minimum supported version via SPM
    ],
    products: [
        .library(name: "UtilityBelt", targets: ["UtilityBeltNetworking"]),
        .library(name: "UtilityBeltNetworking", targets: ["UtilityBeltNetworking"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "UtilityBeltNetworking",
            dependencies: []
        ),
        .testTarget(
            name: "UtilityBeltNetworkingTests",
            dependencies: [
                .target(name: "UtilityBeltNetworking"),
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
