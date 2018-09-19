//
//  RollbarDeploysTests.m
//  RollbarTests
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-18.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Deployment.h"
#import "RollbarDeploysManager.h"

@interface RollbarDeploysTests : XCTestCase

@end

@implementation RollbarDeploysTests

- (void)setUp {
    [super setUp];
//    RollbarClearLogFile();
//    if (!Rollbar.currentConfiguration) {
//        [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3"];
//        Rollbar.currentConfiguration.environment = @"unit-tests";
//    }
}

- (void)tearDown {
//    [Rollbar updateConfiguration:[RollbarConfiguration configuration] isRoot:true];
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

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
    
    Deployment *deployment = [[Deployment alloc] initWithEnvironment:environment
                                                             comment:comment
                                                            revision:revision
                                                       localUserName:localUsername
                                                     rollbarUserName:rollbarUsername];
    RollbarDeploysManager *deploysManager =
        [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                                readAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3"];
    [deploysManager registerDeployment:deployment];
    [NSThread sleepForTimeInterval:3.0f];
}

- (void)testGetDeploymentDetailsById {
    NSString * const testDeploymentId = @"9961771";
    RollbarDeploysManager *deploysManager =
    [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                            readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"];
    [deploysManager getDeploymentUsing:testDeploymentId];
    [NSThread sleepForTimeInterval:3.0f];
}

- (void)testGetDeploymentsPage {
    NSString * const testDeploymentId = @"9961771";
    RollbarDeploysManager *deploysManager =
    [[RollbarDeploysManager alloc] initWithWriteAccessToken:@"2d6e0add5d9b403d9126b4bcea7e0199"
                                            readAccessToken:@"d1fd12f1bd7e4340a0a55378d41061f0"];
    [deploysManager getDeploymentsPageForEnvironment:@"unit-tests" usingPageNumber:0];
    [NSThread sleepForTimeInterval:3.0f];
}

@end
