// swift-tools-version:5.1

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
        .library(name: "Sham", targets: ["Sham"]),
        .library(name: "UtilityBelt", targets: ["UtilityBeltDataStorage", "UtilityBeltNetworking"]),
        .library(name: "UtilityBeltDataStorage", targets: ["UtilityBeltDataStorage"]),
        .library(name: "UtilityBeltNetworking", targets: ["UtilityBeltNetworking"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Sham",
            dependencies: [
                .target(name: "UtilityBeltNetworking"),
            ]
        ),
        .target(
            name: "UtilityBeltDataStorage",
            dependencies: []
        ),
        .target(
            name: "UtilityBeltNetworking",
            dependencies: []
        ),
        .testTarget(
            name: "ShamTests",
            dependencies: [
                .target(name: "Sham"),
            ]
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
