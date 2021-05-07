// swift-tools-version:5.2

// Copyright © 2021 SpotHero, Inc. All rights reserved.

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
        .library(name: "Sham_XCTestSupport", targets: ["Sham_XCTestSupport"]),
        .library(name: "UtilityBeltData", targets: ["UtilityBeltData"]),
        .library(name: "UtilityBeltNetworking", targets: ["UtilityBeltNetworking"]),
        .library(name: "UtilityBeltUITesting", targets: ["UtilityBeltUITesting"]),
        .library(name: "UtilityBeltUITesting_XCTestSupport", targets: ["UtilityBeltUITesting_XCTestSupport"]),
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
        .target(
            name: "Sham_XCTestSupport",
            dependencies: [
                .target(name: "Sham"),
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
        .target(
            name: "UtilityBeltUITesting_XCTestSupport",
            dependencies: [
                .target(name: "UtilityBeltUITesting"),
            ]
        ),
        // Test Targets
        .testTarget(
            name: "ShamTests",
            dependencies: [
                .target(name: "Sham"),
                .target(name: "Sham_XCTestSupport"),
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
        .testTarget(
            name: "UtilityBeltUITestingTests",
            dependencies: [
                .target(name: "UtilityBeltUITesting"),
            ]
        ),
    ],
    swiftLanguageVersions: [
        .v5,
    ]
)
