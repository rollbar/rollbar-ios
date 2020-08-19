//
//  RolllbarConfigUtilTests.swift
//  
//
//  Created by Andrey Kornich on 2020-07-29.
//

#if !os(watchOS)
import XCTest
import Foundation
@testable import RollbarNotifier


final class RolllbarNotifierConfigUtilTests: XCTestCase {
    
     func wrap<ReturnType>(f: () throws -> ReturnType?) -> ReturnType? {
         do {
             return try f()
         } catch let error {
            logError(error: error)
             return nil
         }
     }

     func logError(error: Error) {
        let stackSymbols = Thread.callStackSymbols
         print("Error: \(error) \n Stack Symbols: \(stackSymbols)")
     }
    
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
    
    func testNoConfigFile() {
        var config : RollbarConfig? = nil;
        
        //config = self.wrap { return try RollbarConfigUtil.createRollbarConfigFromDefaultFile(); }
        
        do {
            config = try RollbarConfigUtil.createRollbarConfigFromDefaultFile();
            XCTFail("default config file should not exist");
        }
        catch let error as NSError {
            NSLog("ERROR: \(error.localizedDescription)");
            XCTAssertNil(config);
        }
    }
    
    func testWithConfigFile() {
        var config : RollbarConfig = RollbarConfig();
        XCTAssertNotNil(config);
        do {
            _ = try RollbarConfigUtil.save(config);
        }
        catch _ as NSError {
            XCTFail("Save opration is not expected to throw.");
        }
        
        do {
            let deserializedConfig = try RollbarConfigUtil.createRollbarConfigFromDefaultFile();
            XCTAssertNotNil(deserializedConfig);
        }
        catch _ as NSError {
            XCTFail("Config instance creation is not expected to throw.");
        }
        
        do {
            try RollbarConfigUtil.deleteDefaultRollbarConfigFile();
        }
        catch _ as NSError {
            XCTFail("Default config file deletion is not expected to throw.");
        }

        do {
            config = try RollbarConfigUtil.createRollbarConfigFromDefaultFile();
            XCTFail("default config file should not exist");
        }
        catch let error as NSError {
            NSLog("ERROR: \(error.localizedDescription)");
        }
    }

    static var allTests = [
        ("testNoConfigFile", testNoConfigFile),
        ("testWithConfigFile", testWithConfigFile),
    ]
}
#endif
