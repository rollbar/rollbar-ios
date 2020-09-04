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

#pragma mark - Logging methods

+ (void)logCrashReport:(NSString*)crashReport;

+ (void)log:(RollbarLevel)level
    message:(NSString *)message;
+ (void)log:(RollbarLevel)level
  exception:(NSException *)exception;
+ (void)log:(RollbarLevel)level
      error:(NSError *)error;

+ (void)log:(RollbarLevel)level
    message:(NSString *)message
       data:(NSDictionary<NSString *, id> *)data;
+ (void)log:(RollbarLevel)level
  exception:(NSException *)exception
       data:(NSDictionary<NSString *, id> *)data;
+ (void)log:(RollbarLevel)level
      error:(NSError *)error
       data:(NSDictionary<NSString *, id> *)data;

+ (void)log:(RollbarLevel)level
    message:(NSString *)message
       data:(NSDictionary<NSString *, id> *)data
    context:(NSString *)context;
+ (void)log:(RollbarLevel)level
  exception:(NSException *)exception
       data:(NSDictionary<NSString *, id> *)data
    context:(NSString *)context;
+ (void)log:(RollbarLevel)level
      error:(NSError *)error
       data:(NSDictionary<NSString *, id> *)data
    context:(NSString *)context;

#pragma mark - Convenience logging methods

+ (void)debugMessage:(NSString *)message;
+ (void)debugException:(NSException *)exception;
+ (void)debugError:(NSError *)error;

+ (void)debugMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data;
+ (void)debugException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data;
+ (void)debugError:(NSError *)error data:(NSDictionary<NSString *, id> *)data;

+ (void)debugMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)debugException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)debugError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;


+ (void)infoMessage:(NSString *)message;
+ (void)infoException:(NSException *)exception;
+ (void)infoError:(NSError *)error;

+ (void)infoMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data;
+ (void)infoException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data;
+ (void)infoError:(NSError *)error data:(NSDictionary<NSString *, id> *)data;

+ (void)infoMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)infoException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)infoError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;

+ (void)warningMessage:(NSString *)message;
+ (void)warningException:(NSException *)exception;
+ (void)warningError:(NSError *)error;

+ (void)warningMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data;
+ (void)warningException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data;
+ (void)warningError:(NSError *)error data:(NSDictionary<NSString *, id> *)data;

+ (void)warningMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)warningException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)warningError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;

+ (void)errorMessage:(NSString *)message;
+ (void)errorException:(NSException *)exception;
+ (void)errorError:(NSError *)error;

+ (void)errorMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data;
+ (void)errorException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data;
+ (void)errorError:(NSError *)error data:(NSDictionary<NSString *, id> *)data;

+ (void)errorMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)errorException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)errorError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;

+ (void)criticalMessage:(NSString *)message;
+ (void)criticalException:(NSException *)exception;
+ (void)criticalError:(NSError *)error;

+ (void)criticalMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data;
+ (void)criticalException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data;
+ (void)criticalError:(NSError *)error data:(NSDictionary<NSString *, id> *)data;

+ (void)criticalMessage:(NSString *)message data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)criticalException:(NSException *)exception data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;
+ (void)criticalError:(NSError *)error data:(NSDictionary<NSString *, id> *)data context:(NSString *)context;


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
