// swift-tools-version:5.1

import PackageDescription

let package = Package(name: "Rollbar",
                      platforms: [.macOS(.v10_12),
                                  .iOS(.v8)//,
                                  //.tvOS(.v10),
                                  //.watchOS(.v3)
                        ],
                      products: [.library(name: "Rollbar", targets: ["Rollbar-iOS",
                                                                     "Rollbar-macOS",
                                                                     "RollbarKit-iOS",
                                                                     "RollbarKit-macOS"])],
                      targets: [.target(name: "Rollbar-iOS", path: "Rollbar"),
                                .target(name: "Rollbar-macOS", path: "Rollbar"),
                                .target(name: "RollbarKit-iOS", path: "Rollbar"),
                                .target(name: "RollbarKit-macOS", path: "Rollbar")
                        ]
)
