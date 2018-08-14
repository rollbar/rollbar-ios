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

/**
 * Translates given string to RollbarLevel. Default is RollbarInfo.
 */
RollbarLevel RollbarLevelFromString(NSString *levelString) {

    if (NSOrderedSame == [levelString caseInsensitiveCompare:@"debug"]) {
        return RollbarDebug;
    }
    else  if (NSOrderedSame == [levelString caseInsensitiveCompare:@"warning"]) {
        return RollbarWarning;
    }
    else  if (NSOrderedSame == [levelString caseInsensitiveCompare:@"critical"]) {
        return RollbarCritical;
    }
    else  if (NSOrderedSame == [levelString caseInsensitiveCompare:@"error"]) {
        return RollbarError;
    }
    else {
        return RollbarInfo; // default case...
    }
}

