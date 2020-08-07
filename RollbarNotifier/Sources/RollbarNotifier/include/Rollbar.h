//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

#import "RollbarLevel.h"
#import "RollbarTelemetry.h"
#import "RollbarTelemetryType.h"

@class RollbarConfig;
@class RollbarLogger;

@interface Rollbar : NSObject

#pragma mark - Class Initializers

+ (void)initWithAccessToken:(NSString *)accessToken;

+ (void)initWithConfiguration:(RollbarConfig *)configuration;

#pragma mark - Shared/global notifier

+ (RollbarLogger*)currentLogger;

#pragma mark - Configuration

+ (RollbarConfig *)currentConfiguration;

+ (void)updateConfiguration:(RollbarConfig *)configuration;
+ (void)reapplyConfiguration;

#pragma mark - New logging methods

+ (void)log:(RollbarLevel)level
    message:(NSString *)message;
+ (void)log:(RollbarLevel)level
    message:(NSString *)message
  exception:(NSException *)exception;
+ (void)log:(RollbarLevel)level
    message:(NSString *)message
  exception:(NSException *)exception
       data:(NSDictionary<NSString *, id> *)data;
+ (void)log:(RollbarLevel)level
    message:(NSString *)message
  exception:(NSException *)exception
       data:(NSDictionary<NSString *, id> *)data
    context:(NSString *)context;

+ (void)debug:(NSString *)message;
+ (void)debug:(NSString *)message
    exception:(NSException *)exception;
+ (void)debug:(NSString *)message
    exception:(NSException *)exception
         data:(NSDictionary<NSString *, id> *)data;
+ (void)debug:(NSString *)message
    exception:(NSException *)exception
         data:(NSDictionary<NSString *, id> *)data
      context:(NSString *)context;

+ (void)info:(NSString *)message;
+ (void)info:(NSString *)message
   exception:(NSException *)exception;
+ (void)info:(NSString *)message
   exception:(NSException *)exception
        data:(NSDictionary<NSString *, id> *)data;
+ (void)info:(NSString *)message
   exception:(NSException *)exception
        data:(NSDictionary<NSString *, id> *)data
     context:(NSString *)context;

+ (void)warning:(NSString *)message;
+ (void)warning:(NSString *)message
      exception:(NSException *)exception;
+ (void)warning:(NSString *)message
      exception:(NSException *)exception
           data:(NSDictionary<NSString *, id> *)data;
+ (void)warning:(NSString *)message
      exception:(NSException *)exception
           data:(NSDictionary<NSString *, id> *)data
        context:(NSString *)context;

+ (void)error:(NSString *)message;
+ (void)error:(NSString *)message
    exception:(NSException *)exception;
+ (void)error:(NSString *)message
    exception:(NSException *)exception
         data:(NSDictionary<NSString *, id> *)data;
+ (void)error:(NSString *)message
    exception:(NSException *)exception
         data:(NSDictionary<NSString *, id> *)data
      context:(NSString *)context;

+ (void)critical:(NSString *)message;
+ (void)critical:(NSString *)message
       exception:(NSException *)exception;
+ (void)critical:(NSString *)message
       exception:(NSException *)exception
            data:(NSDictionary<NSString *, id> *)data;
+ (void)critical:(NSString *)message
       exception:(NSException *)exception
            data:(NSDictionary<NSString *, id> *)data
         context:(NSString *)context;

+ (void)logCrashReport:(NSString*)crashReport;

#pragma mark - Send manually constructed JSON payload

+ (void)sendJsonPayload:(NSData*)payload;

#pragma mark - Telemetry API

+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element;
+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element
                      extraData:(NSDictionary<NSString *, id> *)extraData;

+ (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode;
+ (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode
                         extraData:(NSDictionary<NSString *, id> *)extraData;

+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status;
+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status
                              extraData:(NSDictionary<NSString *, id> *)extraData;

+ (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message;
+ (void)recordErrorEventForLevel:(RollbarLevel)level
                       exception:(NSException *)exception;
+ (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message
                       extraData:(NSDictionary<NSString *, id> *)extraData;

+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to;
+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to
                            extraData:(NSDictionary<NSString *, id> *)extraData;

+ (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(NSDictionary<NSString *, id> *)extraData;

@end
