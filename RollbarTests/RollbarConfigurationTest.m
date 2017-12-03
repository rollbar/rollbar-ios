//
//  RollbarConfigurationTest.m
//  RollbarTests
//
//  Created by Ben Wong on 12/2/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Rollbar.h"
#import "RollbarTestUtil.h"

@interface RollbarConfigurationTest : XCTestCase

@end

@implementation RollbarConfigurationTest

- (void)setUp {
    [super setUp];
    RollbarClearLogFile();
    [Rollbar initWithAccessToken:@""];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testCheckIgnore {
    [Rollbar debug:@"Don't ignore this"];
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");

    Rollbar.currentConfiguration.checkIgnore = ^BOOL(NSDictionary *payload) {
        return true;
    };
    [Rollbar debug:@"Ignore this"];
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");
}

- (void)testMaximumTelemetryData {
    int testCount = 10;
    int max = 5;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    }
    [Rollbar.currentConfiguration setMaximumTelemetryData:max];
    [Rollbar debug:@"Test"];
    NSArray *logItems = RollbarReadLogItemFromFile();
    NSDictionary *item = logItems[0];
    NSArray *telemetryData = [item valueForKeyPath:@"body.telemetry"];
    XCTAssertTrue(telemetryData.count == max, @"Telemetry item count is %lu, should be %lu", telemetryData.count, (long)max);
}

- (void)testServerData {
    NSString *host = @"testHost";
    NSString *root = @"testRoot";
    NSString *branch = @"testBranch";
    NSString *codeVersion = @"testCodeVersion";
    [Rollbar.currentConfiguration setServerHost:host root:root branch:branch codeVersion:codeVersion];
    [Rollbar debug:@"test"];

    NSArray *logItems = RollbarReadLogItemFromFile();
    NSDictionary *item = logItems[0];
    NSDictionary *server = item[@"server"];

    XCTAssertTrue([host isEqualToString:server[@"host"]], @"host is %@, should be %@", server[@"host"], host);
    XCTAssertTrue([root isEqualToString:server[@"root"]], @"root is %@, should be %@", server[@"root"], root);
    XCTAssertTrue([branch isEqualToString:server[@"branch"]], @"branch is %@, should be %@", server[@"branch"], branch);
    XCTAssertTrue([codeVersion isEqualToString:server[@"code_version"]], @"code_version is %@, should be %@", server[@"code_version"], codeVersion);
}

@end
