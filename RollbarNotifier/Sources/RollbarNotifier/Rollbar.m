//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import RollbarCommon;

#import "Rollbar.h"
#import "RollbarLogger.h"
#import "RollbarConfig.h"
#import "RollbarDestination.h"
#import "RollbarTelemetryOptions.h"
#import "RollbarTelemetryOptionsObserver.h"
#import "RollbarScrubbingOptions.h"
#import "RollbarCrashProcessor.h"

@implementation Rollbar

static RollbarLogger *logger = nil;
static RollbarTelemetryOptionsObserver *telemetryOptionsObserver = nil;
static id<RollbarCrashCollector> crashCollector = nil;
static RollbarCrashProcessor *crashProcessor = nil;

+ (void)initialize {
    if (self == [Rollbar class]) {
        telemetryOptionsObserver = [RollbarTelemetryOptionsObserver new];
    }
}

+ (void)initWithAccessToken:(NSString *)accessToken {
    
    [Rollbar initWithAccessToken:accessToken
                   configuration:nil
                  crashCollector:nil];
}

+ (void)initWithConfiguration:(RollbarConfig *)configuration {
    
    [Rollbar initWithAccessToken:nil
                   configuration:configuration
                  crashCollector:nil];
}


+ (void)initWithAccessToken:(NSString *)accessToken
             crashCollector:(nullable id<RollbarCrashCollector>)crashCollector {

    [Rollbar initWithAccessToken:accessToken
                   configuration:nil
                  crashCollector:crashCollector];
}

+ (void)initWithConfiguration:(RollbarConfig *)configuration
               crashCollector:(nullable id<RollbarCrashCollector>)crashCollector {

    [Rollbar initWithAccessToken:nil
                   configuration:configuration
                  crashCollector:crashCollector];
}

+ (void)initWithAccessToken:(nullable NSString *)accessToken
              configuration:(nullable RollbarConfig *)configuration
             crashCollector:(nullable id<RollbarCrashCollector>)crashCollector {

    [RollbarTelemetry sharedInstance]; // Load saved data, if any
    if (logger) {
        RollbarSdkLog(@"Rollbar has already been initialized.");
    } else {
        RollbarConfig *config = configuration ? configuration : [RollbarConfig new];
        if (accessToken && accessToken.length > 0) {
            config.destination.accessToken = accessToken;
        }
        [Rollbar updateConfiguration:config];

        if (crashCollector) {
            crashProcessor = [[RollbarCrashProcessor alloc] init];
            [crashCollector collectCrashReportsWithObserver:crashProcessor];
        }
    }
}

+ (RollbarConfig *)currentConfiguration {
    
    return logger.configuration;
}

+ (RollbarLogger *)currentLogger {
    
    return logger;
}

+ (void)updateConfiguration:(RollbarConfig *)configuration {
    
//    if (logger && logger.configuration && logger.configuration.telemetry) {
//        [telemetryOptionsObserver unregisterAsObserverForTelemetryOptions:logger.configuration.telemetry];
//    }

    if (logger) {
        [logger updateConfiguration:configuration];
    }
    else {
        logger = [[RollbarLogger alloc] initWithConfiguration:configuration];
    }
    
//    if (logger && logger.configuration && logger.configuration.telemetry) {
//        [telemetryOptionsObserver registerAsObserverForTelemetryOptions:logger.configuration.telemetry];
//    }
    
    if (configuration && configuration.telemetry) {
        [RollbarTelemetry sharedInstance].enabled = configuration.telemetry.enabled;
        [RollbarTelemetry sharedInstance].scrubViewInputs = configuration.telemetry.viewInputsScrubber.enabled;
        [RollbarTelemetry sharedInstance].viewInputsToScrub =
            [NSSet setWithArray:configuration.telemetry.viewInputsScrubber.scrubFields].mutableCopy;
        [[RollbarTelemetry sharedInstance] setCaptureLog:configuration.telemetry.captureLog];
        [[RollbarTelemetry sharedInstance] setDataLimit:configuration.telemetry.maximumTelemetryData];
    }
}

+ (void)reapplyConfiguration {
    [Rollbar updateConfiguration:Rollbar.currentConfiguration];
}

#pragma mark - Logging methods

+ (void)logCrashReport:(NSString *)crashReport {
    
    [logger logCrashReport:crashReport];
}

+ (void)log:(RollbarLevel)level
    message:(NSString *)message {

    [logger log:level
        message:message
           data:nil
        context:nil];
}

+ (void)log:(RollbarLevel)level
  exception:(NSException *)exception {

    [logger log:level
      exception:exception
           data:nil
        context:nil];
}

+ (void)log:(RollbarLevel)level
      error:(NSError *)error {
    
    [logger log:level
          error:error
           data:nil
        context:nil];
}

+ (void)log:(RollbarLevel)level
    message:(NSString *)message
       data:(NSDictionary<NSString *, NSObject *> *)data {
    
    [logger log:level
        message:message
           data:data
        context:nil];
}

+ (void)log:(RollbarLevel)level
  exception:(NSException *)exception
       data:(NSDictionary<NSString *, NSObject *> *)data {
    
    [logger log:level
      exception:exception
           data:data
        context:nil];
}

+ (void)log:(RollbarLevel)level
      error:(NSError *)error
       data:(NSDictionary<NSString *, id> *)data {
    
    [logger log:level
          error:error
           data:data
        context:nil];
}

+ (void)log:(RollbarLevel)level
    message:(NSString *)message
       data:(NSDictionary<NSString *, NSObject *> *)data
    context:(NSString *)context {

    [logger log:level
        message:message
           data:data
        context:context];
}

+ (void)log:(RollbarLevel)level
  exception:(NSException *)exception
       data:(NSDictionary<NSString *, NSObject *> *)data
    context:(NSString *)context {

    [logger log:level
      exception:exception
           data:data
        context:context];
}

+ (void)log:(RollbarLevel)level
      error:(NSError *)error
       data:(NSDictionary<NSString *, id> *)data
    context:(NSString *)context {
    
    [logger log:level
          error:error
           data:data
        context:context];
}

#pragma mark - Convenience logging methods

+ (void)debugMessage:(NSString *)message {
    [Rollbar log:RollbarLevel_Debug message:message data:nil context:nil];
}
+ (void)debugException:(NSException *)exception {
    [Rollbar log:RollbarLevel_Debug exception:exception data:nil context:nil];
}
+ (void)debugError:(NSError *)error {
    [Rollbar log:RollbarLevel_Debug error:error data:nil context:nil];
}

+ (void)debugMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Debug message:message data:data context:nil];
}
+ (void)debugException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Debug exception:exception data:data context:nil];
}
+ (void)debugError:(NSError *)error data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Debug error:error data:data context:nil];
}

+ (void)debugMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Debug message:message data:data context:context];
}
+ (void)debugException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Debug exception:exception data:data context:context];
}
+ (void)debugError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Debug error:error data:data context:context];
}



+ (void)infoMessage:(NSString *)message {
    [Rollbar log:RollbarLevel_Info message:message data:nil context:nil];
}
+ (void)infoException:(NSException *)exception {
    [Rollbar log:RollbarLevel_Info exception:exception data:nil context:nil];
}
+ (void)infoError:(NSError *)error {
    [Rollbar log:RollbarLevel_Info error:error data:nil context:nil];
}

+ (void)infoMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Info message:message data:data context:nil];
}
+ (void)infoException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Info exception:exception data:data context:nil];
}
+ (void)infoError:(NSError *)error data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Info error:error data:data context:nil];
}

+ (void)infoMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Info message:message data:data context:context];
}
+ (void)infoException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Info exception:exception data:data context:context];
}
+ (void)infoError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Info error:error data:data context:context];
}



+ (void)warningMessage:(NSString *)message {
    [Rollbar log:RollbarLevel_Warning message:message data:nil context:nil];
}
+ (void)warningException:(NSException *)exception {
    [Rollbar log:RollbarLevel_Warning exception:exception data:nil context:nil];
}
+ (void)warningError:(NSError *)error {
    [Rollbar log:RollbarLevel_Warning error:error data:nil context:nil];
}

+ (void)warningMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Warning message:message data:data context:nil];
}
+ (void)warningException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Warning exception:exception data:data context:nil];
}
+ (void)warningError:(NSError *)error data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Warning error:error data:data context:nil];
}

+ (void)warningMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Warning message:message data:data context:context];
}
+ (void)warningException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Warning exception:exception data:data context:context];
}
+ (void)warningError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Warning error:error data:data context:context];
}



+ (void)errorMessage:(NSString *)message {
    [Rollbar log:RollbarLevel_Error message:message data:nil context:nil];
}
+ (void)errorException:(NSException *)exception {
    [Rollbar log:RollbarLevel_Error exception:exception data:nil context:nil];
}
+ (void)errorError:(NSError *)error {
    [Rollbar log:RollbarLevel_Error error:error data:nil context:nil];
}

+ (void)errorMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Error message:message data:data context:nil];
}
+ (void)errorException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Error exception:exception data:data context:nil];
}
+ (void)errorError:(NSError *)error data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Error error:error data:data context:nil];
}

+ (void)errorMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Error message:message data:data context:context];
}
+ (void)errorException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Error exception:exception data:data context:context];
}
+ (void)errorError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Error error:error data:data context:context];
}



+ (void)criticalMessage:(NSString *)message {
    [Rollbar log:RollbarLevel_Critical message:message data:nil context:nil];
}
+ (void)criticalException:(NSException *)exception {
    [Rollbar log:RollbarLevel_Critical exception:exception data:nil context:nil];
}
+ (void)criticalError:(NSError *)error {
    [Rollbar log:RollbarLevel_Critical error:error data:nil context:nil];
}

+ (void)criticalMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Critical message:message data:data context:nil];
}
+ (void)criticalException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Critical exception:exception data:data context:nil];
}
+ (void)criticalError:(NSError *)error data:(NSDictionary<NSString *, id> *)data {
    [Rollbar log:RollbarLevel_Critical error:error data:data context:nil];
}

+ (void)criticalMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Critical message:message data:data context:context];
}
+ (void)criticalException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Critical exception:exception data:data context:context];
}
+ (void)criticalError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context {
    [Rollbar log:RollbarLevel_Critical error:error data:data context:context];
}

#pragma mark - Send manually constructed JSON payload

+ (void)sendJsonPayload:(NSData *)payload {

    [logger sendPayload:payload];
}

#pragma mark - Telemetry API

#pragma mark - Dom

+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element {
    [self recordViewEventForLevel:level
                          element:element
                        extraData:nil];
}

+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element
                      extraData:(NSDictionary<NSString *, NSObject *> *)extraData {
    [[RollbarTelemetry sharedInstance] recordViewEventForLevel:level
                                                       element:element
                                                     extraData:extraData];
}

#pragma mark - Network

+ (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode {
    [self recordNetworkEventForLevel:level
                              method:method
                                 url:url
                          statusCode:statusCode
                           extraData:nil];
}

+ (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode
                         extraData:(NSDictionary<NSString *, NSObject *> *)extraData {
    [[RollbarTelemetry sharedInstance] recordNetworkEventForLevel:level
                                                           method:method
                                                              url:url
                                                       statusCode:statusCode
                                                        extraData:extraData];
}

#pragma mark - Connectivity

+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status {
    [self recordConnectivityEventForLevel:level
                                   status:status
                                extraData:nil];
}

+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status
                              extraData:(NSDictionary *)extraData {
    [[RollbarTelemetry sharedInstance] recordConnectivityEventForLevel:level
                                                                status:status
                                                             extraData:extraData];
}

#pragma mark - Error

+ (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message {
    [self recordErrorEventForLevel:level
                           message:message
                         extraData:nil];
}

+ (void)recordErrorEventForLevel:(RollbarLevel)level
                       exception:(NSException *)exception {
    [self recordErrorEventForLevel:level
                           message:exception.reason
                         extraData:@{@"description": exception.description,
                                     @"class": NSStringFromClass(exception.class)}
     ];
}

+ (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message
                       extraData:(NSDictionary<NSString *, NSObject *> *)extraData {
    [[RollbarTelemetry sharedInstance] recordErrorEventForLevel:level
                                                        message:message
                                                      extraData:extraData];
}

#pragma mark - Navigation

+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to {
    [self recordNavigationEventForLevel:level
                                   from:from
                                     to:to
                              extraData:nil];
}

+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to
                            extraData:(NSDictionary<NSString *, NSObject *> *)extraData {
    [[RollbarTelemetry sharedInstance] recordNavigationEventForLevel:level
                                                                from:from
                                                                  to:to
                                                           extraData:extraData];
}

#pragma mark - Manual

+ (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(NSDictionary<NSString *, NSObject *> *)extraData {
    [[RollbarTelemetry sharedInstance] recordManualEventForLevel:level
                                                        withData:extraData];
}

#pragma mark - Log

+ (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message {
    [self recordLogEventForLevel:level
                         message:message
                       extraData:nil];
}

+ (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message
                     extraData:(NSDictionary<NSString *, NSObject *> *)extraData {
    [[RollbarTelemetry sharedInstance] recordLogEventForLevel:level
                                                      message:message
                                                    extraData:extraData];
}

@end
