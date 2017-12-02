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
    [Rollbar initWithAccessToken:@""];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testNotification {
    NSDictionary *notificationText = @{
                                       @"debug": @[@"testing-debug"],
                                       @"error": @[@"testing-error"],
                                       @"error": @[@"testing-error-with-message", [NSException exceptionWithName:@"testing-error" reason:@"testing-error-2" userInfo:nil]],
                                       @"info": @[@"testing-info"],
                                       @"critical": @[@"testing-critical"],
                                       };
    NSString *text = @"testing";
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
    [Rollbar error:text];
    NSArray *items = RollbarReadLogItemFromFile();
    for (id itm in items) {
    }
}

@end
