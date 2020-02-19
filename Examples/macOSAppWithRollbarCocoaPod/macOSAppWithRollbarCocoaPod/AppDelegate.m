//
//  AppDelegate.m
//  macOSAppWithRollbarCocoaPod
//
//  Created by Andrey Kornich on 2019-07-08.
//  Copyright © 2019 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import "AppDelegate.h"

@import Rollbar;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    // configure Rollbar:
    RollbarConfiguration *config = [RollbarConfiguration configuration];
    config.environment = @"samples";
    
    [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
    
    [Rollbar info:@"macOSAppWithRollbarCocoaPod: the app just launched..."];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application

    [Rollbar info:@"macOSAppWithRollbarCocoaPod: the app is about to terminate..."];
}


@end
