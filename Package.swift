// swift-tools-version:5.1

// Copyright © 2019 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    platforms: [
        .iOS(.v10),         // supports NSPersistentContainer
        .macOS(.v10_12),    // supports NSPersistentContainer
        .tvOS(.v10),        // supports NSPersistentContainer
        .watchOS(.v3),      // supports NSPersistentContainer
    ],
    products: [
        .library(name: "Sham", targets: ["Sham"]),
        .library(name: "UtilityBeltData", targets: ["UtilityBeltData"]),
        .library(name: "UtilityBeltNetworking", targets: ["UtilityBeltNetworking"]),
        .library(name: "UtilityBeltUITesting", targets: ["UtilityBeltUITesting"]),
        // Dynamic Libraries
        // These libraries are required due to the Xcode 11.3+ static linking bug: https://bugs.swift.org/browse/SR-12303
        .library(name: "ShamDynamic", type: .dynamic, targets: ["Sham"]),
        .library(name: "UtilityBeltDataDynamic", type: .dynamic, targets: ["UtilityBeltData"]),
        .library(name: "UtilityBeltNetworkingDynamic", type: .dynamic, targets: ["UtilityBeltNetworking"]),
        .library(name: "UtilityBeltUITestingDynamic", type: .dynamic, targets: ["UtilityBeltUITesting"]),
    ],
    dependencies: [],
    targets: [
        // Library Product Targets
        .target(
            name: "Sham",
            dependencies: [
                .target(name: "UtilityBeltNetworking"),
            ]
        ),
        .target(name: "UtilityBeltData"),
        .target(name: "UtilityBeltNetworking"),
        .target(
            name: "UtilityBeltUITesting",
            dependencies: [
                .target(name: "Sham"),
            ]
        ),
        // Test Targets
        .testTarget(
            name: "ShamTests",
            dependencies: [
                .target(name: "Sham"),
            ]
        ),
        .testTarget(
            name: "UtilityBeltDataTests",
            dependencies: [
                .target(name: "UtilityBeltData"),
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
