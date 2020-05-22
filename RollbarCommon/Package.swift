// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RollbarCommon",
    platforms: [
        // Oldest targeted platform versions that are supported by this product.
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v11),
        .watchOS(.v4),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RollbarCommon",
            targets: ["RollbarCommon"]),
//        .library(
//            name: "RollbarCommonStatic",
//            type: .static,
//            targets: ["RollbarCommon"]),
//        .library(
//            name: "RollbarCommonDynamic",
//            type: .dynamic,
//            targets: ["RollbarCommon"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RollbarCommon",
            dependencies: [],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("Sources/RollbarCommon/**"),
//                .headerSearchPath("Sources/RollbarCommon"),
//                .headerSearchPath("Sources/RollbarCommon/include"),
//                .headerSearchPath("Sources/RollbarCommon/DTOs"),
                
//                .define("DEFINES_MODULE"),
            ]
        ),
        .testTarget(
            name: "RollbarCommonTests",
            dependencies: ["RollbarCommon"]),
    ]
)
