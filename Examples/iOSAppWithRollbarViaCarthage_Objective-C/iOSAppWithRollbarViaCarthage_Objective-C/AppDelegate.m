//
//  AppDelegate.m
//  iOSAppWithRollbarViaCarthage_Objective-C
//
//  Created by Andrey Kornich on 2020-01-14.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import "AppDelegate.h"
#import <Rollbar/Rollbar.h>
#import <Rollbar/RollbarConfiguration.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // configure Rollbar:
    RollbarConfiguration *config = [RollbarConfiguration configuration];
    config.environment = @"samples";
    // initialize Rollbar:
    [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
    // first test
    [Rollbar info:@"iOSAppWithRollbarViaCarthage_Objective-C: the app just launched. Life is good..."];

    // one more test:
    [Rollbar log:RollbarInfo
         message:@"Test message"
       exception:nil
            data:@{@"ExtraData1":@"extra value 1", @"ExtraData2":@"extra value 2"}
         context:@"extra context"];
    
    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
