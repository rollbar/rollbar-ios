//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum {
    RollbarTelemetryLog,
    RollbarTelemetryView,
    RollbarTelemetryError,
    RollbarTelemetryNavigation,
    RollbarTelemetryNetwork,
    RollbarTelemetryConnectivity,
    RollbarTelemetryManual
} RollbarTelemetryType;

NSString* RollbarStringFromTelemetryType(RollbarTelemetryType type);
