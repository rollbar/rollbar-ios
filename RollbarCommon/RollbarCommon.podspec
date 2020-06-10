#
#  Be sure to run `pod spec lint RollbarCommon.podspec' to ensure this is a valid spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  
  # The SDK attributes:
  # ===================
  spec.version      = "2.0.0-alpha"
  spec.description  = <<-DESC
                      Find, fix, and resolve errors with Rollbar.
                      Easily send error data using Rollbar API.
                      Analyze, de-dupe, send alerts, and prepare the data for further analysis.
                      Search, sort, and prioritize via the Rollbar dashboard.
                   DESC
  spec.homepage     = "https://rollbar.com"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  # spec.license      = "MIT (example)"
  spec.documentation_url = "https://docs.rollbar.com/docs/ios"
  spec.authors            = { "Andrey Kornich" => "akornich@gmail.com",
                              "Rollbar" => "support@rollbar.com" }
  # spec.author             = { "Andrey Kornich" => "akornich@gmail.com" }
  # Or just: spec.author    = "Andrey Kornich"
  spec.social_media_url   = "http://twitter.com/rollbar"
  spec.source             = { :git => "https://github.com/rollbar/rollbar-ios.git",
                              :tag => "v#{spec.version}",
                              :submodules => true }

  
  # This module's attributes:
  # =========================
  spec.name         = "RollbarCommon"
  spec.summary      = "Objective-C library for common components of Rollbar SDK. It works on Apple *OS."

  # Any platform, if ommited:
  # spec.platform     = :ios
  # spec.platform     = :ios, "5.0"

  #  When using multiple platforms:
  spec.ios.deployment_target = "8.0"
  spec.osx.deployment_target = "10.10"
  spec.tvos.deployment_target = "11.0"
  spec.watchos.deployment_target = "4.0"

  spec.source_files  = "Sources/RollbarCommon/**/*.{h,m}"
  # spec.exclude_files = "Classes/Exclude"
  spec.public_header_files = "Sources/RollbarCommon/include/*.h"
  spec.module_map = "Sources/RollbarCommon/include/module.modulemap"
  spec.resource = "../rollbar-logo.png"
  # spec.resources = "Resources/*.png"
  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"

  spec.framework = "Foundation"
  # spec.frameworks = "SomeFramework", "AnotherFramework"
  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"
  # spec.dependency "JSONKit", "~> 1.4"
  spec.requires_arc = true
  spec.xcconfig = {
    "USE_HEADERMAP" => "NO",
    "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Sources/RollbarCommon/**"
  }

end
