//
//  Rollbar.h
//  Rollbar
//
//  Created by Andrey Kornich on 2020-01-17.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#ifndef KSCrashFramework_h
#define KSCrashFramework_h

#import <Foundation/Foundation.h>

//#if TARGET_OS_IOS
//#import <UIKit/UIKit.h>
//#endif

//#if TARGET_OS_MACOS
//#import <Cocoa/Cocoa.h>
//#endif

//! Project version number for Rollbar.framework.
FOUNDATION_EXPORT double RollbarVersionNumber;

//! Project version string for Rollbar.framework.
FOUNDATION_EXPORT const unsigned char RollbarVersionString[];

// In this header, you should import all the public headers of your framework using statements like
// #import <Rollbar/PublicHeader.h>

// KSCrash dependencies::
#import <../KSCrash/Source/KSCrash/Recording/KSCrash.h>
#import <../KSCrash/Source/KSCrash/Recording/KSCrashReportWriter.h>
#import <../KSCrash/Source/KSCrash/Recording/Monitors/KSCrashMonitorType.h>
#import <../KSCrash/Source/KSCrash/Installations/KSCrashInstallation.h>
#import <../KSCrash/Source/KSCrash/Reporting/Filters/KSCrashReportFilterBasic.h>
#import <../KSCrash/Source/KSCrash/Reporting/Filters/KSCrashReportFilterAppleFmt.h>
#import <../KSCrash/Source/KSCrash/Reporting/Filters/KSCrashReportFilter.h>

// Notifier API:
//#import <Rollbar/Rollbar.h>
#import <../Rollbar/RollbarFacade.h>
#import <../Rollbar/RollbarNotifier.h>
#import <../Rollbar/RollbarConfiguration.h>
#import <../Rollbar/RollbarLog.h>
#import <../Rollbar/RollbarTelemetry.h>
#import <../Rollbar/RollbarTelemetryType.h>
#import <../Rollbar/RollbarKSCrashInstallation.h>
#import <../Rollbar/RollbarKSCrashReportSink.h>

// DTO Abstraction:
#import <../Rollbar/DTOs/RollbarDTOAbstraction.h>
#import <../Rollbar/DTOs/JSONSupport.h>
#import <../Rollbar/DTOs/Persistent.h>
#import <../Rollbar/DTOs/DataTransferObject.h>
#import <../Rollbar/DTOs/DataTransferObject+CustomData.h>
#import <../Rollbar/DTOs/RollbarDTOAbstraction.h>

// Configuration DTOs:
#import <../Rollbar/DTOs/CaptureIpType.h>
#import <../Rollbar/DTOs/RollbarLevel.h>
#import <../Rollbar/DTOs/RollbarConfig.h>
#import <../Rollbar/DTOs/RollbarDestination.h>
#import <../Rollbar/DTOs/RollbarDeveloperOptions.h>
#import <../Rollbar/DTOs/RollbarProxy.h>
#import <../Rollbar/DTOs/RollbarScrubbingOptions.h>
#import <../Rollbar/DTOs/RollbarServer.h>
#import <../Rollbar/DTOs/RollbarPerson.h>
#import <../Rollbar/DTOs/RollbarModule.h>
#import <../Rollbar/DTOs/RollbarTelemetryOptions.h>
#import <../Rollbar/DTOs/RollbarLoggingOptions.h>

// Payload DTOs:
#import <../Rollbar/DTOs/RollbarPayloadDTOs.h>
#import <../Rollbar/DTOs/TriStateFlag.h>
#import <../Rollbar/DTOs/HttpMethod.h>
#import <../Rollbar/DTOs/RollbarAppLanguage.h>
#import <../Rollbar/DTOs/RollbarPayload.h>
#import <../Rollbar/DTOs/RollbarData.h>
#import <../Rollbar/DTOs/RollbarBody.h>
#import <../Rollbar/DTOs/RollbarMessage.h>
#import <../Rollbar/DTOs/RollbarTrace.h>
#import <../Rollbar/DTOs/RollbarCallStackFrame.h>
#import <../Rollbar/DTOs/RollbarCallStackFrameContext.h>
#import <../Rollbar/DTOs/RollbarException.h>
#import <../Rollbar/DTOs/RollbarCrashReport.h>
#import <../Rollbar/DTOs/RollbarConfig.h>
#import <../Rollbar/DTOs/RollbarServerConfig.h>
#import <../Rollbar/DTOs/RollbarDestination.h>
#import <../Rollbar/DTOs/RollbarDeveloperOptions.h>
#import <../Rollbar/DTOs/RollbarProxy.h>
#import <../Rollbar/DTOs/RollbarScrubbingOptions.h>
#import <../Rollbar/DTOs/RollbarRequest.h>
#import <../Rollbar/DTOs/RollbarPerson.h>
#import <../Rollbar/DTOs/RollbarModule.h>
#import <../Rollbar/DTOs/RollbarTelemetryOptions.h>
#import <../Rollbar/DTOs/RollbarLoggingOptions.h>
#import <../Rollbar/DTOs/RollbarServer.h>
#import <../Rollbar/DTOs/RollbarClient.h>
#import <../Rollbar/DTOs/RollbarJavascript.h>

// Deploys API:
#import <../Rollbar/Deploys/RollbarDeploys.h>
#import <../Rollbar/Deploys/RollbarDeploysProtocol.h>
#import <../Rollbar/Deploys/RollbarDeploysManager.h>

// Deploys DTOs:
#import <../Rollbar/Deploys/RollbarDeploysDTOs.h>
#import <../Rollbar/Deploys/DeployApiCallOutcome.h>
#import <../Rollbar/Deploys/DeployApiCallResult.h>
#import <../Rollbar/Deploys/Deployment.h>
#import <../Rollbar/Deploys/DeploymentDetails.h>

#endif /* KSCrashFramework_h */
