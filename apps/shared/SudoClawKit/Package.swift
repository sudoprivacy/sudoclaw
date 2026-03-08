// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "SudoClawKit",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
    ],
    products: [
        .library(name: "SudoClawProtocol", targets: ["SudoClawProtocol"]),
        .library(name: "SudoClawKit", targets: ["SudoClawKit"]),
        .library(name: "SudoClawChatUI", targets: ["SudoClawChatUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/steipete/ElevenLabsKit", exact: "0.1.0"),
        .package(url: "https://github.com/gonzalezreal/textual", exact: "0.3.1"),
    ],
    targets: [
        .target(
            name: "SudoClawProtocol",
            path: "Sources/SudoClawProtocol",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "SudoClawKit",
            dependencies: [
                "SudoClawProtocol",
                .product(name: "ElevenLabsKit", package: "ElevenLabsKit"),
            ],
            path: "Sources/SudoClawKit",
            resources: [
                .process("Resources"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "SudoClawChatUI",
            dependencies: [
                "SudoClawKit",
                .product(
                    name: "Textual",
                    package: "textual",
                    condition: .when(platforms: [.macOS, .iOS])),
            ],
            path: "Sources/SudoClawChatUI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "SudoClawKitTests",
            dependencies: ["SudoClawKit", "SudoClawChatUI"],
            path: "Tests/SudoClawKitTests",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
