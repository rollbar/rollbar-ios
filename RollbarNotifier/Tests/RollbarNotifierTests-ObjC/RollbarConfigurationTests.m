//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

#if !TARGET_OS_WATCH
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
    [Rollbar updateConfiguration:[RollbarConfig new]];
    [super tearDown];
}

- (void)testDefaultRollbarConfiguration {
    RollbarConfig *rc = [RollbarConfig new];
    NSLog(@"%@", rc);
}

- (void)testScrubSafeListFields {
    NSString *scrubedContent = @"*****";
    NSArray *keys = @[@"client.ios.app_name", @"client.ios.os_version", @"body.message.body"];
    
    // define scrub fields:
    for (NSString *key in keys) {
        [Rollbar.currentConfiguration.dataScrubber addScrubField:key];
    }
    [Rollbar debugMessage:@"test"];
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
        [Rollbar.currentConfiguration.dataScrubber addScrubSafeListField:key];
    }
    [Rollbar debugMessage:@"test"];
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
    Rollbar.currentConfiguration.telemetry.enabled = expectedFlag;
    [Rollbar reapplyConfiguration];

    XCTAssertTrue(RollbarTelemetry.sharedInstance.enabled == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.enabled is expected to be NO."
                  );
    int max = 5;
    int testCount = max;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarLevel_Debug message:@"test"];
    }

    Rollbar.currentConfiguration.loggingOptions.maximumReportsPerMinute = max;
    NSArray *telemetryCollection = [[RollbarTelemetry sharedInstance] getAllData];
    XCTAssertTrue(telemetryCollection.count == 0,
                  @"Telemetry count is expected to be %i. Actual is %lu",
                  0,
                  (unsigned long) telemetryCollection.count
                  );

    expectedFlag = YES;
    Rollbar.currentConfiguration.telemetry.enabled = expectedFlag;
    [Rollbar reapplyConfiguration];

    XCTAssertTrue(RollbarTelemetry.sharedInstance.enabled == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.enabled is expected to be YES."
                  );
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarLevel_Debug message:@"test"];
    }
    Rollbar.currentConfiguration.loggingOptions.maximumReportsPerMinute = max;
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
    Rollbar.currentConfiguration.telemetry.viewInputsScrubber.enabled = expectedFlag;
    [Rollbar reapplyConfiguration];

    XCTAssertTrue(RollbarTelemetry.sharedInstance.scrubViewInputs == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.scrubViewInputs is expected to be NO."
                  );

    expectedFlag = YES;
    Rollbar.currentConfiguration.telemetry.viewInputsScrubber.enabled = expectedFlag;
    [Rollbar reapplyConfiguration];

    XCTAssertTrue(RollbarTelemetry.sharedInstance.scrubViewInputs == expectedFlag,
                  @"RollbarTelemetry.sharedInstance.scrubViewInputs is expected to be YES."
                  );
}

- (void)testViewInputTelemetrScrubFieldsConfig {

    NSString *element1 = @"password";
    NSString *element2 = @"pin";
    
    [Rollbar.currentConfiguration.telemetry.viewInputsScrubber addScrubField:element1];
    [Rollbar.currentConfiguration.telemetry.viewInputsScrubber addScrubField:element2];
    [Rollbar reapplyConfiguration];

    XCTAssertTrue(
        RollbarTelemetry.sharedInstance.viewInputsToScrub.count == [RollbarScrubbingOptions new].scrubFields.count + 2,
        @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to count = 2"
        );
    XCTAssertTrue(
        [RollbarTelemetry.sharedInstance.viewInputsToScrub containsObject:element1],
        @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to conatin @%@",
        element1
        );
    XCTAssertTrue(
        [RollbarTelemetry.sharedInstance.viewInputsToScrub containsObject:element2],
        @"RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to conatin @%@",
        element2
        );
    
    [Rollbar.currentConfiguration.telemetry.viewInputsScrubber removeScrubField:element1];
    [Rollbar.currentConfiguration.telemetry.viewInputsScrubber removeScrubField:element2];
    [Rollbar reapplyConfiguration];

    XCTAssertTrue(
        RollbarTelemetry.sharedInstance.viewInputsToScrub.count == [RollbarScrubbingOptions new].scrubFields.count,
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


    Rollbar.currentConfiguration.developerOptions.enabled = NO;
    Rollbar.currentLogger.configuration.developerOptions.enabled = NO;
    [Rollbar debugMessage:@"Test1"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 0,
                  @"logItems count is expected to be 0. Actual value is %lu",
                  (unsigned long) logItems.count
                  );

    Rollbar.currentConfiguration.developerOptions.enabled = YES;
    [Rollbar debugMessage:@"Test2"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1,
                  @"logItems count is expected to be 1. Actual value is %lu",
                  (unsigned long) logItems.count
                  );

    Rollbar.currentConfiguration.developerOptions.enabled = NO;
    [Rollbar debugMessage:@"Test3"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1,
                  @"logItems count is expected to be 1. Actual value is %lu",
                  (unsigned long) logItems.count
                  );
    
    RollbarClearLogFile();
}

- (void)testMaximumTelemetryEvents {
    
    Rollbar.currentConfiguration.telemetry.enabled = YES;
    [Rollbar reapplyConfiguration];

    int testCount = 10;
    int max = 5;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarLevel_Debug message:@"test"];
    }

    Rollbar.currentConfiguration.telemetry.maximumTelemetryData = max;
    [Rollbar reapplyConfiguration];
    
    [Rollbar debugMessage:@"Test"];
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
    [Rollbar debugMessage:@"Don't ignore this"];
    RollbarFlushFileThread(Rollbar.currentLogger);
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");

    Rollbar.currentConfiguration.checkIgnoreRollbarData = ^BOOL(RollbarData *payloadData) {
        return true;
    };
    [Rollbar debugMessage:@"Ignore this"];
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
    [Rollbar debugMessage:@"test"];

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
    Rollbar.currentConfiguration.modifyRollbarData = ^RollbarData *(RollbarData *payloadData) {
//        [payloadData setValue:newMsg forKeyPath:@"body.message.body"];
//        [payloadData setValue:newMsg forKeyPath:@"body.message.body2"];
        payloadData.body.message.body = newMsg;
        [payloadData.body.message addKeyed:@"body2" String:newMsg];
        return payloadData;
    };
    [Rollbar debugMessage:@"test"];

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
        [Rollbar.currentConfiguration.dataScrubber addScrubField:key];
    }
    [Rollbar debugMessage:@"test"];

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
    Rollbar.currentConfiguration.telemetry.enabled = YES;
    Rollbar.currentConfiguration.telemetry.captureLog = YES;
    [Rollbar reapplyConfiguration];
    // The following line ensures the captureLogAsTelemetryData setting is flushed through the internal queue
    [[RollbarTelemetry sharedInstance] getAllData];
    NSLog(logMsg);
    [Rollbar debugMessage:@"test"];
    
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
#endif
