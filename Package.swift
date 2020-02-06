// swift-tools-version:5.1
import PackageDescription

let package = Package(name: "Rollbar",
                      platforms: [.macOS(.v10_12),
                                  .iOS(.v8)//,
                                  //.tvOS(.v10),
                                  //.watchOS(.v3)
                        ],
                      products: [.library(name: "Rollbar", targets: ["Rollbar-SPM"])],
                      targets: [.target(name: "Rollbar-SPM", path: "Rollbar")]
)
