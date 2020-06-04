import XCTest
import Foundation
import os.log
@testable import RollbarNotifier

final class RollbarNotifierTruncationTests: XCTestCase {
    
    override class func setUp() {
        
        super.setUp();
        
        RollbarTestUtil.clearLogFile();
        RollbarTestUtil.clearTelemetryFile();
        
        //if Rollbar.currentConfiguration() != nil {
            Rollbar.initWithAccessToken("2ffc7997ed864dda94f63e7b7daae0f3");
            Rollbar.currentConfiguration().environment = "unit-tests";
        //}
    }
    
    override func tearDown() {
        Rollbar.update(RollbarConfiguration(), isRoot: true);
        super.tearDown();
    }
    
    func testDefaultRollbarConfiguration() {
        NSLog("%@", Rollbar.currentConfiguration());
    }

    func testMeasureTotalEncodingBytes() {
        
        let testString1 = "ABCD";
        let testStringBytes1 = RollbarPayloadTruncator.measureTotalEncodingBytes(
            testString1,
            usingEncoding: String.Encoding.utf32.rawValue
        );

        let testString2 = testString1 + testString1;
        let testStringBytes2 = RollbarPayloadTruncator.measureTotalEncodingBytes(
            testString2,
            usingEncoding: String.Encoding.utf32.rawValue
        );


        XCTAssertTrue(testStringBytes2 == (2 * testStringBytes1));
        XCTAssertTrue(4 == testString1.count);
        XCTAssertTrue(testString2.count == (2 * testString1.count));
        XCTAssertTrue(testStringBytes1 == (4 * testString1.count));
        XCTAssertTrue(testStringBytes2 == (4 * testString2.count));

        XCTAssertTrue(
            (4 * RollbarPayloadTruncator.measureTotalEncodingBytes(
                testString1,
                usingEncoding: String.Encoding.utf8.rawValue
                ))
            == RollbarPayloadTruncator.measureTotalEncodingBytes(
                testString1,
                usingEncoding: String.Encoding.utf32.rawValue
            )
        );
        XCTAssertTrue(
            (4 * RollbarPayloadTruncator.measureTotalEncodingBytes(testString1))
            == RollbarPayloadTruncator.measureTotalEncodingBytes(
            testString1,
            usingEncoding:String.Encoding.utf32.rawValue
            )
        );
    }

    func testTruncateStringToTotalBytes() {
        
        // test "truncation expected" case:
        var testString = "ABCDE-ABCDE-ABCDE";
        let truncationBytesLimit = UInt(10);
        XCTAssertTrue(truncationBytesLimit < RollbarPayloadTruncator.measureTotalEncodingBytes(testString));
        
        var truncatedString = RollbarPayloadTruncator.truncate(testString, toTotalBytes: truncationBytesLimit)!;
        XCTAssertTrue(
            RollbarPayloadTruncator.measureTotalEncodingBytes(testString)
            > RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString)
        );
        XCTAssertTrue(
            truncationBytesLimit
            >= RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString)
        );
        XCTAssertTrue(testString.count > truncatedString.count);
        
        // test "truncation not needed" case:
        testString = "abcd";
        truncatedString = RollbarPayloadTruncator.truncate(
            testString,
            toTotalBytes: truncationBytesLimit
        );
        XCTAssertTrue(
            RollbarPayloadTruncator.measureTotalEncodingBytes(testString)
                == RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString)
        );
        XCTAssertTrue(testString.count == truncatedString.count);
        XCTAssertTrue(testString == truncatedString);
    }
    
    func testTruncateStringToTotalBytesUnicode() {
        
        let testStrings = [
            "🌍🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
            "A🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
            "AB🌍🌍🌍-🌍🌍🌍🌍🌍",
            "ABC🌍🌍-🌍🌍🌍🌍🌍",
            "ABCD🌍-🌍🌍🌍🌍🌍",
            "ABCDE-🌍🌍🌍🌍🌍",
            "ABCDE-A🌍🌍🌍🌍",
            "ABCDE-AB🌍🌍🌍",
            "ABCDE-ABC🌍🌍",
            "ABCDE-ABCD🌍",
            "🌍🌍🌍🌍🌍-🌍🌍🌍🌍E",
            "🌍🌍🌍🌍🌍-🌍🌍🌍DE",
            "🌍🌍🌍🌍🌍-🌍🌍CDE",
            "🌍🌍🌍🌍🌍-🌍BCDE",
            "🌍🌍🌍🌍🌍-ABCDE",
            "🌍🌍🌍🌍E-ABCDE",
            "🌍🌍🌍DE-ABCDE",
            "🌍🌍CDE-ABCDE",
            "🌍BCDE-ABCDE",
            "ABCDE-ABCDE",
                        "אספירין-אספירין",
                                 "Pound123Pound"
        ];
        
        for testString in testStrings {
            let truncationBytesLimit = UInt(10);
            XCTAssertTrue(truncationBytesLimit < RollbarPayloadTruncator.measureTotalEncodingBytes(testString));
            
            let truncatedString =
                RollbarPayloadTruncator.truncate(testString, toTotalBytes: truncationBytesLimit)!;
            NSLog(testString);
            NSLog(truncatedString);
            NSLog("\(RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString))");

            
            XCTAssertTrue(
                RollbarPayloadTruncator.measureTotalEncodingBytes(testString)
                > RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString)
            );
            XCTAssertTrue(truncationBytesLimit >= RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString));
            XCTAssertTrue(testString.count > truncatedString.count);
        }
    }

    func testVisuallyTruncateStringToTotalBytesUnicode() {
        
        let testStrings = [
            "🌍🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
            "A🌍🌍🌍🌍-🌍🌍🌍🌍🌍",
            "AB🌍🌍🌍-🌍🌍🌍🌍🌍",
            "ABC🌍🌍-🌍🌍🌍🌍🌍",
            "ABCD🌍-🌍🌍🌍🌍🌍",
            "ABCDE-🌍🌍🌍🌍🌍",
            "ABCDE-A🌍🌍🌍🌍",
            "ABCDE-AB🌍🌍🌍",
            "ABCDE-ABC🌍🌍",
            "ABCDE-ABCD🌍",
            "🌍🌍🌍🌍🌍-🌍🌍🌍🌍E",
            "🌍🌍🌍🌍🌍-🌍🌍🌍DE",
            "🌍🌍🌍🌍🌍-🌍🌍CDE",
            "🌍🌍🌍🌍🌍-🌍BCDE",
            "🌍🌍🌍🌍🌍-ABCDE",
            "🌍🌍🌍🌍E-ABCDE",
            "🌍🌍🌍DE-ABCDE",
            "🌍🌍CDE-ABCDE",
            "🌍BCDE-ABCDE",
            "ABCDE-ABCDE",
                                 "אספירין-אספירין",
            "Pound123Pound"
        ];
        
        var truncationBytesLimit = UInt(0);
        while (truncationBytesLimit < 42) {
            NSLog("*** Truncation limit: \(truncationBytesLimit)");
            
            for testString in testStrings {
                let truncatedString =
                    RollbarPayloadTruncator.truncate(testString, toTotalBytes: truncationBytesLimit)!;
                NSLog(testString);
                NSLog(truncatedString);
                NSLog("\(RollbarPayloadTruncator.measureTotalEncodingBytes(truncatedString))");
            }

            truncationBytesLimit += 1;
        }
    }
    
    // NOTE: redo the following test into two:
    // 1. to test catching Error/NSError thrown from Swift/Objective-C code
    //    after adding Rollbar suport to report an NSError.
    // 2. te test catching NSException (thrown from ObjC code) in Swift by first turning it into Swift Error/NSError.
//    - (void)testPayloadTruncation {
//
//        @try {
//            NSArray *crew = [NSArray arrayWithObjects:
//                             @"Dave",
//                             @"Heywood",
//                             @"Frank", nil];
//            // This will throw an exception.
//            NSLog(@"%@", [crew objectAtIndex:10]);
//        }
//        @catch (NSException *exception) {
//            [Rollbar error:nil exception:exception];
//        }
//
//        RollbarFlushFileThread(Rollbar.currentNotifier);
//        NSArray *items = RollbarReadLogItemFromFile();
//
//        for (id payload in items) {
//            NSMutableArray *frames = [payload mutableArrayValueForKeyPath:@"body.trace.frames"];
//            unsigned long totalFramesBeforeTruncation = frames.count;
//            [RollbarPayloadTruncator truncatePayload:payload toTotalBytes:20];
//            unsigned long totalFramesAfterTruncation = frames.count;
//            XCTAssertTrue(totalFramesBeforeTruncation > totalFramesAfterTruncation);
//            XCTAssertTrue(1 == totalFramesAfterTruncation);
//
//            NSMutableString *simulatedLongString = [@"1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_1234567890_" mutableCopy];
//            [[frames objectAtIndex:0] setObject:simulatedLongString forKey:@"library"];
//            XCTAssertTrue([[[frames objectAtIndex:0] objectForKey:@"library"] length] > 256);
//            [RollbarPayloadTruncator truncatePayload:payload toTotalBytes:20];
//            XCTAssertTrue(totalFramesAfterTruncation == frames.count);
//            XCTAssertTrue([[[frames objectAtIndex:0] objectForKey:@"library"] length] <= 256);
//        }
//    }

    // NOTE: redo the following test into two:
    // 1. to test catching Error/NSError thrown from Swift/Objective-C code
    //    after adding Rollbar suport to report an NSError.
    // 2. te test catching NSException (thrown from ObjC code) in Swift by first turning it into Swift Error/NSError.
//    - (void)testErrorReportingWithTruncation {
//
//        NSMutableString *simulatedLongString =
//            [[NSMutableString alloc] initWithCapacity:(512 + 1)*1024];
//        while (simulatedLongString.length < (512 * 1024)) {
//            [simulatedLongString appendString:@"1234567890_"];
//        }
//
//        [Rollbar critical:@"Message with long extra data"
//                exception:nil
//                     data:@{@"extra_truncatable_data": simulatedLongString}
//         ];
//
//        @try {
//            NSArray *crew = [NSArray arrayWithObjects:
//                             @"Dave",
//                             @"Heywood",
//                             @"Frank", nil];
//            // This will throw an exception.
//            NSLog(@"%@", [crew objectAtIndex:10]);
//        }
//        @catch (NSException *exception) {
//
//            [Rollbar critical:simulatedLongString
//                    exception:exception
//                         data:@{@"extra_truncatable_data": simulatedLongString}
//             ];
//
//            [NSThread sleepForTimeInterval:1.0f];
//        }
//    }

    
    static var allTests = [
        ("testDefaultRollbarConfiguration", testDefaultRollbarConfiguration),
        ("testMeasureTotalEncodingBytes", testMeasureTotalEncodingBytes),
        ("testTruncateStringToTotalBytes", testTruncateStringToTotalBytes),
        ("testTruncateStringToTotalBytesUnicode", testTruncateStringToTotalBytesUnicode),
        ("testVisuallyTruncateStringToTotalBytesUnicode", testVisuallyTruncateStringToTotalBytesUnicode),
        //("testPayloadTruncation", testPayloadTruncation),
        //("testErrorReportingWithTruncation", testErrorReportingWithTruncation),
    ]
}
