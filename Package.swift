// swift-tools-version:5.0

// Copyright © 2019 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    platforms: [
        .iOS(.v10),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2),
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
