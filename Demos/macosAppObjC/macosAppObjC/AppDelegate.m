//
//  AppDelegate.m
//  macosAppObjC
//
//  Created by Andrey Kornich on 2020-05-21.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import "AppDelegate.h"

#import "RollbarDeploysDemoClient.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    RollbarDeploysDemoClient * rollbarDeploysIntro = [[RollbarDeploysDemoClient new] init];
    [rollbarDeploysIntro demoDeploymentRegistration];
    [rollbarDeploysIntro demoGetDeploymentDetailsById];
    [rollbarDeploysIntro demoGetDeploymentsPage];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
