// swift-tools-version: 6.2
// Package manifest for the SudoClaw macOS companion (menu bar app + IPC library).

import PackageDescription

let package = Package(
    name: "SudoClaw",
    platforms: [
        .macOS(.v15),
    ],
    products: [
        .library(name: "SudoClawIPC", targets: ["SudoClawIPC"]),
        .library(name: "SudoClawDiscovery", targets: ["SudoClawDiscovery"]),
        .executable(name: "SudoClaw", targets: ["SudoClaw"]),
        .executable(name: "sudoclaw-mac", targets: ["SudoClawMacCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/orchetect/MenuBarExtraAccess", exact: "1.2.2"),
        .package(url: "https://github.com/swiftlang/swift-subprocess.git", from: "0.1.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.8.0"),
        .package(url: "https://github.com/sparkle-project/Sparkle", from: "2.8.1"),
        .package(url: "https://github.com/steipete/Peekaboo.git", branch: "main"),
        .package(path: "../shared/SudoClawKit"),
        .package(path: "../../Swabble"),
    ],
    targets: [
        .target(
            name: "SudoClawIPC",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .target(
            name: "SudoClawDiscovery",
            dependencies: [
                .product(name: "SudoClawKit", package: "SudoClawKit"),
            ],
            path: "Sources/SudoClawDiscovery",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "SudoClaw",
            dependencies: [
                "SudoClawIPC",
                "SudoClawDiscovery",
                .product(name: "SudoClawKit", package: "SudoClawKit"),
                .product(name: "SudoClawChatUI", package: "SudoClawKit"),
                .product(name: "SudoClawProtocol", package: "SudoClawKit"),
                .product(name: "SwabbleKit", package: "swabble"),
                .product(name: "MenuBarExtraAccess", package: "MenuBarExtraAccess"),
                .product(name: "Subprocess", package: "swift-subprocess"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "Sparkle", package: "Sparkle"),
                .product(name: "PeekabooBridge", package: "Peekaboo"),
                .product(name: "PeekabooAutomationKit", package: "Peekaboo"),
            ],
            exclude: [
                "Resources/Info.plist",
            ],
            resources: [
                .copy("Resources/SudoClaw.icns"),
                .copy("Resources/DeviceModels"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .executableTarget(
            name: "SudoClawMacCLI",
            dependencies: [
                "SudoClawDiscovery",
                .product(name: "SudoClawKit", package: "SudoClawKit"),
                .product(name: "SudoClawProtocol", package: "SudoClawKit"),
            ],
            path: "Sources/SudoClawMacCLI",
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
            ]),
        .testTarget(
            name: "SudoClawIPCTests",
            dependencies: [
                "SudoClawIPC",
                "SudoClaw",
                "SudoClawDiscovery",
                .product(name: "SudoClawProtocol", package: "SudoClawKit"),
                .product(name: "SwabbleKit", package: "swabble"),
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency"),
                .enableExperimentalFeature("SwiftTesting"),
            ]),
    ])
