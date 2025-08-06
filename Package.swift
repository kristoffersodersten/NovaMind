// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NovaMind",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "NovaMind",
            targets: ["NovaMind"])
    ],
    dependencies: [
        // Add any external dependencies here
    ],
    targets: [
        .target(
            name: "NovaMind",
            dependencies: [],
            path: "NovaMind"
        ),
        .testTarget(
            name: "NovaMindTests",
            dependencies: ["NovaMind"])
    ]
)
