Pod::Spec.new do |s|

  s.version                   = "1.11.5"
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
                          'Rollbar/DTOs/*.{h,m}',
                          'Rollbar/Deploys/*.{h,m}'

  s.public_header_files =
                            'Rollbar/Rollbar.h',
                            'Rollbar/RollbarFacade.h',
                            'Rollbar/RollbarNotifier.h',
                            'Rollbar/RollbarConfiguration.h',
                            'Rollbar/RollbarTelemetry.h',
                            'Rollbar/RollbarTelemetryType.h',
                            'Rollbar/RollbarLog.h',
                            'Rollbar/RollbarJSONFriendlyProtocol.h',
                            'Rollbar/RollbarJSONFriendlyObject.h',
                            'Rollbar/RollbarKSCrashReportSink.h',
                            'Rollbar/RollbarKSCrashInstallation.h',
                            'Rollbar/Deploys/RollbarDeploysProtocol.h',
                            'Rollbar/Deploys/RollbarDeploysManager.h',
                            'Rollbar/Deploys/DeployApiCallOutcome.h',
                            'Rollbar/Deploys/Deployment.h',
                            'Rollbar/Deploys/DeploymentDetails.h',
                            'Rollbar/Deploys/DeployApiCallResult.h',
                            'Rollbar/Deploys/RollbarDeploysDTOs.h',
                            'Rollbar/Deploys/RollbarDeploys.h',
                            'Rollbar/DTOs/JSONSupport.h',
                            'Rollbar/DTOs/Persistent.h',
                            'Rollbar/DTOs/DataTransferObject.h',
                            'Rollbar/DTOs/DataTransferObject+CustomData.h',
                            'Rollbar/DTOs/RollbarDTOAbstraction.h',
                            'Rollbar/DTOs/RollbarLevel.h',
                            'Rollbar/DTOs/TriStateFlag.h',
                            'Rollbar/DTOs/CaptureIpType.h',
                            'Rollbar/DTOs/HttpMethod.h',
                            'Rollbar/DTOs/RollbarAppLanguage.h',
                            'Rollbar/DTOs/RollbarPayload.h',
                            'Rollbar/DTOs/RollbarData.h',
                            'Rollbar/DTOs/RollbarBody.h',
                            'Rollbar/DTOs/RollbarMessage.h',
                            'Rollbar/DTOs/RollbarTrace.h',
                            'Rollbar/DTOs/RollbarCallStackFrame.h',
                            'Rollbar/DTOs/RollbarCallStackFrameContext.h',
                            'Rollbar/DTOs/RollbarException.h',
                            'Rollbar/DTOs/RollbarCrashReport.h',
                            'Rollbar/DTOs/RollbarConfig.h',
                            'Rollbar/DTOs/RollbarServerConfig.h',
                            'Rollbar/DTOs/RollbarDestination.h',
                            'Rollbar/DTOs/RollbarDeveloperOptions.h',
                            'Rollbar/DTOs/RollbarProxy.h',
                            'Rollbar/DTOs/RollbarScrubbingOptions.h',
                            'Rollbar/DTOs/RollbarRequest.h',
                            'Rollbar/DTOs/RollbarPerson.h',
                            'Rollbar/DTOs/RollbarModule.h',
                            'Rollbar/DTOs/RollbarTelemetryOptions.h',
                            'Rollbar/DTOs/RollbarLoggingOptions.h',
                            'Rollbar/DTOs/RollbarServer.h',
                            'Rollbar/DTOs/RollbarClient.h',
                            'Rollbar/DTOs/RollbarJavascript.h',
                            'Rollbar/DTOs/RollbarPayloadDTOs.h',
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
