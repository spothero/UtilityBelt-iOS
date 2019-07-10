// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    products: [
        .library(name: "UtilityBelt", targets: ["UtilityBelt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.40.10"),
        .package(url: "https://github.com/Realm/SwiftLint", from: "0.33.1"),
        .package(url: "https://github.com/spothero/Zinc", from: "0.5.0"),
    ],
    targets: [
        .target(
            name: "UtilityBelt",
            dependencies: [],
            path: "Sources/UtilityBelt"
        ),
        .testTarget(
            name: "UtilityBeltTests",
            dependencies: [
                .target(name: "UtilityBelt")
            ],
            path: "Tests/UtilityBeltTests"
        )
    ]
)
