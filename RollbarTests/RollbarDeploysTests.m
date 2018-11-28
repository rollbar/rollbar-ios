//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <XCTest/XCTest.h>
#import "Deployment.h"
#import "DeployApiCallResult.h"
#import "RollbarDeploysManager.h"
#import "RollbarDeploysProtocol.h"


@interface RollbarDeploysObserver : NSObject
<DeploymentRegistrationObserver,
DeploymentDetailsObserver,
DeploymentDetailsPageObserver>
@end

@implementation RollbarDeploysObserver
- (void)onRegisterDeploymentCompleted:(DeployApiCallResult *)result {
    NSLog(@"%@", result);
}

- (void)onGetDeploymentDetailsCompleted:(DeploymentDetailsResult *)result {
    NSLog(@"%@", result);
}

- (void)onGetDeploymentDetailsPageCompleted:(DeploymentDetailsPageResult *)result {
    NSLog(@"%@", result);
}

@end


@interface RollbarDeploysTests : XCTestCase
@end

@implementation RollbarDeploysTests

- (void)testDeploymentDto {
    NSString * const environment = @"unit-tests";
    NSString * const comment = @"a new deploy";
    NSString * const revision = @"a_revision";
    NSString * const localUsername = @"UnitTestRunner";
    NSString * const rollbarUsername = @"rollbar";
    
    Deployment *deployment = [[Deployment alloc] initWithEnvironment:environment
                                                             comment:comment
                                                            revision:revision
                                                       localUserName:localUsername
                                                     rollbarUserName:rollbarUsername];
    
    XCTAssertTrue(nil != deployment.environment);
    XCTAssertTrue(nil != deployment.comment);
    XCTAssertTrue(nil != deployment.revision);
    XCTAssertTrue(nil != deployment.localUsername);
    XCTAssertTrue(nil != deployment.rollbarUsername);
    
    XCTAssertTrue(environment == deployment.environment);
    XCTAssertTrue(comment == deployment.comment);
    XCTAssertTrue(revision == deployment.revision);
    XCTAssertTrue(localUsername == deployment.localUsername);
    XCTAssertTrue(rollbarUsername == deployment.rollbarUsername);
}

- (void)testDeploymentRegistration {
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString * const environment = @"unit-tests123";
    NSString * const comment =
        [NSString stringWithFormat:@"a new deploy at %@", [dateFormatter stringFromDate:[NSDate date]]];
    NSString * const revision = @"a_revision";
    NSString * const localUsername = @"UnitTestRunner";
    NSString * const rollbarUsername = @"rollbar";
    
    RollbarDeploysObserver *observer = [[RollbarDeploysObserver alloc] init];
    Deployment *deployment = [[Deployment alloc] initWithEnvironment:environment
                                                             comment:comment
                                                            revision:revision
                                                       localUserName:localUsername
                                                     rollbarUserName:rollbarUsername];
    RollbarDeploysManager *deploysManager =
        [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                                readAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3"
                                 deploymentRegistrationObserver:observer
                                      deploymentDetailsObserver:observer
                                  deploymentDetailsPageObserver:observer
         ];
    [deploysManager registerDeployment:deployment];
}

- (void)testGetDeploymentDetailsById {
    NSString * const testDeploymentId = @"9961771";
    RollbarDeploysObserver *observer = [[RollbarDeploysObserver alloc] init];
    RollbarDeploysManager *deploysManager =
    [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                            readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"
                             deploymentRegistrationObserver:observer
                                  deploymentDetailsObserver:observer
                              deploymentDetailsPageObserver:observer
     ];
    [deploysManager getDeploymentWithDeployId:testDeploymentId];
}

- (void)testGetDeploymentsPage {
    RollbarDeploysObserver *observer = [[RollbarDeploysObserver alloc] init];
    RollbarDeploysManager *deploysManager =
    [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                            readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"
                             deploymentRegistrationObserver:observer
                                  deploymentDetailsObserver:observer
                              deploymentDetailsPageObserver:observer
     ];
    [deploysManager getDeploymentsPageNumber:1];
}

@end

