//
//  PayloadTruncationTests.m
//  RollbarTests
//
//  Created by Andrey Kornich on 2018-07-13.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RollbarPayloadTruncator.h"

@interface PayloadTruncationTests : XCTestCase

@end

@implementation PayloadTruncationTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
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

- (void)testMeasureTotalEncodingBytes {
    
    NSString *testString1 = @"ABCD";
    unsigned long testStringBytes1 =
        [RollbarPayloadTruncator measureTotalEncodingBytes:testString1
                                             usingEncoding:NSUTF32StringEncoding];

    NSString *testString2 = [testString1 stringByAppendingString:testString1];
    unsigned long testStringBytes2 =
        [RollbarPayloadTruncator measureTotalEncodingBytes:testString2
                                             usingEncoding:NSUTF32StringEncoding];


    XCTAssertTrue(testStringBytes2 == (2 * testStringBytes1));
    XCTAssertTrue(4 == testString1.length);
    XCTAssertTrue(testString2.length == (2 * testString1.length));
    XCTAssertTrue(testStringBytes1 == (4 * testString1.length));
    XCTAssertTrue(testStringBytes2 == (4 * testString2.length));

    XCTAssertTrue((4 * [RollbarPayloadTruncator measureTotalEncodingBytes:testString1
                                                       usingEncoding:NSUTF8StringEncoding])
                  == [RollbarPayloadTruncator measureTotalEncodingBytes:testString1
                                                          usingEncoding:NSUTF32StringEncoding]);
    XCTAssertTrue((4 * [RollbarPayloadTruncator measureTotalEncodingBytes:testString1])
                  == [RollbarPayloadTruncator measureTotalEncodingBytes:testString1
                                                          usingEncoding:NSUTF32StringEncoding]);
}

- (void)testTruncateStringToTotalBytes {
    
    NSString *testString = @"ABCDE-ABCDE-ABCDE";
    NSString *truncatedString = [RollbarPayloadTruncator truncateString:testString
                                                           toTotalBytes:10];
    XCTAssertTrue([RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                  > [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);
    XCTAssertTrue(testString.length > truncatedString.length);
    
    testString = @"abcd";
    truncatedString = [RollbarPayloadTruncator truncateString:testString
                                                 toTotalBytes:10];
    XCTAssertTrue([RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                  == [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);
    XCTAssertTrue(testString.length == truncatedString.length);
    XCTAssertTrue(testString == truncatedString);
}
@end
