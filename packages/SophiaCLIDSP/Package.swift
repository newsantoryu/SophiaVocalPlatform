// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SophiaCLIDSP",

    platforms: [
        .macOS(.v14)
    ],

    dependencies: [
        .package(path: "../../packages/SophiaDSP")
    ],

    targets: [
        .executableTarget(
            name: "SophiaCLIDSP",
            dependencies: [
                "SophiaDSP"
            ]
        )
    ]
)
