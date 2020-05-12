//
//  AppDelegate.m
//  iOSAppWithRollbarCocoaPod
//
//  Created by Andrey Kornich on 2019-07-10.
//  Copyright © 2019 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import "AppDelegate.h"
@import Rollbar;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // configure Rollbar:
    RollbarConfiguration *config = [RollbarConfiguration configuration];
    config.environment = @"samples";
    
    [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
    
    [Rollbar info:@"iOSAppWithRollbarCocoaPod: the app just launched..."];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [Rollbar info:@"iOSAppWithRollbarCocoaPod: the app is about to resign active..."];

}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [Rollbar info:@"iOSAppWithRollbarCocoaPod: the app entered background..."];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    [Rollbar info:@"iOSAppWithRollbarCocoaPod: the app entered foreground..."];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [Rollbar info:@"iOSAppWithRollbarCocoaPod: the app bacame active..."];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

    [Rollbar info:@"iOSAppWithRollbarCocoaPod: the app is about to terminate..."];
}


@end
