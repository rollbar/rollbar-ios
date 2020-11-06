//
//  AppDelegate.m
//  iosAppObjC
//
//  Created by Andrey Kornich on 2020-11-04.
//

#import "AppDelegate.h"

@import RollbarNotifier;
@import RollbarKSCrash;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
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
        [Rollbar errorException:exception data:nil context:@"from @try-@catch"];
    } @finally {
        [Rollbar infoMessage:@"Post-trouble notification!"  data:nil context:@"from @try-@finally"];
    }
    

    // now, cause a crash:
    //    [self callTroublemaker];
    @throw NSInternalInconsistencyException;
    //    [self performSelector:@selector(die_die)];
    //    [self performSelector:NSSelectorFromString(@"crashme:") withObject:nil afterDelay:10];

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

- (void)initRollbar {
    
        // configure Rollbar:
    RollbarConfig *config = [RollbarConfig new];
    
    config.destination.accessToken = @"2ffc7997ed864dda94f63e7b7daae0f3";
    config.destination.environment = @"samples";
    config.customData = @{ @"someKey": @"someValue", };
        // init Rollbar shared instance:
    id<RollbarCrashCollector> crashCollector = [[RollbarKSCrashCollector alloc] init];
    [Rollbar initWithConfiguration:config crashCollector:crashCollector];
    
    [Rollbar infoMessage:@"Rollbar is up and running! Enjoy your remote error and log monitoring..."];
}

- (void)callTroublemaker {
    NSArray *items = @[@"one", @"two", @"three"];
    NSLog(@"Here is the trouble-item: %@", items[10]);
}

    //- (void)demonstrateDeployApiUsage {
    //
    //    RollbarDeploysDemoClient * rollbarDeploysIntro = [[RollbarDeploysDemoClient new] init];
    //    [rollbarDeploysIntro demoDeploymentRegistration];
    //    [rollbarDeploysIntro demoGetDeploymentDetailsById];
    //    [rollbarDeploysIntro demoGetDeploymentsPage];
    //}


@end
