Pod::Spec.new do |s|
  s.name         = "Rollbar"
  s.version      = "1.4.2"
  s.summary      = "Objective-C library for crash reporting and logging with Rollbar."
  s.description  = <<-DESC
    Find, fix, and resolve errors with Rollbar.
    Easily send error data using Rollbar's API.
    Analyze, de-dupe, send alerts, and prepare the data for further analysis.
    Search, sort, and prioritize via the Rollbar dashboard.
                   DESC

  s.homepage           = "https://rollbar.com"
  s.license            = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Rollbar" => "support@rollbar.com" }
  s.social_media_url   = "http://twitter.com/rollbar"
  s.platform           = :ios, "7.0"
  s.source             = { :git => "https://github.com/rollbar/rollbar-ios.git", :tag => "v1.4.2", :submodules => true}

  s.source_files       =  'KSCrash/Source/KSCrash/**/*.{m,h,mm,c,cpp}',
                          'Rollbar/*.{h,m}'

  s.public_header_files = 'Rollbar/Rollbar.h',
                          'Rollbar/RollbarNotifier.h',
                          'Rollbar/RollbarLogger.h',
                          'Rollbar/RollbarConfiguration.h',
                          'Rollbar/RollbarLevel.h',
                          'Rollbar/RollbarPayloadTruncator.h',
                          'Rollbar/RollbarReachability.h',
                          'Rollbar/RollbarFileReader.h',
                          'Rollbar/RollbarThread.h',
                          'Rollbar/RollbarTelemetry.h',
                          'Rollbar/RollbarTelemetryType.h',
                          'Rollbar/NSJSONSerialization+Rollbar.h',
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


  s.frameworks = "SystemConfiguration",
                 "MessageUI",
                 "UIKit",
                 "Foundation"
  s.libraries = "c++", "z"
  s.requires_arc = true
end
