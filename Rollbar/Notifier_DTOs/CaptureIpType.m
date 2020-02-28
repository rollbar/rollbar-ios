//
//  CaptureIpType.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-15.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "CaptureIpType.h"

@implementation CaptureIpTypeUtil

+ (NSString *) CaptureIpTypeToString:(CaptureIpType)value {
    switch (value) {
        case CaptureIpFull:
            return @"CaptureIpFull";
        case CaptureIpAnonymize:
            return @"CaptureIpAnonymize";
        case CaptureIpNone:
            return @"CaptureIpNone";
        default:
            return @"CaptureIpNone";
    }
}

+ (CaptureIpType) CaptureIpTypeFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"CaptureIpFull"]) {
        return CaptureIpFull;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"CaptureIpAnonymize"]) {
        return CaptureIpAnonymize;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"CaptureIpNone"]) {
        return CaptureIpNone;
    }
    else {
        return CaptureIpNone; // default case...
    }

}

@end
