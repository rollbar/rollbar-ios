Pod::Spec.new do |s|

  s.version                   = "1.8.4"
  s.name                      = "Rollbar"
  s.summary                   = "Objective-C library for crash reporting and logging with Rollbar. It works on iOS and macOS."
  s.description               = <<-DESC
    Find, fix, and resolve errors with Rollbar.
    Easily send error data using Rollbar's API.
    Analyze, de-dupe, send alerts, and prepare the data for further analysis.
    Search, sort, and prioritize via the Rollbar dashboard.
                                DESC
  s.homepage                  = "https://rollbar.com"
  s.license                   = { :type => "MIT", :file => "LICENSE" }
  s.author                    = { "Rollbar" => "support@rollbar.com" }
  s.social_media_url          = "http://twitter.com/rollbar"
  s.ios.deployment_target     = '8.0'
  s.osx.deployment_target     = '10.12'
  s.source                    = { :git => "https://github.com/rollbar/rollbar-ios.git", 
                           :tag => "v#{s.version}", 
                           :submodules => true
                           }

  s.source_files        = 'KSCrash/Source/KSCrash/**/*.{m,h,mm,c,cpp}',
                          'Rollbar/*.{h,m}',
                          'Rollbar/Deploys/*.{h,m}'

  s.public_header_files = 'Rollbar/Rollbar.h',
                          'Rollbar/RollbarNotifier.h',
                          'Rollbar/RollbarConfiguration.h',
                          'Rollbar/RollbarLevel.h',
                          'Rollbar/RollbarJSONFriendlyProtocol.h',
                          'Rollbar/RollbarJSONFriendlyObject.h',
                          'Rollbar/RollbarTelemetry.h',
                          'Rollbar/RollbarTelemetryType.h',
                          'Rollbar/RollbarKSCrashReportSink.h',
                          'Rollbar/RollbarKSCrashInstallation.h',                          
                          'Rollbar/Deploys/RollbarDeploysProtocol.h',
                          'Rollbar/Deploys/RollbarDeploysManager.h',
                          'Rollbar/Deploys/Deployment.h',
                          'Rollbar/Deploys/DeploymentDetails.h',
                          'Rollbar/Deploys/DeployApiCallResult.h',
                          'KSCrash/Source/KSCrash/Recording/KSCrash.h',
                          'KSCrash/Source/KSCrash/Installations/KSCrashInstallation.h',
                          'KSCrash/Source/KSCrash/Installations/KSCrashInstallation+Private.h',
                          'KSCrash/Source/KSCrash/Reporting/Filters/KSCrashReportFilterBasic.h',
                          'KSCrash/Source/KSCrash/Reporting/Filters/KSCrashReportFilterAppleFmt.h',
                          'KSCrash/Source/KSCrash/Recording/KSCrashReportWriter.h',
                          'KSCrash/Source/KSCrash/Reporting/Filters/KSCrashReportFilter.h',
                          'KSCrash/Source/KSCrash/Recording/Monitors/KSCrashMonitorType.h'


  s.ios.frameworks = 
                "Foundation",
                "SystemConfiguration",
                "UIKit",
                "MessageUI"
  s.osx.frameworks = 
                "Foundation",
                "SystemConfiguration"
  s.libraries = 
                "c++", 
                "z"
  s.requires_arc = true

end
