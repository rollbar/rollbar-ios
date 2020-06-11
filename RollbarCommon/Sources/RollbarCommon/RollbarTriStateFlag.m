//
//  RollbarTriStateFlag.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarTriStateFlag.h"

@implementation RollbarTriStateFlagUtil

+ (NSString *) TriStateFlagToString:(RollbarTriStateFlag)value {
    switch (value) {
        case RollbarTriStateFlag_On:
            return @"ON";
        case RollbarTriStateFlag_Off:
            return @"OFF";
        case RollbarTriStateFlag_None:
        default:
            return @"NONE";
    }
}

+ (RollbarTriStateFlag) TriStateFlagFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"ON"]) {
        return RollbarTriStateFlag_On;
    }
    else if (NSOrderedSame == [value caseInsensitiveCompare:@"OFF"]) {
        return RollbarTriStateFlag_Off;
    }
    else {
        return RollbarTriStateFlag_None; // default case...
    }
}

@end
