// swift-tools-version:5.1
import PackageDescription

let package = Package(name: "Rollbar",
                      platforms: [
                        .macOS(.v10_12),
                        .iOS(.v8)//,
                         //.tvOS(.v10),
                         //.watchOS(.v3)
                        ],
                      products: [
                        .library(name: "Rollbar", targets: ["Rollbar-SPM"]),
                        .library(name: "RollbarStatic", type: .static, targets: ["Rollbar-SPM"]),
                        .library(name: "RollbarDynamic", type: .dynamic, targets: ["Rollbar-SPM"]),
                        ],
                      targets: [
                        .target(name: "KSCrash",
                                path: "KSCrash/Source",
                                exclude: ["Common-Examples", "CrashProbe", "KSCrash-Tests"],
                                publicHeadersPath: "Framework",
                                cSettings: [
                                    .headerSearchPath("KSCrash/llvm/Support"),
                                    .headerSearchPath("KSCrash/llvm/Config"),
                                    .headerSearchPath("KSCrash/llvm/ADT"),
                                    .headerSearchPath("KSCrash/Recording"),
                                    .headerSearchPath("KSCrash/Recording/Tools"),
                                    //.headerSearchPath("KSCrash/swift/Basic"),
                                    ],
                                cxxSettings: [
                                    .headerSearchPath("KSCrash/Recording/Tools"),
                                    .headerSearchPath("KSCrash/swift/Basic"),
                                    ],
                                //swiftSettings: [],
                                linkerSettings: [
                                    .linkedLibrary("libz"),
                                    .linkedLibrary("libc++"),
                                ]
                        ),
                        .target(name: "Rollbar-SPM",
                                dependencies: ["KSCrash"],
                                path: "Rollbar"),
                        ]
)
