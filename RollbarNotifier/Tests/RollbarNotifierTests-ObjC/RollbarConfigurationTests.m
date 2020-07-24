//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <XCTest/XCTest.h>
#import "RollbarTestUtil.h"

@import RollbarNotifier;

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

- (void)testDefaultRollbarConfiguration {
    RollbarConfiguration *rc = [[RollbarConfiguration alloc] init];
    NSLog(@"%@", rc);
}

- (void)testScrubSafeListFields {
    NSString *scrubedContent = @"*****";
    NSArray *keys = @[@"client.ios.app_name", @"client.ios.os_version", @"body.message.body"];
    
    // define scrub fields:
    for (NSString *key in keys) {
        [Rollbar.currentConfiguration addScrubField:key];
    }
    [Rollbar debug:@"test"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    
    // verify the fields were scrubbed:
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
    
    RollbarClearLogFile();
    
    // define scrub whitelist fields (the same as the scrub fields - to counterbalance them):
    for (NSString *key in keys) {
        [Rollbar.currentConfiguration addScrubSafeListField:key];
    }
    [Rollbar debug:@"test"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    
    // verify the fields were not scrubbed:
    logItems = RollbarReadLogItemFromFile();
    for (NSString *key in keys) {
        NSString *content = [logItems[0] valueForKeyPath:key];
        XCTAssertTrue(![content isEqualToString:scrubedContent],
                      @"%@ is %@, should not be %@",
                      key,
                      content,
                      scrubedContent
                      );
    }
}

- (void)testTelemetryEnabled {
    RollbarClearLogFile();
    
    BOOL expectedFlag = NO;
    Rollbar.currentConfiguration.telemetryEnabled = expectedFlag;
    XCTAssertTrue(RollbarTelemetry.sharedInstance.enabled == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.enabled is expected to be NO."
                  );
    int max = 5;
    int testCount = max;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarLevel_Debug message:@"test"];
    }
    Rollbar.currentConfiguration.maximumReportsPerMinute = max;
    NSArray *telemetryCollection = [[RollbarTelemetry sharedInstance] getAllData];
    XCTAssertTrue(telemetryCollection.count == 0,
                  @"Telemetry count is expected to be %i. Actual is %lu",
                  0,
                  (unsigned long) telemetryCollection.count
                  );

    expectedFlag = YES;
    Rollbar.currentConfiguration.telemetryEnabled = expectedFlag;
    XCTAssertTrue(RollbarTelemetry.sharedInstance.enabled == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.enabled is expected to be YES."
                  );
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarLevel_Debug message:@"test"];
    }
    Rollbar.currentConfiguration.maximumReportsPerMinute = max;
    telemetryCollection = [[RollbarTelemetry sharedInstance] getAllData];
    XCTAssertTrue(telemetryCollection.count == max,
                  @"Telemetry count is expected to be %i. Actual is %lu",
                  max,
                  (unsigned long) telemetryCollection.count
                  );
    
    [RollbarTelemetry.sharedInstance clearAllData];
}

- (void)testScrubViewInputsTelemetryConfig {

    BOOL expectedFlag = NO;
    Rollbar.currentConfiguration.scrubViewInputsTelemetry = expectedFlag;
    XCTAssertTrue(RollbarTelemetry.sharedInstance.scrubViewInputs == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.scrubViewInputs is expected to be NO."
                  );
    expectedFlag = YES;
    Rollbar.currentConfiguration.scrubViewInputsTelemetry = expectedFlag;
    XCTAssertTrue(RollbarTelemetry.sharedInstance.scrubViewInputs == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.scrubViewInputs is expected to be YES."
                  );
}

- (void)testViewInputTelemetrScrubFieldsConfig {

    NSString *element1 = @"password";
    NSString *element2 = @"pin";
    
    [Rollbar.currentConfiguration addTelemetryViewInputToScrub:element1];
    [Rollbar.currentConfiguration addTelemetryViewInputToScrub:element2];

    XCTAssertTrue(RollbarTelemetry.sharedInstance.viewInputsToScrub.count == 2,
                  @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to count = 2"
                  );
    XCTAssertTrue([RollbarTelemetry.sharedInstance.viewInputsToScrub containsObject:element1],
                  @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to conatin @%@",
                  element1
                  );
    XCTAssertTrue([RollbarTelemetry.sharedInstance.viewInputsToScrub containsObject:element2],
                  @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to conatin @%@",
                  element2
                  );
    
    [Rollbar.currentConfiguration removeTelemetryViewInputToScrub:element1];
    [Rollbar.currentConfiguration removeTelemetryViewInputToScrub:element2];
    
    XCTAssertTrue(RollbarTelemetry.sharedInstance.viewInputsToScrub.count == 0,
                  @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to count = 0"
                  );
}

- (void)testEnabled {
    
    RollbarClearLogFile();
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 0,
                  @"logItems count is expected to be 0. Actual value is %lu",
                  (unsigned long) logItems.count
                  );


    Rollbar.currentConfiguration.enabled = NO;
    Rollbar.currentLogger.configuration.enabled = NO;
    [Rollbar debug:@"Test1"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 0,
                  @"logItems count is expected to be 0. Actual value is %lu",
                  (unsigned long) logItems.count
                  );

    Rollbar.currentConfiguration.enabled = YES;
    [Rollbar debug:@"Test2"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1,
                  @"logItems count is expected to be 1. Actual value is %lu",
                  (unsigned long) logItems.count
                  );

    Rollbar.currentConfiguration.enabled = NO;
    [Rollbar debug:@"Test3"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1,
                  @"logItems count is expected to be 1. Actual value is %lu",
                  (unsigned long) logItems.count
                  );
    
    RollbarClearLogFile();
}

- (void)testMaximumTelemetryEvents {
    
    Rollbar.currentConfiguration.telemetryEnabled = YES;

    int testCount = 10;
    int max = 5;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarLevel_Debug message:@"test"];
    }
    Rollbar.currentConfiguration.maximumTelemetryEvents = max;
    [Rollbar debug:@"Test"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    NSArray *logItems = RollbarReadLogItemFromFile();
    NSDictionary *item = logItems[0];
    NSArray *telemetryData = [item valueForKeyPath:@"body.telemetry"];
    XCTAssertTrue(telemetryData.count == max,
                  @"Telemetry item count is %lu, should be %lu",
                  (unsigned long) telemetryData.count,
                  (long)max
                  );
}

- (void)testCheckIgnore {
    [Rollbar debug:@"Don't ignore this"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");

    [Rollbar.currentConfiguration setCheckIgnoreBlock:^BOOL(NSDictionary *payload) {
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

    RollbarFlushFileThread(Rollbar.currentLogger);

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
    [Rollbar.currentConfiguration setPayloadModificationBlock:^(NSMutableDictionary *payload) {
        [payload setValue:newMsg forKeyPath:@"body.message.body"];
        [payload setValue:newMsg forKeyPath:@"body.message.body2"];
    }];
    [Rollbar debug:@"test"];

    RollbarFlushFileThread(Rollbar.currentLogger);

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
    NSArray *keys = @[@"client.ios.app_name", @"client.ios.os_version", @"body.message.body"];

    for (NSString *key in keys) {
        [Rollbar.currentConfiguration addScrubField:key];
    }
    [Rollbar debug:@"test"];

    RollbarFlushFileThread(Rollbar.currentLogger);

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
    //Rollbar.currentConfiguration.accessToken = @"2ffc7997ed864dda94f63e7b7daae0f3";
    Rollbar.currentConfiguration.telemetryEnabled = YES;
    Rollbar.currentConfiguration.captureLogAsTelemetryEvents = YES;
    // The following line ensures the captureLogAsTelemetryData setting is flushed through the internal queue
    [[RollbarTelemetry sharedInstance] getAllData];
    NSLog(logMsg);
    [Rollbar debug:@"test"];
    
    RollbarFlushFileThread(Rollbar.currentLogger);

    NSArray *logItems = RollbarReadLogItemFromFile();
    NSArray *telemetryData = [logItems[0] valueForKeyPath:@"body.telemetry"];
    NSString *telemetryMsg = [telemetryData[0] valueForKeyPath:@"body.message"];
    XCTAssertTrue([logMsg isEqualToString:telemetryMsg],
                  @"body.telemetry[0].body.message is %@, should be %@",
                  telemetryMsg,
                  logMsg
                  );
    
    //[NSThread sleepForTimeInterval:3.0f];
}

@end
