#
#  Be sure to run `pod spec lint RollbarSDK.podspec' to ensure this is a valid spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |sdk|

  
    # Rollbar SDK:
    # ============
    sdk.version      = '2.0.0-alpha11'
    sdk.name         = 'RollbarSDK'
    sdk.summary      = 'Application/client side SDK for accessing the Rollbar API Server.'
    sdk.description  = <<-DESC
                      Find, fix, and resolve errors with Rollbar.
                      Easily send error data using Rollbar API.
                      Analyze, de-dupe, send alerts, and prepare the data for further analysis.
                      Search, sort, and prioritize via the Rollbar dashboard.
                   DESC
    sdk.homepage     = "https://rollbar.com"
    # sdk.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
    sdk.license      = { :type => "MIT", :file => "LICENSE" }
    # sdk.license      = "MIT (example)"
    sdk.documentation_url = "https://docs.rollbar.com/docs/ios"
    sdk.authors            = { "Andrey Kornich (Wide Spectrum Computing LLC)" => "akornich@gmail.com",
                              "Rollbar" => "support@rollbar.com" }
    # sdk.author             = { "Andrey Kornich" => "akornich@gmail.com" }
    # Or just: sdk.author    = "Andrey Kornich"
    sdk.social_media_url   = "http://twitter.com/rollbar"
    sdk.source             = { :git => "https://github.com/rollbar/rollbar-ios.git",
                              :tag => "v#{sdk.version}",
                              :submodules => true }
    sdk.resource = 'rollbar-logo.png'
    sdk.ios.deployment_target = '8.0'
    sdk.osx.deployment_target = '10.10'
    sdk.tvos.deployment_target = '11.0'
    sdk.watchos.deployment_target = '4.0'

  
    # RollbarCommon module:
    # =====================
    sdk.subspec 'RollbarCommon' do |common|
      common.name         = "RollbarCommon"

      # Any platform, if ommited:
      # common.platform     = :ios
      # common.platform     = :ios, "5.0"

      #  When using multiple platforms:
      # common.ios.deployment_target = "8.0"
      # common.osx.deployment_target = "10.10"
      # common.tvos.deployment_target = "11.0"
      # common.watchos.deployment_target = "4.0"

      common.source_files  = 'RollbarCommon/Sources/RollbarCommon/**/*.{h,m}'
      # common.exclude_files = "Classes/Exclude"
      common.public_header_files = 'RollbarCommon/Sources/RollbarCommon/include/*.h'
      # common.module_map = "RollbarCommon/Sources/RollbarCommon/include/module.modulemap"
      # common.resource = "../rollbar-logo.png"
      # common.resources = "Resources/*.png"
      # common.preserve_paths = "FilesToSave", "MoreFilesToSave"

      common.framework = "Foundation"
      # common.frameworks = "SomeFramework", "AnotherFramework"
      # common.library   = "iconv"
      # common.libraries = "iconv", "xml2"
      # common.dependency "JSONKit", "~> 1.4"
      common.requires_arc = true
      # common.xcconfig = {
      #   "USE_HEADERMAP" => "NO",
      #   "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Sources/RollbarCommon/**"
      # }
    end

    # RollbarDeploys module:
    # =====================
    sdk.subspec 'RollbarDeploys' do |deploys|
        deploys.name         = "RollbarDeploys"

        # Any platform, if ommited:
        # deploys.platform     = :ios
        # deploys.platform     = :ios, "5.0"

        #  When using multiple platforms:
        # deploys.ios.deployment_target = "8.0"
        # deploys.osx.deployment_target = "10.10"
        # deploys.tvos.deployment_target = "11.0"
        # deploys.watchos.deployment_target = "4.0"

        deploys.source_files  = 'RollbarDeploys/Sources/RollbarDeploys/**/*.{h,m}'
        # deploys.exclude_files = "Classes/Exclude"
        deploys.public_header_files = 'RollbarDeploys/Sources/RollbarDeploys/include/*.h'
        # deploys.module_map = "RollbarDeploys/Sources/RollbarDeploys/include/module.modulemap"
        # deploys.resource = "../rollbar-logo.png"
        # deploys.resources = "Resources/*.png"
        # deploys.preserve_paths = "FilesToSave", "MoreFilesToSave"

        deploys.dependency 'RollbarSDK/RollbarCommon'
        deploys.framework = "Foundation"
        # deploys.frameworks = "SomeFramework", "AnotherFramework"
        # deploys.library   = "iconv"
        # deploys.libraries = "iconv", "xml2"
        # deploys.dependency "JSONKit", "~> 1.4"
        deploys.requires_arc = true
        # deploys.xcconfig = {
        #   "USE_HEADERMAP" => "NO",
        #   "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Sources/RollbarDeploys/**"
        # }
    end

    # RollbarNotifier module:
    # =====================
    sdk.subspec 'RollbarNotifier' do |notifier|
        notifier.name         = "RollbarNotifier"

        # Any platform, if ommited:
        # notifier.platform     = :ios
        # notifier.platform     = :ios, "5.0"

        #  When using multiple platforms:
        # notifier.ios.deployment_target = "8.0"
        # notifier.osx.deployment_target = "10.10"
        # notifier.tvos.deployment_target = "11.0"
        # notifier.watchos.deployment_target = "4.0"

        notifier.source_files  = 'RollbarNotifier/Sources/RollbarNotifier/**/*.{h,m}'
        # notifier.exclude_files = "Classes/Exclude"
        notifier.public_header_files = 'RollbarNotifier/Sources/RollbarNotifier/include/*.h'
        # notifier.module_map = "RollbarNotifier/Sources/RollbarNotifier/include/module.modulemap"
        # notifier.resource = "../rollbar-logo.png"
        # notifier.resources = "Resources/*.png"
        # notifier.preserve_paths = "FilesToSave", "MoreFilesToSave"

        notifier.dependency 'RollbarSDK/RollbarCommon'
        notifier.framework = "Foundation"
        # notifier.frameworks = "SomeFramework", "AnotherFramework"
        # notifier.library   = "iconv"
        # notifier.libraries = "iconv", "xml2"
        # notifier.dependency "JSONKit", "~> 1.4"
        notifier.requires_arc = true
        # notifier.xcconfig = {
        #   "USE_HEADERMAP" => "NO",
        #   "HEADER_SEARCH_PATHS" => "$(PODS_ROOT)/Sources/RollbarNotifier/**"
        # }
    end

end
