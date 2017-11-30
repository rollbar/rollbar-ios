//
//  RollbarLevel.m
//  Rollbar
//
//  Created by Ben Wong on 11/25/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarLevel.h"

/**
 * Translates RollbarLevel to string. Default is "info".
 */
NSString* RollbarStringFromLevel(RollbarLevel level) {
    switch (level) {
        case RollbarDebug:
            return @"debug";
        case RollbarWarning:
            return @"warning";
        case RollbarCritical:
            return @"critical";
        case RollbarError:
            return @"error";
        default:
            return @"info";
    }
}

