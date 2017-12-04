//
//  RollbarTests.m
//  RollbarTests
//
//  Created by Ben Wong on 11/30/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Rollbar.h"
#import "RollbarTestUtil.h"

@interface RollbarTests : XCTestCase

@end

@implementation RollbarTests

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

- (void)testNotification {
    NSDictionary *notificationText = @{
                                       @"error": @[@"testing-error-with-message", [NSException exceptionWithName:@"testing-error" reason:@"testing-error-2" userInfo:nil]],
                                       @"debug": @[@"testing-debug"],
                                       @"error": @[@"testing-error"],
                                       @"info": @[@"testing-info"],
                                       @"critical": @[@"testing-critical"]
                                       };
    
    for (NSString *type in notificationText.allKeys) {
        NSArray *params = notificationText[type];
        if ([type isEqualToString:@"error"]) {
            if (params.count == 2) {
                [Rollbar error:params[0] exception:params[1]];
            } else {
                [Rollbar error:params[0]];
            }
        } else if ([type isEqualToString:@"debug"]) {
            [Rollbar debug:params[0]];
        } else if ([type isEqualToString:@"info"]) {
            [Rollbar info:params[0]];
        } else if ([type isEqualToString:@"critical"]) {
            [Rollbar critical:params[0]];
        }
    }

    NSArray *items = RollbarReadLogItemFromFile();
    for (id item in items) {
        NSString *level = [item valueForKeyPath:@"level"];
        NSString *message = [item valueForKeyPath:@"body.message.body"];
        NSArray *params = notificationText[level];
        if ([level isEqualToString:@"debug"]) {
            XCTAssertTrue([params[0] isEqualToString:message], @"Expects '%@', got '%@'.", params[0], message);
        } else if ([level isEqualToString:@"error"]) {
            if (params.count == 2) {
                NSException *exception = params[1];
                NSString *errMsg = [NSString stringWithFormat:@"%@\r\r%@\r\r%@", params[0], exception.reason, [exception.callStackSymbols componentsJoinedByString:@"\n"]];
                XCTAssertTrue([errMsg isEqualToString:message], @"Expects '%@', got '%@'.", errMsg, message);
            } else {
                XCTAssertTrue([params[0] isEqualToString:message], @"Expects '%@', got '%@'.", params[0], message);
            }
        } else if ([level isEqualToString:@"info"]) {
            XCTAssertTrue([params[0] isEqualToString:message], @"Expects '%@', got '%@'.", params[0], message);
        } else if ([level isEqualToString:@"critical"]) {
            XCTAssertTrue([params[0] isEqualToString:message], @"Expects '%@', got '%@'.", params[0], message);
        }
    }
}

- (void)testTelemetryData {
    int testCount = 10;
    for (int i=0; i<testCount; i++) {
        [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    }
    [Rollbar debug:@"Test"];
    NSArray *logItems = RollbarReadLogItemFromFile();
    XCTAssertTrue(logItems.count == 1, @"Log item count should be 1");

    NSDictionary *item = logItems[0];
    NSArray *telemetryData = [item valueForKeyPath:@"body.telemetry"];
    XCTAssertTrue(telemetryData.count == testCount, @"Telemetry item count should be %lu", (long)testCount);
}


@end
