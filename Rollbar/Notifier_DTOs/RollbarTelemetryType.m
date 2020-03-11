//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarTelemetryType.h"

@implementation RollbarTelemetryTypeUtil

+ (NSString *) RollbarTelemetryTypeToString:(RollbarTelemetryType)value; {
    switch (value) {
        case RollbarTelemetryView:
            return @"dom";
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

+ (RollbarTelemetryType) RollbarTelemetryTypeFromString:(NSString *)value {
    
    if (NSOrderedSame == [value caseInsensitiveCompare:@"dom"]) {
        return RollbarTelemetryView;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"log"]) {
        return RollbarTelemetryLog;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"error"]) {
        return RollbarTelemetryError;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"navigation"]) {
        return RollbarTelemetryNavigation;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"network"]) {
        return RollbarTelemetryNetwork;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"connectivity"]) {
        return RollbarTelemetryConnectivity;
    }
    else {
        return RollbarTelemetryManual; // default case...
    }
}

@end

#pragma mark - deprecated

NSString* _Nonnull RollbarStringFromTelemetryType(RollbarTelemetryType type) {
    return [RollbarTelemetryTypeUtil RollbarTelemetryTypeToString:type];
}

