//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "Rollbar.h"
#import "SdkLog.h"
#import "RollbarKSCrashInstallation.h"

@implementation Rollbar

static RollbarNotifier *notifier = nil;

+ (void)enableCrashReporter {
    RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
    [installation install];
    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
        if (error) {
            SdkLog(@"Could not enable crash reporter: %@", [error localizedDescription]);
        } else if (completed) {
            [notifier processSavedItems];
        }
    }];
}

+ (void)initWithAccessToken:(NSString *)accessToken {

    [Rollbar initWithAccessToken:accessToken configuration:nil];
}

+ (void)initWithAccessToken:(NSString *)accessToken
              configuration:(RollbarConfiguration*)configuration {

    [Rollbar initWithAccessToken:accessToken configuration:configuration enableCrashReporter:YES];
}

+ (void)initWithAccessToken:(NSString *)accessToken
              configuration:(RollbarConfiguration*)configuration
        enableCrashReporter:(BOOL)enable {

    [RollbarTelemetry sharedInstance]; // Load saved data, if any
    if (notifier) {
        SdkLog(@"Rollbar has already been initialized.");
    } else {
        notifier = [[RollbarNotifier alloc] initWithAccessToken:accessToken
                                                  configuration:configuration
                                                         isRoot:YES];

        if (enable) {
            [Rollbar enableCrashReporter];
        }

        [notifier.configuration save];
    }
}

+ (RollbarConfiguration*)currentConfiguration {
    return notifier.configuration;
}

+ (RollbarNotifier*)currentNotifier {
    return notifier;
}

+ (void)updateConfiguration:(RollbarConfiguration*)configuration
                     isRoot:(BOOL)isRoot {
    [notifier updateConfiguration:configuration isRoot:isRoot];
}

#pragma mark - New logging methods

// Log

+ (void)log:(RollbarLevel)level
    message:(NSString*)message {

    [Rollbar log:level message:message exception:nil];
}

+ (void)log:(RollbarLevel)level
    message:(NSString*)message
  exception:(NSException*)exception {

    [Rollbar log:level message:message exception:exception data:nil];
}

+ (void)log:(RollbarLevel)level
    message:(NSString*)message
  exception:(NSException*)exception
       data:(NSDictionary*)data {

    [Rollbar log:level message:message exception:exception data:data context:nil];
}

+ (void)log:(RollbarLevel)level
    message:(NSString*)message
  exception:(NSException*)exception
       data:(NSDictionary*)data
    context:(NSString*)context {

    [notifier log:RollbarStringFromLevel(level)
          message:message
        exception:exception
             data:data
          context:context];
}

// Debug

+ (void)debug:(NSString*)message {
    [Rollbar debug:message exception:nil];
}

+ (void)debug:(NSString*)message
    exception:(NSException*)exception {
    [Rollbar debug:message exception:exception data:nil];
}

+ (void)debug:(NSString*)message
    exception:(NSException*)exception
         data:(NSDictionary*)data {
    [Rollbar debug:message exception:exception data:data context:nil];
}

+ (void)debug:(NSString*)message
    exception:(NSException*)exception
         data:(NSDictionary*)data
      context:(NSString*)context {
    [Rollbar log:RollbarDebug message:message exception:exception data:data context:context];
}


// Info

+ (void)info:(NSString*)message {
    [Rollbar info:message exception:nil];
}

+ (void)info:(NSString*)message
   exception:(NSException*)exception {
    [Rollbar info:message exception:exception data:nil];
}

+ (void)info:(NSString*)message
   exception:(NSException*)exception
        data:(NSDictionary*)data {
    [Rollbar info:message exception:exception data:data context:nil];
}

+ (void)info:(NSString*)message
   exception:(NSException*)exception
        data:(NSDictionary*)data
     context:(NSString*)context {
    [Rollbar log:RollbarInfo message:message exception:exception data:data context:context];
}


// Warning

+ (void)warning:(NSString*)message {
    [Rollbar info:message exception:nil];
}

+ (void)warning:(NSString*)message
      exception:(NSException*)exception {
    [Rollbar info:message exception:exception data:nil];
}

+ (void)warning:(NSString*)message
      exception:(NSException*)exception
           data:(NSDictionary*)data {
    [Rollbar info:message exception:exception data:data context:nil];
}

+ (void)warning:(NSString*)message
      exception:(NSException*)exception
           data:(NSDictionary*)data
        context:(NSString*)context {
    [Rollbar log:RollbarWarning message:message exception:exception data:data context:context];
}


// Error

+ (void)error:(NSString*)message {
    [Rollbar error:message exception:nil];
}

+ (void)error:(NSString*)message
    exception:(NSException*)exception {
    [Rollbar error:message exception:exception data:nil];
}

+ (void)error:(NSString*)message
    exception:(NSException*)exception
         data:(NSDictionary*)data {
    [Rollbar error:message exception:exception data:data context:nil];
}

+ (void)error:(NSString*)message
    exception:(NSException*)exception
         data:(NSDictionary*)data
      context:(NSString*)context {
    [Rollbar log:RollbarError message:message exception:exception data:data context:context];
}


// Critical

+ (void)critical:(NSString*)message {
    [Rollbar critical:message exception:nil];
}

+ (void)critical:(NSString*)message
       exception:(NSException*)exception {
    [Rollbar critical:message exception:exception data:nil];
}

+ (void)critical:(NSString*)message
       exception:(NSException*)exception
            data:(NSDictionary*)data {
    [Rollbar critical:message exception:exception data:data context:nil];
}

+ (void)critical:(NSString*)message
       exception:(NSException*)exception
            data:(NSDictionary*)data
         context:(NSString*)context {
    [Rollbar log:RollbarCritical message:message exception:exception data:data context:context];
}

+ (void)sendJsonPayload:(NSData*)payload {
    [notifier sendPayload:payload];
}

#pragma mark - Deprecated logging methods

// Log

+ (void)logWithLevel:(NSString*)level
             message:(NSString*)message {
    [notifier log:level message:message exception:nil data:nil context:nil];
}

+ (void)logWithLevel:(NSString*)level
             message:(NSString*)message
                data:(NSDictionary*)data {
    [notifier log:level message:message exception:nil data:data context:nil];
}

+ (void)logWithLevel:(NSString*)level
             message:(NSString*)message
                data:(NSDictionary*)data
             context:(NSString*)context {
    [notifier log:level message:message exception:nil data:data context:context];
}

+ (void)logWithLevel:(NSString*)level
                data:(NSDictionary*)data {
    [notifier log:level message:nil exception:nil data:data context:nil];
}

// Debug

+ (void)debugWithMessage:(NSString*)message {
    [notifier log:@"debug" message:message exception:nil data:nil context:nil];
}

+ (void)debugWithMessage:(NSString*)message
                    data:(NSDictionary*)data {
    [notifier log:@"debug" message:message exception:nil data:data context:nil];
}

+ (void)debugWithData:(NSDictionary*)data {
    [notifier log:@"debug" message:nil exception:nil data:data context:nil];
}

// Info

+ (void)infoWithMessage:(NSString*)message {
    [notifier log:@"info" message:message exception:nil data:nil context:nil];
}

+ (void)infoWithMessage:(NSString*)message
                   data:(NSDictionary*)data {
    [notifier log:@"info" message:message exception:nil data:data context:nil];
}

+ (void)infoWithData:(NSDictionary*)data {
    [notifier log:@"info" message:nil exception:nil data:data context:nil];
}

// Warning

+ (void)warningWithMessage:(NSString*)message {
    [notifier log:@"warning" message:message exception:nil data:nil context:nil];
}

+ (void)warningWithMessage:(NSString*)message
                      data:(NSDictionary*)data {
    [notifier log:@"warning" message:message exception:nil data:data context:nil];
}

+ (void)warningWithData:(NSDictionary*)data {
    [notifier log:@"warning" message:nil exception:nil data:data context:nil];
}

// Error

+ (void)errorWithMessage:(NSString*)message {
    [notifier log:@"error" message:message exception:nil data:nil context:nil];
}

+ (void)errorWithMessage:(NSString*)message
                    data:(NSDictionary*)data {
    [notifier log:@"error" message:message exception:nil data:data context:nil];
}

+ (void)errorWithData:(NSDictionary*)data {
    [notifier log:@"error" message:nil exception:nil data:data context:nil];
}

// Critical

+ (void)criticalWithMessage:(NSString*)message {
    [notifier log:@"critical" message:message exception:nil data:nil context:nil];
}

+ (void)criticalWithMessage:(NSString*)message
                       data:(NSDictionary*)data {
    [notifier log:@"critical" message:message exception:nil data:data context:nil];
}

+ (void)criticalWithData:(NSDictionary*)data {
    [notifier log:@"critical" message:nil exception:nil data:data context:nil];
}

// Crash Report

+ (void)logCrashReport:(NSString*)crashReport {
    [notifier logCrashReport:crashReport];
}

#pragma mark - Telemetry logging methods

#pragma mark - Dom

+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element {
    [self recordViewEventForLevel:level element:element extraData:nil];
}

+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element
                      extraData:(NSDictionary *)extraData {
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
                         extraData:(NSDictionary *)extraData {
    [[RollbarTelemetry sharedInstance] recordNetworkEventForLevel:level
                                                           method:method
                                                              url:url
                                                       statusCode:statusCode
                                                        extraData:extraData];
}

#pragma mark - Connectivity

+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status {
    [self recordConnectivityEventForLevel:level status:status extraData:nil];
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
    [self recordErrorEventForLevel:level message:message extraData:nil];
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
                       extraData:(NSDictionary *)extraData {
    [[RollbarTelemetry sharedInstance] recordErrorEventForLevel:level
                                                        message:message
                                                      extraData:extraData];
}

#pragma mark - Navigation

+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to {
    [self recordNavigationEventForLevel:level from:from to:to extraData:nil];
}

+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to
                            extraData:(NSDictionary *)extraData {
    [[RollbarTelemetry sharedInstance] recordNavigationEventForLevel:level
                                                                from:from
                                                                  to:to
                                                           extraData:extraData];
}

#pragma mark - Manual

+ (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(NSDictionary *)extraData {
    [[RollbarTelemetry sharedInstance] recordManualEventForLevel:level withData:extraData];
}

#pragma mark - Log

+ (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message {
    [self recordLogEventForLevel:level message:message extraData:nil];
}

+ (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message
                     extraData:(NSDictionary *)extraData {
    [[RollbarTelemetry sharedInstance] recordLogEventForLevel:level
                                                      message:message
                                                    extraData:extraData];
}

@end
