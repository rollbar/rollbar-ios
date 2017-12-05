//
//  RollbarTelemetryTests.m
//  RollbarTests
//
//  Created by Ben Wong on 12/4/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

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
        [Rollbar initWithAccessToken:@""];
    }
}

- (void)tearDown {
    [Rollbar updateConfiguration:[RollbarConfiguration configuration] isRoot:true];
    [super tearDown];
}

- (void)testTelemetryCapture {
    [Rollbar recordNavigationEventForLevel:RollbarInfo from:@"from" to:@"to"];
    [Rollbar recordConnectivityEventForLevel:RollbarInfo status:@"status"];
    [Rollbar recordNetworkEventForLevel:RollbarInfo method:@"method" url:@"url" statusCode:@"status_code"];
    [Rollbar recordErrorEventForLevel:RollbarDebug message:@"test"];
    [Rollbar recordErrorEventForLevel:RollbarError exception:[NSException exceptionWithName:@"name" reason:@"reason" userInfo:nil]];
    [Rollbar recordManualEventForLevel:RollbarDebug withData:@{@"data": @"content"}];
    [Rollbar debug:@"Test"];

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
    NSLog(@"%@", telemetryData);
}

@end
