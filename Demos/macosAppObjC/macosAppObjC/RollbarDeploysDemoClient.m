//
//  RollbarDeploysDemoClient.m
//  macosAppObjC
//
//  Created by Andrey Kornich on 2020-05-22.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import "RollbarDeploysDemoClient.h"
@import RollbarDeploys;

@interface RollbarDeploysObserver
    : NSObject<
        RollbarDeploymentRegistrationObserver,
        RollbarDeploymentDetailsObserver,
        RollbarDeploymentDetailsPageObserver
    >
@end

@implementation RollbarDeploysObserver

- (void)onRegisterDeploymentCompleted:(nonnull RollbarDeploymentRegistrationResult *)result {
    NSLog(@"result: %@", result);
    NSLog(@"result.description: %@", result.description);
    NSLog(@"result.outcome: %li", result.outcome);
    NSLog(@"result.deploymentId: %@", result.deploymentId);
}

- (void)onGetDeploymentDetailsCompleted:(nonnull RollbarDeploymentDetailsResult *)result {
    NSLog(@"result: %@", result);
    NSLog(@"result.description: %@", result.description);
    NSLog(@"result.outcome: %li", result.outcome);
    NSLog(@"result.deployment.deployId: %@", result.deployment.deployId);
    NSLog(@"result.deployment.projectId: %@", result.deployment.projectId);
    NSLog(@"result.deployment.revision: %@", result.deployment.revision);
    NSLog(@"result.deployment.startTime: %@", result.deployment.startTime);
    NSLog(@"result.deployment.endTime: %@", result.deployment.endTime);
}

- (void)onGetDeploymentDetailsPageCompleted:(nonnull RollbarDeploymentDetailsPageResult *)result {
    NSLog(@"result: %@", result);
    NSLog(@"result.description: %@", result.description);
    NSLog(@"result.outcome: %li", result.outcome);
    NSLog(@"result.pageNumber: %li", result.pageNumber);
    NSLog(@"result.deployments.count: %li", result.deployments.count);
    if (result.deployments.count > 0) {
        NSLog(@"result.deployments[0].description: %@", result.deployments[0].description);
    }
}

@end

@implementation RollbarDeploysDemoClient

- (void)demoDeploymentRegistration {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * const environment = @"unit-tests123";
    NSString * const comment =
        [NSString stringWithFormat:@"a new deploy at %@", [dateFormatter stringFromDate:[NSDate date]]];
    NSString * const revision = @"a_revision";
    NSString * const localUsername = @"UnitTestRunner";
    NSString * const rollbarUsername = @"rollbar";
    
    RollbarDeploysObserver *observer = [[RollbarDeploysObserver alloc] init];
    RollbarDeployment *deployment = [[RollbarDeployment alloc] initWithEnvironment:environment
                                                                           comment:comment
                                                                          revision:revision
                                                                     localUserName:localUsername
                                                                   rollbarUserName:rollbarUsername];
    RollbarDeploysManager *deploysManager =
        [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                                readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"
                                 deploymentRegistrationObserver:observer
                                      deploymentDetailsObserver:observer
                                  deploymentDetailsPageObserver:observer
         ];
    [deploysManager registerDeployment:deployment];
}

- (void)demoGetDeploymentDetailsById {
    
    NSString * const testDeploymentId = @"9961771";
    RollbarDeploysObserver *observer = [[RollbarDeploysObserver alloc] init];
    RollbarDeploysManager *deploysManager =
    [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"0d7ef175a2e14bc9b48732af2b2652f9"
                                            readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"
                             deploymentRegistrationObserver:observer
                                  deploymentDetailsObserver:observer
                              deploymentDetailsPageObserver:observer
     ];
    [deploysManager getDeploymentWithDeployId:testDeploymentId];
}

- (void)demoGetDeploymentsPage {
    
    RollbarDeploysObserver *observer = [[RollbarDeploysObserver alloc] init];
    RollbarDeploysManager *deploysManager =
    [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"0d7ef175a2e14bc9b48732af2b2652f9"
                                            readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"
                             deploymentRegistrationObserver:observer
                                  deploymentDetailsObserver:observer
                              deploymentDetailsPageObserver:observer
     ];
    [deploysManager getDeploymentsPageNumber:1];
}

@end
