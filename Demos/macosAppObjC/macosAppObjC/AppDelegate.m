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
    
    NSData *data = [[NSData alloc] init];
    NSError *error;
    NSJSONReadingOptions serializationOptions = (NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves);
    NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:data
                                                            options:serializationOptions
                                                              error:&error];
    if (!payload && error) {
        [Rollbar log:RollbarLevel_Error
               error:error
                data:nil
             context:nil
         ];
    }

    
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
    RollbarConfig *config = [RollbarConfig new];
    
    config.destination.accessToken = @"2ffc7997ed864dda94f63e7b7daae0f3";
    config.destination.environment = @"samples";
    config.customData = @{ @"someKey": @"someValue", };
    // init Rollbar shared instance:
    [Rollbar initWithConfiguration:config];
    
    [Rollbar info:@"Rollbar is up and running! Enjoy your remote error and log monitoring..."];
}

- (void)demonstrateDeployApiUsage {
    
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
