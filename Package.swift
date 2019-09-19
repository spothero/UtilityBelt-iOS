// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    products: [
        .library(name: "Sham", targets: ["Sham"]),
        .library(name: "UtilityBelt", targets: ["UtilityBeltNetworking"]),
        .library(name: "UtilityBeltNetworking", targets: ["UtilityBeltNetworking"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.10"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.33.1"),
        .package(url: "https://github.com/spothero/Zinc", from: "0.5.0"),
    ],
    targets: [
        .target(
            name: "Sham",
            dependencies: [
                .target(name: "UtilityBeltNetworking")
            ]
        ),
        .target(
            name: "UtilityBeltNetworking",
            dependencies: []
        ),
        .testTarget(
            name: "ShamTests",
            dependencies: [
                .target(name: "Sham")
            ]
        ),
        .testTarget(
            name: "UtilityBeltNetworkingTests",
            dependencies: [
                .target(name: "Sham"),
                .target(name: "UtilityBeltNetworking")
            ]
        )
    ]
)
