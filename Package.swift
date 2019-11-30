// swift-tools-version:5.1

// Copyright © 2019 SpotHero, Inc. All rights reserved.

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    platforms: [
        .iOS(.v10),         // supports NSPersistentContainer and os_log
        .macOS(.v10_12),    // supports NSPersistentContainer and os_log
        .tvOS(.v10),        // supports NSPersistentContainer and os_log
        .watchOS(.v3),      // supports NSPersistentContainer and os_log
    ],
    products: [
        .library(name: "Sham", targets: ["Sham"]),
        .library(name: "UtilityBelt", targets: ["UtilityBeltData", "UtilityBeltDebugging", "UtilityBeltNetworking"]),
        .library(name: "UtilityBeltData", targets: ["UtilityBeltData"]),
        .library(name: "UtilityBeltDebugging", targets: ["UtilityBeltDebugging"]),
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
            name: "UtilityBeltData",
            dependencies: []
        ),
        .target(
            name: "UtilityBeltDebugging",
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
