//
//  RollbarTelemetryType.h
//  Rollbar
//
//  Created by Ben Wong on 11/25/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

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
