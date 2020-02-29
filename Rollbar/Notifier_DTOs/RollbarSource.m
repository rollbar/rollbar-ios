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
        case Client:
            return @"client";
        case Server:
            return @"server";
        default:
            return @"UNKNOWN";
    }
}

+ (RollbarSource) RollbarSourceFromString:(NSString *)value {
    if (NSOrderedSame == [value caseInsensitiveCompare:@"client"]) {
        return Client;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"server"]) {
        return Server;
    }
    else {
        return Server; // default case...
    }
}

@end
