//
//  RollbarLoggingOptions.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-28.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarLevel.h"
#import "RollbarCaptureIpType.h"
@import RollbarCommon;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarLoggingOptions : RollbarDTO

#pragma mark - Properties

@property (nonatomic) RollbarLevel logLevel;
@property (nonatomic) RollbarLevel crashLevel;
@property (nonatomic) NSUInteger maximumReportsPerMinute;
@property (nonatomic) RollbarCaptureIpType captureIp;
@property (nonatomic, copy, nullable) NSString *codeVersion;
@property (nonatomic, copy, nullable) NSString *framework;
@property (nonatomic, copy, nullable) NSString *requestId;

#pragma mark - Initializers

- (instancetype)initWithLogLevel:(RollbarLevel)logLevel
                      crashLevel:(RollbarLevel)crashLevel
         maximumReportsPerMinute:(NSUInteger)maximumReportsPerMinute
                       captureIp:(RollbarCaptureIpType)captureIp
                     codeVersion:(nullable NSString *)codeVersion
                       framework:(nullable NSString *)framework
                       requestId:(nullable NSString *)requestId;

- (instancetype)initWithLogLevel:(RollbarLevel)logLevel
                      crashLevel:(RollbarLevel)crashLevel
         maximumReportsPerMinute:(NSUInteger)maximumReportsPerMinute
                     codeVersion:(nullable NSString *)codeVersion
                       framework:(nullable NSString *)framework
                       requestId:(nullable NSString *)requestId;

- (instancetype)initWithLogLevel:(RollbarLevel)logLevel
                      crashLevel:(RollbarLevel)crashLevel
                       captureIp:(RollbarCaptureIpType)captureIp
                     codeVersion:(nullable NSString *)codeVersion
                       framework:(nullable NSString *)framework
                       requestId:(nullable NSString *)requestId;

- (instancetype)initWithLogLevel:(RollbarLevel)logLevel
                      crashLevel:(RollbarLevel)crashLevel
                     codeVersion:(nullable NSString *)codeVersion
                       framework:(nullable NSString *)framework
                       requestId:(nullable NSString *)requestId;

- (instancetype)initWithLogLevel:(RollbarLevel)logLevel
                      crashLevel:(RollbarLevel)crashLevel
         maximumReportsPerMinute:(NSUInteger)maximumReportsPerMinute;

- (instancetype)initWithLogLevel:(RollbarLevel)logLevel
                      crashLevel:(RollbarLevel)crashLevel;

@end

NS_ASSUME_NONNULL_END
