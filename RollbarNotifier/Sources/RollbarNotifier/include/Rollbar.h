//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

#import "RollbarLevel.h"
#import "RollbarTelemetry.h"
#import "RollbarTelemetryType.h"

@class RollbarConfig;
@class RollbarLogger;
@protocol RollbarCrashCollector;

@interface Rollbar : NSObject

#pragma mark - Class Initializers

+ (void)initWithAccessToken:(nonnull NSString *)accessToken;

+ (void)initWithConfiguration:(nonnull RollbarConfig *)configuration;

+ (void)initWithAccessToken:(nonnull NSString *)accessToken
             crashCollector:(nullable id<RollbarCrashCollector>)crashCollector;

+ (void)initWithConfiguration:(nonnull RollbarConfig *)configuration
               crashCollector:(nullable id<RollbarCrashCollector>)crashCollector;

#pragma mark - Shared/global notifier

+ (nonnull RollbarLogger *)currentLogger;

#pragma mark - Configuration

+ (nullable RollbarConfig *)currentConfiguration;

+ (void)updateConfiguration:(nonnull RollbarConfig *)configuration;
+ (void)reapplyConfiguration;

#pragma mark - Logging methods

+ (void)logCrashReport:(nonnull NSString *)crashReport;

+ (void)log:(RollbarLevel)level
    message:(nonnull NSString *)message;
+ (void)log:(RollbarLevel)level
  exception:(nonnull NSException *)exception;
+ (void)log:(RollbarLevel)level
      error:(nonnull NSError *)error;

+ (void)log:(RollbarLevel)level
    message:(nonnull NSString *)message
       data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)log:(RollbarLevel)level
  exception:(nonnull NSException *)exception
       data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)log:(RollbarLevel)level
      error:(nonnull NSError *)error
       data:(nullable NSDictionary<NSString *, id> *)data;

+ (void)log:(RollbarLevel)level
    message:(nonnull NSString *)message
       data:(nullable NSDictionary<NSString *, id> *)data
    context:(nullable NSString *)context;
+ (void)log:(RollbarLevel)level
  exception:(nonnull NSException *)exception
       data:(nullable NSDictionary<NSString *, id> *)data
    context:(nullable NSString *)context;
+ (void)log:(RollbarLevel)level
      error:(nonnull NSError *)error
       data:(nullable NSDictionary<NSString *, id> *)data
    context:(nullable NSString *)context;

#pragma mark - Convenience logging methods

+ (void)debugMessage:(nonnull NSString *)message;
+ (void)debugException:(nonnull NSException *)exception;
+ (void)debugError:(nonnull NSError *)error;

+ (void)debugMessage:(nonnull NSString *)message
                data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)debugException:(nonnull NSException *)exception
                  data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)debugError:(nonnull NSError *)error
              data:(nullable NSDictionary<NSString *, id> *)data;

+ (void)debugMessage:(nonnull NSString *)message
                data:(nullable NSDictionary<NSString *, id> *)data
             context:(nullable NSString *)context;
+ (void)debugException:(nonnull NSException *)exception
                  data:(nullable NSDictionary<NSString *, id> *)data
               context:(nullable NSString *)context;
+ (void)debugError:(nonnull NSError *)error
              data:(nullable NSDictionary<NSString *, id> *)data
           context:(nullable NSString *)context;


+ (void)infoMessage:(nonnull NSString *)message;
+ (void)infoException:(nonnull NSException *)exception;
+ (void)infoError:(nonnull NSError *)error;

+ (void)infoMessage:(nonnull NSString *)message
               data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)infoException:(nonnull NSException *)exception
                 data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)infoError:(nonnull NSError *)error
             data:(nullable NSDictionary<NSString *, id> *)data;

+ (void)infoMessage:(nonnull NSString *)message
               data:(nullable NSDictionary<NSString *, id> *)data
            context:(nullable NSString *)context;
+ (void)infoException:(nonnull NSException *)exception
                 data:(nullable NSDictionary<NSString *, id> *)data
              context:(nullable NSString *)context;
+ (void)infoError:(nonnull NSError *)error
             data:(nullable NSDictionary<NSString *, id> *)data
          context:(nullable NSString *)context;

+ (void)warningMessage:(nonnull NSString *)message;
+ (void)warningException:(nonnull NSException *)exception;
+ (void)warningError:(nonnull NSError *)error;

+ (void)warningMessage:(nonnull NSString *)message
                  data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)warningException:(nonnull NSException *)exception
                    data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)warningError:(nonnull NSError *)error
                data:(nullable NSDictionary<NSString *, id> *)data;

+ (void)warningMessage:(nonnull NSString *)message
                  data:(nullable NSDictionary<NSString *, id> *)data
               context:(nullable NSString *)context;
+ (void)warningException:(nonnull NSException *)exception
                    data:(nullable NSDictionary<NSString *, id> *)data
                 context:(nullable NSString *)context;
+ (void)warningError:(nonnull NSError *)error
                data:(nullable NSDictionary<NSString *, id> *)data
             context:(nullable NSString *)context;

+ (void)errorMessage:(nonnull NSString *)message;
+ (void)errorException:(nonnull NSException *)exception;
+ (void)errorError:(nonnull NSError *)error;

+ (void)errorMessage:(nonnull NSString *)message
                data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)errorException:(nonnull NSException *)exception
                  data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)errorError:(nonnull NSError *)error
              data:(nullable NSDictionary<NSString *, id> *)data;

+ (void)errorMessage:(nonnull NSString *)message
                data:(nullable NSDictionary<NSString *, id> *)data
             context:(nullable NSString *)context;
+ (void)errorException:(nonnull NSException *)exception
                  data:(nullable NSDictionary<NSString *, id> *)data
               context:(nullable NSString *)context;
+ (void)errorError:(nonnull NSError *)error
              data:(nullable NSDictionary<NSString *, id> *)data
           context:(nullable NSString *)context;

+ (void)criticalMessage:(nonnull NSString *)message;
+ (void)criticalException:(nonnull NSException *)exception;
+ (void)criticalError:(nonnull NSError *)error;

+ (void)criticalMessage:(nonnull NSString *)message
                   data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)criticalException:(nonnull NSException *)exception
                     data:(nullable NSDictionary<NSString *, id> *)data;
+ (void)criticalError:(nonnull NSError *)error
                 data:(nullable NSDictionary<NSString *, id> *)data;

+ (void)criticalMessage:(nonnull NSString *)message
                   data:(nullable NSDictionary<NSString *, id> *)data
                context:(nullable NSString *)context;
+ (void)criticalException:(nonnull NSException *)exception
                     data:(nullable NSDictionary<NSString *, id> *)data
                  context:(nullable NSString *)context;
+ (void)criticalError:(nonnull NSError *)error
                 data:(nullable NSDictionary<NSString *, id> *)data
              context:(nullable NSString *)context;


#pragma mark - Send manually constructed JSON payload

+ (void)sendJsonPayload:(nonnull NSData *)payload;

#pragma mark - Telemetry API

+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(nonnull NSString *)element;
+ (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(nonnull NSString *)element
                      extraData:(nullable NSDictionary<NSString *, id> *)extraData;

+ (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(nullable NSString *)method
                               url:(nullable NSString *)url
                        statusCode:(nullable NSString *)statusCode;
+ (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(nullable NSString *)method
                               url:(nullable NSString *)url
                        statusCode:(nullable NSString *)statusCode
                         extraData:(nullable NSDictionary<NSString *, id> *)extraData;

+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(nonnull NSString *)status;
+ (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(nonnull NSString *)status
                              extraData:(nullable NSDictionary<NSString *, id> *)extraData;

+ (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(nonnull NSString *)message;
+ (void)recordErrorEventForLevel:(RollbarLevel)level
                       exception:(nonnull NSException *)exception;
+ (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(nonnull NSString *)message
                       extraData:(nullable NSDictionary<NSString *, id> *)extraData;

+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(nonnull NSString *)from
                                   to:(nonnull NSString *)to;
+ (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(nonnull NSString *)from
                                   to:(nonnull NSString *)to
                            extraData:(nullable NSDictionary<NSString *, id> *)extraData;

+ (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(nullable NSDictionary<NSString *, id> *)extraData;

@end
