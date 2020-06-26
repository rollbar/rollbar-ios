//
//  AppDelegate.m
//  macosAppObjC
//
//  Created by Andrey Kornich on 2020-05-21.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import "AppDelegate.h"

#import "RollbarDeploysDemoClient.h"

@import RollbarNotifier;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    [self initRollbar];
    
    @try {
        [self callTroublemaker];
    } @catch (NSException *exception) {
        [Rollbar error:@"Got an exception!" exception:exception];
    } @finally {
        [Rollbar info:@"Post-trouble notification!"];
    }
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application

    [Rollbar info:@"The hosting application is terminating..."];
}

- (void)initRollbar {

    // configure Rollbar:
    RollbarConfiguration *config = [RollbarConfiguration configuration];
    
    //config.crashLevel = @"critical";
    config.environment = @"samples";
    config.asRollbarConfig.customData = @{ @"someKey": @"someValue", };
    // init Rollbar shared instance:
    [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3" configuration:config];
    
    [Rollbar info:@"Rollbar is up and running! Enjoy your remote error and log monitoring..."];
}

- (void)demonstrateDeployApiUasege {
    
    RollbarDeploysDemoClient * rollbarDeploysIntro = [[RollbarDeploysDemoClient new] init];
    [rollbarDeploysIntro demoDeploymentRegistration];
    [rollbarDeploysIntro demoGetDeploymentDetailsById];
    [rollbarDeploysIntro demoGetDeploymentsPage];
}

- (void)callTroublemaker {
    NSArray *items = @[@"one", @"two", @"three"];
    NSLog(@"Here is the trouble-item: %@", items[10]);
}

@end
