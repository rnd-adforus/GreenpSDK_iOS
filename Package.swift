// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GreenPFramework",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "GreenPFramework",
            targets: ["GreenPFramework"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.1"),
         .package(url: "https://github.com/onevcat/Kingfisher.git", from: "7.10.0"),
         .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
         .package(name: "UAdFramework", url: "https://github.com/adbcsdk/ADBC-UAd.git", from: "1.0.4"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "GreenPFramework",
            dependencies: ["Kingfisher", "Alamofire", "SnapKit", "UAdFramework"],
            resources: [.process("Fonts"), Resource.process("Assets.xcassets")]),
        .testTarget(
            name: "GreenPFrameworkTests",
            dependencies: ["GreenPFramework"])
    ]
)
