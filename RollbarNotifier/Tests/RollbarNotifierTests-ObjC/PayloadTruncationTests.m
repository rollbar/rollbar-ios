//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <XCTest/XCTest.h>
#import "RollbarTestUtil.h"
//#import "../Rollbar/Notifier/RollbarPayloadTruncator.h"

@import RollbarNotifier;

@interface PayloadTruncationTests : XCTestCase

@end

@implementation PayloadTruncationTests

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
    
    // test "truncation expected" case:
    NSString *testString = @"ABCDE-ABCDE-ABCDE";
    const int truncationBytesLimit = 10;
    XCTAssertTrue(truncationBytesLimit
                  < [RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                  );
    NSString *truncatedString = [RollbarPayloadTruncator truncateString:testString
                                                           toTotalBytes:truncationBytesLimit];
    XCTAssertTrue([RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                  > [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);
    XCTAssertTrue(truncationBytesLimit
                  >= [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]
                  );
    XCTAssertTrue(testString.length > truncatedString.length);
    
    // test "truncation not needed" case:
    testString = @"abcd";
    truncatedString = [RollbarPayloadTruncator truncateString:testString
                                                 toTotalBytes:truncationBytesLimit];
    XCTAssertTrue([RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                  == [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);
    XCTAssertTrue(testString.length == truncatedString.length);
    XCTAssertTrue(testString == truncatedString);
}

- (void)testTruncateStringToTotalBytesUnicode {
    
    NSArray *testStrings = @[
                             @"🌍🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
                             @"A🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
                             @"AB🌍🌍🌍-🌍🌍🌍🌍🌍",
                             @"ABC🌍🌍-🌍🌍🌍🌍🌍",
                             @"ABCD🌍-🌍🌍🌍🌍🌍",
                             @"ABCDE-🌍🌍🌍🌍🌍",
                             @"ABCDE-A🌍🌍🌍🌍",
                             @"ABCDE-AB🌍🌍🌍",
                             @"ABCDE-ABC🌍🌍",
                             @"ABCDE-ABCD🌍",
                             @"🌍🌍🌍🌍🌍-🌍🌍🌍🌍E",
                             @"🌍🌍🌍🌍🌍-🌍🌍🌍DE",
                             @"🌍🌍🌍🌍🌍-🌍🌍CDE",
                             @"🌍🌍🌍🌍🌍-🌍BCDE",
                             @"🌍🌍🌍🌍🌍-ABCDE",
                             @"🌍🌍🌍🌍E-ABCDE",
                             @"🌍🌍🌍DE-ABCDE",
                             @"🌍🌍CDE-ABCDE",
                             @"🌍BCDE-ABCDE",
                             @"ABCDE-ABCDE",
                             @"אספירין-אספירין",
                             @"Pound123Pound"
                             ];
    
    for (NSString *testString in testStrings) {
        const int truncationBytesLimit = 10;
        XCTAssertTrue(truncationBytesLimit
                      < [RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                      );
        NSString *truncatedString = [RollbarPayloadTruncator truncateString:testString
                                                               toTotalBytes:truncationBytesLimit];
        NSLog(testString);
        NSLog(truncatedString);
        NSLog(@"%d", [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);

        
        XCTAssertTrue([RollbarPayloadTruncator measureTotalEncodingBytes:testString]
                      > [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);
        XCTAssertTrue(truncationBytesLimit
                      >= [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]
                      );
        XCTAssertTrue(testString.length > truncatedString.length);
        
    }
}

- (void)testVisuallyTruncateStringToTotalBytesUnicode {
    
    NSArray *testStrings = @[
                             @"🌍🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
                             @"A🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
                             @"AB🌍🌍🌍-🌍🌍🌍🌍🌍",
                             @"ABC🌍🌍-🌍🌍🌍🌍🌍",
                             @"ABCD🌍-🌍🌍🌍🌍🌍",
                             @"ABCDE-🌍🌍🌍🌍🌍",
                             @"ABCDE-A🌍🌍🌍🌍",
                             @"ABCDE-AB🌍🌍🌍",
                             @"ABCDE-ABC🌍🌍",
                             @"ABCDE-ABCD🌍",
                             @"🌍🌍🌍🌍🌍-🌍🌍🌍🌍E",
                             @"🌍🌍🌍🌍🌍-🌍🌍🌍DE",
                             @"🌍🌍🌍🌍🌍-🌍🌍CDE",
                             @"🌍🌍🌍🌍🌍-🌍BCDE",
                             @"🌍🌍🌍🌍🌍-ABCDE",
                             @"🌍🌍🌍🌍E-ABCDE",
                             @"🌍🌍🌍DE-ABCDE",
                             @"🌍🌍CDE-ABCDE",
                             @"🌍BCDE-ABCDE",
                             @"ABCDE-ABCDE",
                             @"אספירין-אספירין",
                             @"Pound123Pound"
                             ];
    
    int truncationBytesLimit = -1;
    while (truncationBytesLimit < 42) {
        NSLog(@"*** Truncation limit: %d", truncationBytesLimit);
        
        for (NSString *testString in testStrings) {
            NSString *truncatedString = [RollbarPayloadTruncator truncateString:testString
                                                                   toTotalBytes:truncationBytesLimit];
            NSLog(testString);
            NSLog(truncatedString);
            NSLog(@"%d", [RollbarPayloadTruncator measureTotalEncodingBytes:truncatedString]);
        }

        truncationBytesLimit++;
    }
        
    
}

- (void)testPayloadTruncation {

    @try {
        NSArray *crew = [NSArray arrayWithObjects:
                         @"Dave",
                         @"Heywood",
                         @"Frank", nil];
        // This will throw an exception.
        NSLog(@"%@", [crew objectAtIndex:10]);
    }
    @catch (NSException *exception) {
        [Rollbar error:nil exception:exception];
    }
    
    RollbarFlushFileThread(Rollbar.currentLogger);
    NSArray *items = RollbarReadLogItemFromFile();
    
    for (id payload in items) {
        NSMutableArray *frames = [payload mutableArrayValueForKeyPath:@"body.trace.frames"];
        unsigned long totalFramesBeforeTruncation = frames.count;
        [RollbarPayloadTruncator truncatePayload:payload toTotalBytes:20];
        unsigned long totalFramesAfterTruncation = frames.count;
        XCTAssertTrue(totalFramesBeforeTruncation > totalFramesAfterTruncation);
        XCTAssertTrue(1 == totalFramesAfterTruncation);
        
        NSMutableString *simulatedLongString = [@"1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_" mutableCopy];
        [[frames objectAtIndex:0] setObject:simulatedLongString forKey:@"library"];
        XCTAssertTrue([[[frames objectAtIndex:0] objectForKey:@"library"] length] > 256);
        [RollbarPayloadTruncator truncatePayload:payload toTotalBytes:20];
        XCTAssertTrue(totalFramesAfterTruncation == frames.count);
        XCTAssertTrue([[[frames objectAtIndex:0] objectForKey:@"library"] length] <= 256);
    }
}

- (void)testErrorReportingWithTruncation {
    
    NSMutableString *simulatedLongString =
        [[NSMutableString alloc] initWithCapacity:(512 + 1)*1024];
    while (simulatedLongString.length < (512 * 1024)) {
        [simulatedLongString appendString:@"1234567890_"];
    }

    [Rollbar critical:@"Message with long extra data"
            exception:nil
                 data:@{@"extra_truncatable_data": simulatedLongString}
     ];

    @try {
        NSArray *crew = [NSArray arrayWithObjects:
                         @"Dave",
                         @"Heywood",
                         @"Frank", nil];
        // This will throw an exception.
        NSLog(@"%@", [crew objectAtIndex:10]);
    }
    @catch (NSException *exception) {

        [Rollbar critical:simulatedLongString
                exception:exception
                     data:@{@"extra_truncatable_data": simulatedLongString}
         ];

        [NSThread sleepForTimeInterval:1.0f];

        // What is this doing?
//        [Rollbar.currentNotifier updateReportingRate:10];
//        [Rollbar.currentNotifier updateReportingRate:60];
//        [Rollbar.currentNotifier updateReportingRate:20];
//        [Rollbar.currentNotifier updateReportingRate:60];
    }
}

@end
