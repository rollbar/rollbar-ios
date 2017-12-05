//
//  RollbarTelemetryType.m
//  Rollbar
//
//  Created by Ben Wong on 11/25/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarTelemetryType.h"

/**
 * Translates RollbarTelemetryType to string. Default is "manual".
 */
NSString* RollbarStringFromTelemetryType(RollbarTelemetryType type) {
    switch (type) {
        case RollbarTelemetryView:
            return @"view";
        case RollbarTelemetryLog:
            return @"log";
        case RollbarTelemetryError:
            return @"error";
        case RollbarTelemetryNavigation:
            return @"navigation";
        case RollbarTelemetryNetwork:
            return @"network";
        case RollbarTelemetryConnectivity:
            return @"connectivity";
        default:
            return @"manual";
    }
}

