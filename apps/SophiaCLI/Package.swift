// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SophiaCLI",

    platforms: [
        .macOS(.v14)
    ],

    dependencies: [
        .package(path: "../../packages/SophiaDSP")
    ],

    targets: [
        .executableTarget(
            name: "SophiaCLI",
            dependencies: [
                "SophiaDSP"
            ]
        )
    ]
)
