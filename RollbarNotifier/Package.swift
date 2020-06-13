// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RollbarNotifier",
    platforms: [
        // Oldest targeted platform versions that are supported by this product.
        .macOS(.v10_10),
        .iOS(.v8),
        .tvOS(.v11),
//        .watchOS(.v4),
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "RollbarNotifier",
            targets: ["RollbarNotifier"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "../RollbarCommon"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "RollbarNotifier",
            dependencies: ["RollbarCommon",],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("Sources/RollbarNotifier/**"),
//                .headerSearchPath("Sources/RollbarNotifier"),
//                .headerSearchPath("Sources/RollbarNotifier/include"),
//                .headerSearchPath("Sources/RollbarNotifier/DTOs"),
                
//                .define("DEFINES_MODULE"),
            ]
        ),
        .testTarget(
            name: "RollbarNotifierTests",
            dependencies: ["RollbarNotifier"],
            cSettings: [
                .headerSearchPath("Tests/RollbarNotifierTests/**"),
//                .headerSearchPath("Sources/RollbarNotifier"),
//                .headerSearchPath("Sources/RollbarNotifier/include"),
//                .headerSearchPath("Sources/RollbarNotifier/DTOs"),
                
//                .define("DEFINES_MODULE"),
            ]
        ),
        .testTarget(
            name: "RollbarNotifierTests-ObjC",
            dependencies: ["RollbarNotifier"],
            cSettings: [
                .headerSearchPath("Tests/RollbarNotifierTests-ObjC/**"),
//                .headerSearchPath("Sources/RollbarNotifier"),
//                .headerSearchPath("Sources/RollbarNotifier/include"),
//                .headerSearchPath("Sources/RollbarNotifier/DTOs"),
                
//                .define("DEFINES_MODULE"),
            ]
        ),
    ]
)
