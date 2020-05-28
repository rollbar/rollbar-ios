//
//  RollbarSource.m
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#import "RollbarSource.h"

@implementation RollbarSourceUtil

+ (NSString *) RollbarSourceToString:(RollbarSource)value {
    switch (value) {
        case RollbarSource_Client:
            return @"client";
        case RollbarSource_Server:
            return @"server";
        default:
            return @"UNKNOWN";
    }
}

+ (RollbarSource) RollbarSourceFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"client"]) {
        return RollbarSource_Client;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"server"]) {
        return RollbarSource_Server;
    }
    else {
        return RollbarSource_Server; // default case...
    }
}

@end
