//
//  RollbarLoggingOptions.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-28.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarLoggingOptions.h"
#import "DataTransferObject+Protected.h"

#pragma mark - constants

static RollbarLevel const DEFAULT_LOG_LEVEL = RollbarInfo;
static RollbarLevel const DEFAULT_CRASH_LEVEL = RollbarError;
static NSUInteger const DEFAULT_MAX_REPORTS_PER_MINUTE = 60;
static CaptureIpType const DEFAULT_IP_CAPTURE_TYPE = CaptureIpFull;

#if TARGET_OS_IPHONE
static NSString * const OPERATING_SYSTEM = @"ios";
#else
static NSString * const OPERATING_SYSTEM = @"macos";
#endif

#pragma mark - data field keys

static NSString * const DFK_LOG_LEVEL = @"logLevel";
static NSString * const DFK_CRASH_LEVEL = @"crashLevel";
static NSString * const DFK_MAX_REPORTS_PER_MINUTE = @"maximumReportsPerMinute";
static NSString * const DFK_IP_CAPTURE_TYPE = @"captureIp";
static NSString * const DFK_CODE_VERSION = @"codeVersion";
static NSString * const DFK_FRAMEWORK = @"framework";
static NSString * const DFK_REQUEST_ID = @"requestId";

#pragma mark - class implementation

@implementation RollbarLoggingOptions

#pragma mark - initializers

- (id)initWithLogLevel:(RollbarLevel)logLevel
            crashLevel:(RollbarLevel)crashLevel
maximumReportsPerMinute:(NSUInteger)maximumReportsPerMinute {
    self = [super init];
    if (self) {
        self.logLevel = logLevel;
        self.crashLevel = crashLevel;
        self.maximumReportsPerMinute = maximumReportsPerMinute;
        self.captureIp = DEFAULT_IP_CAPTURE_TYPE;
        self.framework = OPERATING_SYSTEM;
    }
    return self;

}
- (id)initWithLogLevel:(RollbarLevel)logLevel
            crashLevel:(RollbarLevel)crashLevel {
    return [self initWithLogLevel:logLevel
                       crashLevel:crashLevel
          maximumReportsPerMinute:DEFAULT_MAX_REPORTS_PER_MINUTE];
}

- (id)init {
    return [self initWithLogLevel:DEFAULT_LOG_LEVEL
                       crashLevel:DEFAULT_CRASH_LEVEL];
}

#pragma mark - property accessors

- (RollbarLevel)logLevel {
    NSString *logLevelString = [self safelyGetStringByKey:DFK_LOG_LEVEL];
    return [RollbarLevelUtil RollbarLevelFromString:logLevelString];
}

- (void)setLogLevel:(RollbarLevel)level {
    NSString *levelString = [RollbarLevelUtil RollbarLevelToString:level];
    [self setString:levelString forKey:DFK_LOG_LEVEL];
}

- (RollbarLevel)crashLevel {
    NSString *logLevelString = [self safelyGetStringByKey:DFK_CRASH_LEVEL];
    return [RollbarLevelUtil RollbarLevelFromString:logLevelString];
}

- (void)setCrashLevel:(RollbarLevel)level {
    NSString *levelString = [RollbarLevelUtil RollbarLevelToString:level];
    [self setString:levelString forKey:DFK_CRASH_LEVEL];
}

- (NSUInteger)maximumReportsPerMinute {
    return [self safelyGetUIntegerByKey:DFK_MAX_REPORTS_PER_MINUTE];
}

- (void)setMaximumReportsPerMinute:(NSUInteger)value {
    [self setUInteger:value forKey:DFK_MAX_REPORTS_PER_MINUTE];
}

- (CaptureIpType)captureIp {
    NSString *valueString = [self safelyGetStringByKey:DFK_IP_CAPTURE_TYPE];
    return [CaptureIpTypeUtil CaptureIpTypeFromString:valueString];
}

- (void)setCaptureIp:(CaptureIpType)value {
    NSString *valueString = [CaptureIpTypeUtil CaptureIpTypeToString:value];
    [self setString:valueString forKey:DFK_IP_CAPTURE_TYPE];
}

- (NSString *)codeVersion {
    return [self safelyGetStringByKey:DFK_CODE_VERSION];
}

- (void)setCodeVersion:(NSString *)value {
    [self setString:value forKey:DFK_CODE_VERSION];
}

- (NSString *)framework; {
    return [self safelyGetStringByKey:DFK_FRAMEWORK];
}

- (void)setFramework:(NSString *)value {
    [self setString:value forKey:DFK_FRAMEWORK];
}

- (NSString *)requestId {
    return [self safelyGetStringByKey:DFK_REQUEST_ID];
}

- (void)setRequestId:(NSString *)value {
    [self setString:value forKey:DFK_REQUEST_ID];
}

@end
