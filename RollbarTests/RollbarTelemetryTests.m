//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <XCTest/XCTest.h>
#import "Rollbar.h"
#import "RollbarTestUtil.h"

@interface RollbarTelemetryTests : XCTestCase

@end

@implementation RollbarTelemetryTests

- (void)setUp {
    [super setUp];
    RollbarClearLogFile();
    if (!Rollbar.currentConfiguration) {
        [Rollbar initWithAccessToken:@"2ffc7997ed864dda94f63e7b7daae0f3"];
        Rollbar.currentConfiguration.environment = @"unit-tests";
    }

}

- (void)tearDown {
    [Rollbar updateConfiguration:[RollbarConfiguration configuration] isRoot:true];
    [super tearDown];
}

- (void)doNothing {}

- (void)testTelemetryCapture {
    [Rollbar recordNavigationEventForLevel:RollbarInfo from:@"from" to:@"to"];
    [Rollbar recordConnectivityEventForLevel:RollbarInfo status:@"status"];
    [Rollbar recordNetworkEventForLevel:RollbarInfo method:@"method" url:@"url" statusCode:@"status_code"];
    [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    [Rollbar recordErrorEventForLevel:RollbarError exception:[NSException exceptionWithName:@"name" reason:@"reason" userInfo:nil]];
    [Rollbar recordManualEventForLevel:RollbarDebug withData:@{@"data": @"content"}];
    [Rollbar debug:@"Test"];

    RollbarFlushFileThread(Rollbar.currentNotifier);

    NSArray *logItems = RollbarReadLogItemFromFile();
    NSDictionary *item = logItems[0];
    NSArray *telemetryData = [item valueForKeyPath:@"body.telemetry"];

    for (NSDictionary *data in telemetryData) {
        NSDictionary *body = data[@"body"];
        NSString *type = data[@"type"];
        if ([type isEqualToString:@"error"]) {
            if ([data[@"level"] isEqualToString:@"debug"]) {
                XCTAssertTrue([body[@"message"] isEqualToString:@"test"]);
            } else if ([data[@"level"] isEqualToString:@"error"]) {
                XCTAssertTrue([body[@"class"] isEqualToString:NSStringFromClass([NSException class])]);
                XCTAssertTrue([body[@"description"] isEqualToString:@"reason"]);
                XCTAssertTrue([body[@"message"] isEqualToString:@"reason"]);
            }
        } else if ([type isEqualToString:@"navigation"]) {
            XCTAssertTrue([body[@"from"] isEqualToString:@"from"]);
            XCTAssertTrue([body[@"to"] isEqualToString:@"to"]);
        } else if ([type isEqualToString:@"connectivity"]) {
            XCTAssertTrue([body[@"change"] isEqualToString:@"status"]);
        } else if ([type isEqualToString:@"network"]) {
            XCTAssertTrue([body[@"method"] isEqualToString:@"method"]);
            XCTAssertTrue([body[@"status_code"] isEqualToString:@"status_code"]);
            XCTAssertTrue([body[@"url"] isEqualToString:@"url"]);
        } else if ([type isEqualToString:@"manual"]) {
            XCTAssertTrue([body[@"data"] isEqualToString:@"content"]);
        }
    }
}

- (void)testErrorReportingWithTelemetry {
    [Rollbar recordNavigationEventForLevel:RollbarInfo from:@"SomeNavigationSource" to:@"SomeNavigationDestination"];
    [Rollbar recordConnectivityEventForLevel:RollbarInfo status:@"SomeConnectivityStatus"];
    [Rollbar recordNetworkEventForLevel:RollbarInfo method:@"POST" url:@"www.myservice.com" statusCode:@"200"];
    [Rollbar recordErrorEventForLevel:RollbarDebug message:@"Some telemetry message..."];
    [Rollbar recordErrorEventForLevel:RollbarError exception:[NSException exceptionWithName:@"someExceptionName" reason:@"someExceptionReason" userInfo:nil]];
    [Rollbar recordManualEventForLevel:RollbarDebug withData:@{@"myTelemetryParameter": @"itsValue"}];
    [Rollbar debug:@"Demonstrate Telemetry capture"];
    [Rollbar debug:@"Demonstrate Telemetry capture once more..."];
}

- (void)testTelemetryViewEventScrubbing {
    Rollbar.currentConfiguration.telemetryEnabled = YES;
    Rollbar.currentConfiguration.scrubViewInputsTelemetry = YES;
    [Rollbar.currentConfiguration addTelemetryViewInputToScrub:@"password"];
    [Rollbar.currentConfiguration addTelemetryViewInputToScrub:@"pin"];
    
    [Rollbar recordViewEventForLevel:RollbarDebug
                             element:@"password"
                           extraData:@{@"content" : @"My Password"}];
    [Rollbar recordViewEventForLevel:RollbarDebug
                             element:@"not-password"
                           extraData:@{@"content" : @"My Password"}];

    NSArray *telemetryEvents = [RollbarTelemetry.sharedInstance getAllData];
    
    XCTAssertTrue([@"password" compare:[telemetryEvents[0] valueForKeyPath:@"body.element"]] == NSOrderedSame);
    XCTAssertTrue([@"[scrubbed]" compare:[telemetryEvents[0] valueForKeyPath:@"body.content"]] == NSOrderedSame);

    XCTAssertTrue([@"not-password" compare:[telemetryEvents[1] valueForKeyPath:@"body.element"]] == NSOrderedSame);
    XCTAssertTrue([@"My Password" compare:[telemetryEvents[1] valueForKeyPath:@"body.content"]] == NSOrderedSame);
}

@end
