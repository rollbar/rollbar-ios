//
//  TriStateFlag.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "TriStateFlag.h"

@implementation TriStateFlagUtil

+ (NSString *) TriStateFlagToString:(TriStateFlag)value {
    switch (value) {
        case On:
            return @"ON";
        case Off:
            return @"OFF";
        case None:
        default:
            return @"NONE";
    }
}

+ (TriStateFlag) TriStateFlagFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"ON"]) {
        return On;
    }
    else if (NSOrderedSame == [value caseInsensitiveCompare:@"OFF"]) {
        return Off;
    }
    else {
        return None; // default case...
    }
}

@end
