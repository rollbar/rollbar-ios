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
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(
                                                         NSCachesDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *cachesDirectory = paths.firstObject;
    
#if TARGET_OS_OSX
    NSProcessInfo *processInfo = [NSProcessInfo processInfo];
    if (nil != [processInfo.environment
                valueForKey:@"APP_SANDBOX_CONTAINER_ID"]) {
        // when the hosting process is sandboxed, the cachesDirectory is already
        // allocated per application:
        return cachesDirectory;
    }
    
    // when the hosting process is not sandboxed let's make sure we sandbox
    // our own cache based on the process' unique attributes:
    NSString *appBundleID = [NSBundle mainBundle].bundleIdentifier;
    if (appBundleID) {
        cachesDirectory =
        [cachesDirectory stringByAppendingPathComponent:appBundleID];
    }
    else {
        cachesDirectory =
        [cachesDirectory stringByAppendingPathComponent:processInfo.processName];
    }
    
#endif
    return cachesDirectory;
}

@end
