//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

@class RollbarConfig;

#import "RollbarLevel.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarLogger : NSObject

/// The shared instance of the logger
+ (nonnull RollbarLogger *)sharedInstance;

/// Creates new instance of the logger using provided configuration instance
/// @param config configuration to be used by the new instance of the logger
+ (nonnull RollbarLogger *)createLoggerWithConfig:(nonnull RollbarConfig *)config;

/// Notifier's config object
@property (nullable, atomic, strong) RollbarConfig *configuration;

/// Disallowed initializer
- (instancetype)init
NS_UNAVAILABLE;

/// Designated notifier initializer
/// @param accessToken the access token
- (instancetype)initWithAccessToken:(nonnull NSString *)accessToken;

/// Designated notifier initializer
/// @param configuration the config object
- (instancetype)initWithConfiguration:(nonnull RollbarConfig *)configuration
NS_DESIGNATED_INITIALIZER;

/// Processes persisted payloads
- (void)processSavedItems;

/// Captures a crash report
/// @param crashReport the crash report
- (void)logCrashReport:(nonnull NSString *)crashReport;

/// Captures a log entry
/// @param level Rollbar error/log level
/// @param message message
/// @param data extra data
/// @param context extra context
- (void)log:(RollbarLevel)level
    message:(nonnull NSString *)message
       data:(nullable NSDictionary<NSString *, id> *)data
    context:(nullable NSString *)context;

/// Captures a log entry
/// @param level Rollbar error/log level
/// @param exception exception
/// @param data extra data
/// @param context extra context
- (void)log:(RollbarLevel)level
  exception:(nonnull NSException *)exception
       data:(nullable NSDictionary<NSString *, id> *)data
    context:(nullable NSString *)context;

    /// Capture a log entry based on an NSError
    /// @param level Rollbar error/log level
    /// @param error an NSError
    /// @param data extra data
    /// @param context extra context
- (void)log:(RollbarLevel)level
      error:(nonnull NSError *)error
       data:(nullable NSDictionary<NSString *, id> *)data
    context:(nullable NSString *)context;

/// Sends an item batch in a blocking manner.
/// @param payload an item to send
/// @param nextOffset the offset in the item queue file of the item immediately after this batch.
/// If the send is successful or the retry limit is hit, nextOffset will be saved to the queueState as the offset to use for the next batch
/// @return YES if this batch should be discarded if it was successful or a retry limit was hit. Otherwise NO is returned if this batch should be retried.
- (BOOL)sendItem:(nonnull NSDictionary *)payload
      nextOffset:(NSUInteger)nextOffset;


/// Sends a fully composed JSON payload.
/// @param payload complete Rollbar payload as JSON string
/// @return YES if successful. NO if not.
- (BOOL)sendPayload:(nonnull NSData *)payload;

/// Updates key configuration elements
/// @param accessToken the Rollbar project access token
/// @param configuration the Rollbar configuration object
//- (void)updateAccessToken:(NSString *)accessToken
//            configuration:(RollbarConfig *)configuration
//                   isRoot:(BOOL)isRoot;

/// Updates key configuration elements
/// @param configuration the Rollbar configuration object
- (void)updateConfiguration:(nonnull RollbarConfig *)configuration;
//                     isRoot:(BOOL)isRoot;

/// Updates the Rollbar project access token
/// @param accessToken the Rollbar project access token
- (void)updateAccessToken:(nonnull NSString *)accessToken;

/// Updates allowed reporting rate
/// @param maximumReportsPerMinute the maximum allowed reports transmission rate
- (void)updateReportingRate:(NSUInteger)maximumReportsPerMinute;

@end

NS_ASSUME_NONNULL_END
