//
//  CaptureIpType.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-15.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarCaptureIpType.h"

@implementation RollbarCaptureIpTypeUtil

+ (NSString *) CaptureIpTypeToString:(RollbarCaptureIpType)value {
    switch (value) {
        case RollbarCaptureIpType_Full:
            return @"Full";
        case RollbarCaptureIpType_Anonymize:
            return @"Anonymize";
        case RollbarCaptureIpType_None:
            return @"None";
        default:
            return @"None";
    }
}

+ (RollbarCaptureIpType) CaptureIpTypeFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"Full"]) {
        return RollbarCaptureIpType_Full;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"Anonymize"]) {
        return RollbarCaptureIpType_Anonymize;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"None"]) {
        return RollbarCaptureIpType_None;
    }
    else {
        return RollbarCaptureIpType_None; // default case...
    }

}

@end
