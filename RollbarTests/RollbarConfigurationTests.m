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

@interface RollbarConfigurationTests : XCTestCase

@end

@implementation RollbarConfigurationTests

- (void)setUp {
    [super setUp];
    RollbarClearLogFile();
    if (!Rollbar.currentConfiguration) {
        [Rollbar initWithAccessToken:@""];
    }
}

- (void)tearDown {
    [Rollbar updateConfiguration:[RollbarConfiguration configuration] isRoot:true];
    [super tearDown];
}

- (void)testTelemetryEnabled {
    RollbarClearLogFile();
    [NSThread sleepForTimeInterval:3.0f];
    
    BOOL expectedFlag = NO;
    Rollbar.currentConfiguration.telemetryEnabled = expectedFlag;
    XCTAssertTrue(RollbarTelemetry.sharedInstance.enabled == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.enabled is expected to be NO."
                  );
    int max = 5;
    int testCount = max;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    }
    [Rollbar.currentConfiguration setMaximumTelemetryData:max];
    [NSThread sleepForTimeInterval:3.0f];
    NSArray *telemetryCollection = [[RollbarTelemetry sharedInstance] getAllData];
    XCTAssertTrue(telemetryCollection.count == 0,
                  @"Telemetry count is expected to be %i. Actual is %lu",
                  0,
                  telemetryCollection.count
                  );

    expectedFlag = YES;
    Rollbar.currentConfiguration.telemetryEnabled = expectedFlag;
    XCTAssertTrue(RollbarTelemetry.sharedInstance.enabled == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.enabled is expected to be YES."
                  );
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    }
    [Rollbar.currentConfiguration setMaximumTelemetryData:max];
    [NSThread sleepForTimeInterval:3.0f];
    telemetryCollection = [[RollbarTelemetry sharedInstance] getAllData];
    XCTAssertTrue(telemetryCollection.count == max,
                  @"Telemetry count is expected to be %i. Actual is %lu",
                  max,
                  telemetryCollection.count
                  );
    
    [RollbarTelemetry.sharedInstance clearAllData];
}

- (void)testEnabled {
    
    RollbarClearLogFile();
    [NSThread sleepForTimeInterval:3.0f];
    
    Rollbar.currentConfiguration.enabled = NO;
    [Rollbar debug:@"Test1"];
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 0,
                  @"logItems count is expected to be 0. Actual value is %lu",
                  logItems.count
                  );

    Rollbar.currentConfiguration.enabled = YES;
    [Rollbar debug:@"Test2"];
    [NSThread sleepForTimeInterval:3.0f];
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1,
                  @"logItems count is expected to be 1. Actual value is %lu",
                  logItems.count
                  );

    Rollbar.currentConfiguration.enabled = NO;
    [Rollbar debug:@"Test3"];
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1,
                  @"logItems count is expected to be 1. Actual value is %lu",
                  logItems.count
                  );
    
    RollbarClearLogFile();
}

- (void)testMaximumTelemetryData {
    int testCount = 10;
    int max = 5;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    }
    [Rollbar.currentConfiguration setMaximumTelemetryData:max];
    [Rollbar debug:@"Test"];
    [NSThread sleepForTimeInterval:3.0f];
    NSArray *logItems = RollbarReadLogItemFromFile();
    NSDictionary *item = logItems[0];
    NSArray *telemetryData = [item valueForKeyPath:@"body.telemetry"];
    XCTAssertTrue(telemetryData.count == max,
                  @"Telemetry item count is %lu, should be %lu",
                  telemetryData.count,
                  (long)max
                  );
}

- (void)testCheckIgnore {
    [Rollbar debug:@"Don't ignore this"];
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");

    [Rollbar.currentConfiguration setCheckIgnore:^BOOL(NSDictionary *payload) {
        return true;
    }];
    [Rollbar debug:@"Ignore this"];
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");
}

- (void)testServerData {
    NSString *host = @"testHost";
    NSString *root = @"testRoot";
    NSString *branch = @"testBranch";
    NSString *codeVersion = @"testCodeVersion";
    [Rollbar.currentConfiguration setServerHost:host
                                           root:root
                                         branch:branch
                                    codeVersion:codeVersion
     ];
    [Rollbar debug:@"test"];

    NSArray *logItems = RollbarReadLogItemFromFile();
    NSDictionary *item = logItems[0];
    NSDictionary *server = item[@"server"];

    XCTAssertTrue([host isEqualToString:server[@"host"]],
                  @"host is %@, should be %@",
                  server[@"host"],
                  host
                  );
    XCTAssertTrue([root isEqualToString:server[@"root"]],
                  @"root is %@, should be %@",
                  server[@"root"],
                  root
                  );
    XCTAssertTrue([branch isEqualToString:server[@"branch"]],
                  @"branch is %@, should be %@",
                  server[@"branch"],
                  branch
                  );
    XCTAssertTrue([codeVersion isEqualToString:server[@"code_version"]],
                  @"code_version is %@, should be %@",
                  server[@"code_version"],
                  codeVersion
                  );
}

- (void)testPayloadModification {
    NSString *newMsg = @"Modified message";
    [Rollbar.currentConfiguration setPayloadModification:^(NSMutableDictionary *payload) {
        [payload setValue:newMsg forKeyPath:@"body.message.body"];
        [payload setValue:newMsg forKeyPath:@"body.message.body2"];
    }];
    [Rollbar debug:@"test"];

    NSArray *logItems = RollbarReadLogItemFromFile();
    NSString *msg1 = [logItems[0] valueForKeyPath:@"body.message.body"];
    NSString *msg2 = [logItems[0] valueForKeyPath:@"body.message.body2"];

    XCTAssertTrue([msg1 isEqualToString:newMsg],
                  @"body.message.body is %@, should be %@",
                  msg1,
                  newMsg
                  );
    XCTAssertTrue([msg1 isEqualToString:newMsg],
                  @"body.message.body2 is %@, should be %@",
                  msg2,
                  newMsg
                  );
}

- (void)testScrubField {
    NSString *scrubedContent = @"*****";
    NSArray *keys = @[@"client.ios.app_name", @"client.ios.ios_version", @"body.message.body"];

    for (NSString *key in keys) {
        [Rollbar.currentConfiguration addScrubField:key];
    }
    [Rollbar debug:@"test"];

    NSArray *logItems = RollbarReadLogItemFromFile();
    for (NSString *key in keys) {
        NSString *content = [logItems[0] valueForKeyPath:key];
        XCTAssertTrue([content isEqualToString:scrubedContent],
                      @"%@ is %@, should be %@",
                      key,
                      content,
                      scrubedContent
                      );
    }
}

- (void)testLogTelemetryAutoCapture {
    NSString *logMsg = @"log-message-testing";
    [[RollbarTelemetry sharedInstance] clearAllData];
    [Rollbar.currentConfiguration setCaptureLogAsTelemetryData:true];
    NSLog(logMsg);

    [Rollbar debug:@"test"];
    NSArray *logItems = RollbarReadLogItemFromFile();
    NSArray *telemetryData = [logItems[0] valueForKeyPath:@"body.telemetry"];
    NSString *telemetryMsg = [telemetryData[0] valueForKeyPath:@"body.message"];
    XCTAssertTrue([logMsg isEqualToString:telemetryMsg],
                  @"body.telemetry[0].body.message is %@, should be %@",
                  telemetryMsg,
                  logMsg
                  );
}

@end
