//
//  RollbarTriStateFlagTests.swift
//  
//
//  Created by Andrey Kornich on 2020-05-26.
//

import XCTest
import Foundation
@testable import RollbarCommon

final class RollbarTriStateFlagTests: XCTestCase {
    
    func testRollbarTriStateFlagUtil_FromStringConversion() {
        
        //XCTAssertTrue();
        
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "None"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "none"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "NONE"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "nOnE"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "NoNe"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "anything"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "?"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "."));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "*"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: "_"));
        XCTAssertEqual(RollbarTriStateFlag.none, RollbarTriStateFlagUtil.triStateFlag(from: ""));

        XCTAssertEqual(RollbarTriStateFlag.off, RollbarTriStateFlagUtil.triStateFlag(from: "Off"));
        XCTAssertEqual(RollbarTriStateFlag.off, RollbarTriStateFlagUtil.triStateFlag(from: "off"));
        XCTAssertEqual(RollbarTriStateFlag.off, RollbarTriStateFlagUtil.triStateFlag(from: "OFF"));
        XCTAssertEqual(RollbarTriStateFlag.off, RollbarTriStateFlagUtil.triStateFlag(from: "oFf"));
        XCTAssertEqual(RollbarTriStateFlag.off, RollbarTriStateFlagUtil.triStateFlag(from: "OfF"));

        XCTAssertEqual(RollbarTriStateFlag.on, RollbarTriStateFlagUtil.triStateFlag(from: "On"));
        XCTAssertEqual(RollbarTriStateFlag.on, RollbarTriStateFlagUtil.triStateFlag(from: "on"));
        XCTAssertEqual(RollbarTriStateFlag.on, RollbarTriStateFlagUtil.triStateFlag(from: "ON"));
        XCTAssertEqual(RollbarTriStateFlag.on, RollbarTriStateFlagUtil.triStateFlag(from: "oN"));

    }
    
    func testRollbarTriStateFlagUtil_ToStringConversion() {
        
        XCTAssertEqual("NONE", RollbarTriStateFlagUtil.triStateFlag(toString: RollbarTriStateFlag.none));
        XCTAssertEqual("OFF", RollbarTriStateFlagUtil.triStateFlag(toString: RollbarTriStateFlag.off));
        XCTAssertEqual("ON", RollbarTriStateFlagUtil.triStateFlag(toString: RollbarTriStateFlag.on));
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(RollbarDeploys().text, "Hello, World!")
//    }

    static var allTests = [
        ("testRollbarTriStateFlagUtil_FromStringConversion", testRollbarTriStateFlagUtil_FromStringConversion),
        ("testRollbarTriStateFlagUtil_ToStringConversion", testRollbarTriStateFlagUtil_ToStringConversion),
        //("testExample", testExample),
    ]
}
