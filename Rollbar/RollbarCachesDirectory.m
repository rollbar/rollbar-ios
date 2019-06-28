//
//  RollbarCachesDirectory.m
//  Rollbar
//
//  Created by Danny Nguyen on 3/12/19.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarCachesDirectory.h"

@implementation RollbarCachesDirectory

+ (NSString *)directory {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDirectory = paths.firstObject;
#if TARGET_OS_OSX
    NSString *appBundleID = [NSBundle mainBundle].bundleIdentifier;
    if (appBundleID) {
        cachesDirectory = [cachesDirectory stringByAppendingPathComponent:appBundleID];
    }
#endif
    return cachesDirectory;
}

@end
