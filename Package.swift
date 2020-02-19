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
                        .library(name: "Rollbar", targets: ["Rollbar"]),
                        //.library(name: "RollbarStatic", type: .static, targets: ["Rollbar"]),
                        //.library(name: "RollbarDynamic", type: .dynamic, targets: ["Rollbar"]),
                        ],
                      targets: [
                        .target(name: "Rollbar",
                                path: ".",
                                exclude: [
                                    "build",
                                    "Dist",
                                    "Examples",

                                    "KSCrash/Android",
                                    "KSCrash/Example-Reports",
                                    "KSCrash/iOS",
                                    "KSCrash/Mac",
                                    "KSCrash/tests",
                                    "KSCrash/TVOS",
                                    "KSCrash/WatchOS",
                                    "KSCrash/Webapp",
                                    "KSCrash/Source/Framework",
                                    "KSCrash/Source/Common-Examples",
                                    "KSCrash/Source/CrashProbe",
                                    "KSCrash/Source/KSCrash-Tests",

                                    "RollbarFramework",
                                    "RollbarKit-iOSTests",
                                    "RollbarKit-macOSTests",
                                    "RollbarTests",
                                ],
                                publicHeadersPath: "RollbarSwiftPM",
                                cSettings: [
                                    .headerSearchPath("KSCrash/Source/KSCrash/Installations"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm/Support"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm/Config"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm/ADT"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Recording"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Recording/Monitors"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Recording/Tools"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Filters"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Filters/Tools"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Sinks"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Tools"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/swift"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/swift/Basic"),

                                    .headerSearchPath("Rollbar"),
                                    .headerSearchPath("Rollbar/DTOs"),
                                    .headerSearchPath("Rollbar/Deploys"),
                                    .headerSearchPath("RollbarSwiftPM"),

                                    .define("DEFINES_MODULE"),
                                    ],
                                cxxSettings: [
                                    .headerSearchPath("KSCrash/Source/KSCrash/Installations"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm/Support"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm/Config"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/llvm/ADT"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Recording"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Recording/Monitors"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Recording/Tools"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Filters"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Filters/Tools"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Sinks"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/Reporting/Tools"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/swift"),
                                    .headerSearchPath("KSCrash/Source/KSCrash/swift/Basic"),

                                    .headerSearchPath("Rollbar"),
                                    .headerSearchPath("Rollbar/DTOs"),
                                    .headerSearchPath("Rollbar/Deploys"),
                                    .headerSearchPath("RollbarSwiftPM"),

                                    .define("DEFINES_MODULE"),
                                    ]//,
//                                    linkerSettings: [
//                                        .linkedLibrary("libz"),
//                                        .linkedLibrary("libc++"),
//                                    ]
                        ),
                      ],
                      swiftLanguageVersions: [.v5],
                      cLanguageStandard: .gnu99,
                      cxxLanguageStandard: .gnucxx11
)
