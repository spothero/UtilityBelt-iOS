// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "UtilityBelt",
    products: [
        .library(name: "UtilityBelt", targets: ["UtilityBelt"]),
    ],
    dependencies: [
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
