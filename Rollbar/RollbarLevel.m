//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarLevel.h"

/**
 * Translates RollbarLevel to string. Default is "info".
 */
NSString* RollbarStringFromLevel(RollbarLevel level) {

    return [RollbarLevelUtil RollbarLevelToString:level];
}

/**
 * Translates given string to RollbarLevel. Default is RollbarInfo.
 */
RollbarLevel RollbarLevelFromString(NSString *levelString) {

    return [RollbarLevelUtil RollbarLevelFromString:levelString];
}

@implementation RollbarLevelUtil

+ (NSString *) RollbarLevelToString:(RollbarLevel)value; {
    switch (value) {
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

+ (RollbarLevel) RollbarLevelFromString:(NSString *)value {
    
    if (NSOrderedSame == [value caseInsensitiveCompare:@"debug"]) {
        return RollbarDebug;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"warning"]) {
        return RollbarWarning;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"critical"]) {
        return RollbarCritical;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"error"]) {
        return RollbarError;
    }
    else {
        return RollbarInfo; // default case...
    }
}

@end


