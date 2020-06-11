//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarTelemetryType.h"

@implementation RollbarTelemetryTypeUtil

+ (NSString *) RollbarTelemetryTypeToString:(RollbarTelemetryType)value; {
    switch (value) {
        case RollbarTelemetryType_View:
            return @"dom";
        case RollbarTelemetryType_Log:
            return @"log";
        case RollbarTelemetryType_Error:
            return @"error";
        case RollbarTelemetryType_Navigation:
            return @"navigation";
        case RollbarTelemetryType_Network:
            return @"network";
        case RollbarTelemetryType_Connectivity:
            return @"connectivity";
        default:
            return @"manual";
    }
}

+ (RollbarTelemetryType) RollbarTelemetryTypeFromString:(NSString *)value {
    
    if (NSOrderedSame == [value caseInsensitiveCompare:@"dom"]) {
        return RollbarTelemetryType_View;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"log"]) {
        return RollbarTelemetryType_Log;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"error"]) {
        return RollbarTelemetryType_Error;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"navigation"]) {
        return RollbarTelemetryType_Navigation;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"network"]) {
        return RollbarTelemetryType_Network;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"connectivity"]) {
        return RollbarTelemetryType_Connectivity;
    }
    else {
        return RollbarTelemetryType_Manual; // default case...
    }
}

@end

//#pragma mark - deprecated
//
//NSString* _Nonnull RollbarStringFromTelemetryType(RollbarTelemetryType type) {
//    return [RollbarTelemetryTypeUtil RollbarTelemetryTypeToString:type];
//}

