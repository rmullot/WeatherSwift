// swift-tools-version:5.7
import PackageDescription

// This package exists ONLY to vendor command-line build tools (SwiftGen, SwiftLint)
// via SwiftPM instead of CocoaPods. It ships no source of its own; the app's
// SwiftLint / SwiftGen build phases invoke the tools with:
//   swift run -c release swiftgen ...
//   swift run -c release swiftlint ...
let package = Package(
    name: "BuildTools",
    platforms: [.macOS(.v10_15)],
    dependencies: [
        .package(url: "https://github.com/SwiftGen/SwiftGen.git", exact: "6.6.2"),
        .package(url: "https://github.com/realm/SwiftLint.git", exact: "0.54.0"),
    ],
    targets: [
        .executableTarget(name: "BuildTools", path: "Sources")
    ]
)
