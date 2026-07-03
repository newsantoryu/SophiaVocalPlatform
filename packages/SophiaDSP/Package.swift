// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "SophiaDSP",

    products: [
        .library(
            name: "SophiaDSP",
            targets: ["SophiaDSP"]
        )
    ],

    targets: [
        .target(
            name: "SophiaDSP"
        ),

        .testTarget(
            name: "SophiaDSPTests",
            dependencies: ["SophiaDSP"]
        )
    ]
)