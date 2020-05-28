//
//  NSJSONSerialization+RollbarTests.swift
//  
//
//  Created by Andrey Kornich on 2020-05-26.
//

import XCTest
import Foundation
@testable import RollbarCommon

final class NSJSONSerializationRollbarTests: XCTestCase {
    
    func testNSJSONSerializationRollbar_measureJSONDataByteSize() {
        
        let data = [
            "body": "Message",
            "attribute": "An attribute",
        ];

        let payload = [
            "access_token": "321",
            "data": data,
            ] as [String : Any];
        
        do {
            let nsData = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted);
            XCTAssertEqual(103, JSONSerialization.rollbar_measureJSONDataByteSize(nsData));
        }
        catch {
            XCTFail("Unexpected failure!");
        }        
    }
    
    func testNSJSONSerializationRollbar_dataWithJSONObject() {
        // The testNSJSONSerializationRollbar_safeDataFromJSONObject() covers this one as well.
        // At least for now...
    }
    
    func testNSJSONSerializationRollbar_safeDataFromJSONObject() {
                
        let goldenStandard =
            "{\"access_token\":\"321\",\"data\":{\"attribute\":\"An attribute\",\"body\":\"Message\",\"date\":\"1970-01-01 00:00:00 +0000\",\"error\":{},\"httpUrlResponse\":{\"header1\":\"Header 1\",\"header2\":\"Header 2\"},\"innerData\":{\"attribute\":\"An attribute\",\"body\":\"Message\",\"date\":\"1970-01-01 00:00:00 +0000\",\"error\":{},\"httpUrlResponse\":{\"header1\":\"Header 1\",\"header2\":\"Header 2\"},\"scrubFields\":\"secret,CCV,password\",\"url\":\"http:\\/\\/www.apple.com\"},\"scrubFields\":\"secret,CCV,password\",\"url\":\"http:\\/\\/www.apple.com\"}}";
        
        var data = [
            "body": "Message",
            "attribute": "An attribute",
            "date": NSDate.init(timeIntervalSince1970: TimeInterval.init()),
            "url": NSURL.init(string: "http://www.apple.com")!,
            "error": NSError.init(domain: "Error Domain", code: 101, userInfo: nil),
            "httpUrlResponse": HTTPURLResponse.init(
                url: URL.init(string: "https://www.rollbar.com")!,
                statusCode: 500,
                httpVersion: "1.2",
                headerFields: ["header1": "Header 1", "header2": "Header 2"]) as Any,
            "scrubFields": NSSet.init(array: ["password", "secret", "CCV"]),
            ] as [String : Any];
        
        if #available(OSX 10.13, *) {
            data["innerData"] = JSONSerialization.rollbar_data(
                withJSONObject: data,
                options: .sortedKeys,
                error: nil,
                safe: true)
        } else {
            // Fallback on earlier versions
            XCTFail("Test it on more recent OS version!");
        };

        let payload = [
            "access_token": "321",
            "data": data,
            ] as [String : Any];
        
        let safeJson = JSONSerialization.rollbar_safeData(fromJSONObject: payload);

        do {
            if #available(OSX 10.13, *) {
                let jsonData = try JSONSerialization.data(withJSONObject: safeJson, options: .sortedKeys)
                let result = String.init(data: jsonData, encoding: .utf8);
                XCTAssertEqual(goldenStandard, result);
            } else {
                // Fallback on earlier versions
                XCTFail("Test it on more recent OS version!");
            };
        }
        catch {
            XCTFail("Unexpected failure!");
        }
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(RollbarDeploys().text, "Hello, World!")
//    }

    static var allTests = [
        ("testNSJSONSerializationRollbar_measureJSONDataByteSize", testNSJSONSerializationRollbar_measureJSONDataByteSize),
        ("testNSJSONSerializationRollbar_dataWithJSONObject", testNSJSONSerializationRollbar_dataWithJSONObject),
        ("testNSJSONSerializationRollbar_safeDataFromJSONObject", testNSJSONSerializationRollbar_safeDataFromJSONObject),
        //("testExample", testExample),
    ]
}
