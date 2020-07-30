//
//  RolllbarConfigUtilTests.swift
//  
//
//  Created by Andrey Kornich on 2020-07-29.
//

import XCTest
import Foundation
@testable import RollbarNotifier


final class RolllbarNotifierConfigUtilTests: XCTestCase {
    
    override class func setUp() {
        do {
            _ = try RollbarConfigUtil.deleteDefaultRollbarConfigFile();
        }
        catch let error as NSError {
            XCTFail("\(error.localizedDescription)");
        }
    }
    
    override func tearDown() {
        do {
            _ = try RollbarConfigUtil.deleteDefaultRollbarConfigFile();
        }
        catch let error as NSError {
            XCTFail("\(error.localizedDescription)");
        }
    }
    
    func testBasics() {
        var config : RollbarConfig? = nil;
        do {
            config = try RollbarConfigUtil.createRollbarConfigFromDefaultFile();
            XCTFail("default config file should not exist");
        }
        catch let error as NSError {
            NSLog("ERROR: \(error.localizedDescription)");
            XCTAssertNil(config);
        }
    }
    
    static var allTests = [
        ("testBasics", testBasics),
    ]
}
