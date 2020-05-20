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
        .library(name: "Lincoln", targets: ["Lincoln"]),
        .library(name: "Sham", targets: ["Sham"]),
        .library(name: "UtilityBelt", targets: ["UtilityBeltData", "UtilityBeltKeychain", "UtilityBeltNetworking"]),
        .library(name: "UtilityBeltData", targets: ["UtilityBeltData"]),
        .library(name: "UtilityBeltKeychain", targets: ["UtilityBeltKeychain"]),
        .library(name: "UtilityBeltNetworking", targets: ["UtilityBeltNetworking"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Lincoln",
            dependencies: []
        ),
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
            name: "UtilityBeltKeychain",
            dependencies: []
        ),
        .target(
            name: "UtilityBeltNetworking",
            dependencies: []
        ),
        .testTarget(
            name: "LincolnTests",
            dependencies: [
                .target(name: "Lincoln"),
            ]
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
