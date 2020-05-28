//
//  RollbarTelemetryOptions.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//
#import "RollbarTelemetryOptions.h"
#import "RollbarScrubbingOptions.h"
//@import RollbarCommon;

#pragma mark - constants

static BOOL const DEFAULT_ENABLED_FLAG = NO;
static BOOL const DEFAULT_CAPTURE_LOG_FLAG = NO;
static BOOL const DEFAULT_CAPTURE_CONNECTIVITY_FLAG = NO;
static NSUInteger const DEFAULT_MAX_TELEMETRY_DATA = 10;

#pragma mark - data field keys

static NSString *const DFK_ENABLED_FLAG = @"enabled";
static NSString *const DFK_CAPTURE_LOG_FLAG = @"captureLog";
static NSString *const DFK_CAPTURE_CONNECTIVITY_FLAG = @"captureConnectivity";
static NSString *const DFK_MAX_TELEMETRY_DATA = @"maximumTelemetryData";
static NSString *const DFK_VIEW_INPUTS_SCRUBBER = @"vewInputsScrubber";

#pragma mark - class implementation

@implementation RollbarTelemetryOptions

#pragma mark - initializers

- (instancetype)initWithEnabled:(BOOL)enabled
                     captureLog:(BOOL)captureLog
            captureConnectivity:(BOOL)captureConnectivity
             viewInputsScrubber:(RollbarScrubbingOptions *)viewInputsScrubber {
    
    self = [super initWithDictionary:@{
        DFK_ENABLED_FLAG:[NSNumber numberWithBool:enabled],
        DFK_CAPTURE_LOG_FLAG:[NSNumber numberWithBool:captureLog],
        DFK_CAPTURE_CONNECTIVITY_FLAG:[NSNumber numberWithBool:captureConnectivity],
        DFK_VIEW_INPUTS_SCRUBBER:viewInputsScrubber.jsonFriendlyData,
        DFK_MAX_TELEMETRY_DATA:[NSNumber numberWithUnsignedInt:DEFAULT_MAX_TELEMETRY_DATA]
    }];
    return self;
}

- (instancetype)initWithEnabled:(BOOL)enabled
                     captureLog:(BOOL)captureLog
            captureConnectivity:(BOOL)captureConnectivity {
    
    return [self initWithEnabled:enabled
                      captureLog:captureLog
             captureConnectivity:captureConnectivity
              viewInputsScrubber:[RollbarScrubbingOptions new]];
}

- (instancetype)initWithEnabled:(BOOL)enabled {
    return [self initWithEnabled:enabled
                      captureLog:DEFAULT_CAPTURE_LOG_FLAG
             captureConnectivity:DEFAULT_CAPTURE_CONNECTIVITY_FLAG
              viewInputsScrubber:[RollbarScrubbingOptions new]];
}

- (instancetype)init {
    return [self initWithEnabled:DEFAULT_ENABLED_FLAG
                      captureLog:DEFAULT_CAPTURE_LOG_FLAG
             captureConnectivity:DEFAULT_CAPTURE_CONNECTIVITY_FLAG
              viewInputsScrubber:[RollbarScrubbingOptions new]];
}

#pragma mark - property accessors

- (BOOL)enabled {
    NSNumber *result = [self safelyGetNumberByKey:DFK_ENABLED_FLAG];
    return result.boolValue;
}

- (void)setEnabled:(BOOL)value {
    [self setNumber:[NSNumber numberWithBool:value]
             forKey:DFK_ENABLED_FLAG
     ];
}

- (BOOL)captureLog {
    NSNumber *result = [self safelyGetNumberByKey:DFK_CAPTURE_LOG_FLAG];
    return result.boolValue;
}

- (void)setCaptureLog:(BOOL)value {
    [self setNumber:[NSNumber numberWithBool:value]
             forKey:DFK_CAPTURE_LOG_FLAG
     ];
}

- (BOOL)captureConnectivity {
    NSNumber *result = [self safelyGetNumberByKey:DFK_CAPTURE_CONNECTIVITY_FLAG];
    return result.boolValue;
}

- (void)setCaptureConnectivity:(BOOL)value {
    [self setNumber:[NSNumber numberWithBool:value]
             forKey:DFK_CAPTURE_CONNECTIVITY_FLAG
     ];
}

- (NSUInteger)maximumTelemetryData {
    NSUInteger result = [self safelyGetUIntegerByKey:DFK_MAX_TELEMETRY_DATA];
    return result;
}

- (void)setMaximumTelemetryData:(NSUInteger)value {
    [self setUInteger:value forKey:DFK_MAX_TELEMETRY_DATA];
}

- (RollbarScrubbingOptions *)viewInputsScrubber {
    id data = [self safelyGetDictionaryByKey:DFK_VIEW_INPUTS_SCRUBBER];
    id dto = [[RollbarScrubbingOptions alloc] initWithDictionary:data];
    return dto;
}

- (void)setViewInputsScrubber:(RollbarScrubbingOptions *)scrubber {
    [self setDataTransferObject:scrubber forKey:DFK_VIEW_INPUTS_SCRUBBER];
}

@end
