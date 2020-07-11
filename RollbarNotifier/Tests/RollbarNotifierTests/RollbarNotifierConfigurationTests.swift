import XCTest
import Foundation
import os.log
@testable import RollbarNotifier

final class RollbarNotifierConfigurationTests: XCTestCase {
    
    override class func setUp() {
        
        super.setUp();
        
        RollbarTestUtil.clearLogFile();
        RollbarTestUtil.clearTelemetryFile();
        
//        if Rollbar.currentConfiguration() != nil {
//            Rollbar.initWithAccessToken("");
//        }
        Rollbar.initWithAccessToken("");

    }
    
    override func tearDown() {
        Rollbar.update(RollbarConfiguration(), isRoot: true);
        super.tearDown();
    }
    
    func testDefaultRollbarConfiguration() {
        let rc = RollbarConfiguration();
        NSLog("%@", rc);
    }

    func testTelemetryEnabled() {

        RollbarTestUtil.clearLogFile();

        var expectedFlag = false;
        Rollbar.currentConfiguration().telemetryEnabled = expectedFlag;
        XCTAssertTrue(RollbarTelemetry.sharedInstance().enabled == expectedFlag,
                      "RollbarTelemetry.sharedInstance.enabled is expected to be NO."
                      );
        let max = UInt(5);
        let testCount = max;
        for _ in 0..<testCount {
            Rollbar.recordErrorEvent(for: .debug, message: "test");
        }
        Rollbar.currentConfiguration().maximumReportsPerMinute = max;
        var telemetryCollection = RollbarTelemetry.sharedInstance().getAllData()!;
        XCTAssertTrue(telemetryCollection.count == 0,
                      "Telemetry count is expected to be \(0). Actual is \(telemetryCollection.count)"
                      );

        expectedFlag = true;
        Rollbar.currentConfiguration().telemetryEnabled = expectedFlag;
        XCTAssertTrue(RollbarTelemetry.sharedInstance().enabled == expectedFlag,
                      "RollbarTelemetry.sharedInstance.enabled is expected to be YES."
                      );
        for _ in 0..<testCount {
            Rollbar.recordErrorEvent(for: .debug, message: "test");
        }
        Rollbar.currentConfiguration().maximumReportsPerMinute = max;
        telemetryCollection = RollbarTelemetry.sharedInstance().getAllData()!;
        XCTAssertTrue(telemetryCollection.count == max,
                      "Telemetry count is expected to be \(max). Actual is \(telemetryCollection.count)"
                      );
        RollbarTelemetry.sharedInstance().clearAllData();
    }

    func testScrubViewInputsTelemetryConfig() {

        var expectedFlag = false;
        Rollbar.currentConfiguration().scrubViewInputsTelemetry = expectedFlag;
        XCTAssertTrue(RollbarTelemetry.sharedInstance().scrubViewInputs == expectedFlag,
                      "RollbarTelemetry.sharedInstance.scrubViewInputs is expected to be NO."
                      );
        
        expectedFlag = true;
        Rollbar.currentConfiguration().scrubViewInputsTelemetry = expectedFlag;
        XCTAssertTrue(RollbarTelemetry.sharedInstance().scrubViewInputs == expectedFlag,
                      "RollbarTelemetry.sharedInstance.scrubViewInputs is expected to be YES."
                      );
    }

    func testViewInputTelemetrScrubFieldsConfig() {

        RollbarTestUtil.clearLogFile();

        let element1 = "password";
        let element2 = "pin";
        
        Rollbar.currentConfiguration().addTelemetryViewInput(toScrub:element1);
        Rollbar.currentConfiguration().addTelemetryViewInput(toScrub:element2);

        XCTAssertTrue(RollbarTelemetry.sharedInstance().viewInputsToScrub!.count == 2,
                      "RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to count = 2"
                      );
        XCTAssertTrue(RollbarTelemetry.sharedInstance().viewInputsToScrub!.contains(element1),
                      "RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to conatin \(element1)"
                      );
        XCTAssertTrue(RollbarTelemetry.sharedInstance().viewInputsToScrub!.contains(element2),
                      "RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to conatin \(element2)"
                      );
        
        Rollbar.currentConfiguration().removeTelemetryViewInput(toScrub:element1);
        Rollbar.currentConfiguration().removeTelemetryViewInput(toScrub:element2);
        
        XCTAssertTrue(RollbarTelemetry.sharedInstance().viewInputsToScrub!.count == 0,
                      "RollbarTelemetry.sharedInstance.viewInputsToScrub is expected to count = 0"
                      );
    }
    
    func testEnabled() {
        
        RollbarTestUtil.clearLogFile();

        var logItems = RollbarTestUtil.readItemStringsFromLogFile();
        XCTAssertTrue(logItems.count == 0,
                      "logItems count is expected to be 0. Actual value is \(logItems.count)"
                      );


        Rollbar.currentConfiguration().enabled = false;
        Rollbar.currentLogger().configuration.enabled = false;
        Rollbar.debug("Test1");
        RollbarTestUtil.waitForPesistenceToComplete();
        logItems = RollbarTestUtil.readItemStringsFromLogFile();
        XCTAssertTrue(logItems.count == 0,
                      "logItems count is expected to be 0. Actual value is \(logItems.count)"
                      );

        Rollbar.currentConfiguration().enabled = true;
        Rollbar.debug("Test2");
        RollbarTestUtil.waitForPesistenceToComplete();
        logItems = RollbarTestUtil.readItemStringsFromLogFile();
        XCTAssertTrue(logItems.count == 1,
                      "logItems count is expected to be 1. Actual value is \(logItems.count)"
                      );

        Rollbar.currentConfiguration().enabled = false;
        Rollbar.debug("Test3");
        RollbarTestUtil.waitForPesistenceToComplete();
        logItems = RollbarTestUtil.readItemStringsFromLogFile();
        XCTAssertTrue(logItems.count == 1,
                      "logItems count is expected to be 1. Actual value is\(logItems.count)"
                      );
        
        RollbarTestUtil.clearLogFile();
    }

    func testMaximumTelemetryEvents() {
        
        RollbarTestUtil.clearLogFile();

        Rollbar.currentConfiguration().telemetryEnabled = true;

        let testCount = 10;
        let max = 5;
        for _ in 0..<testCount {
            Rollbar.recordErrorEvent(for: .debug, message: "test");
        }
        Rollbar.currentConfiguration().maximumTelemetryEvents = max;
        Rollbar.debug("Test");
        RollbarTestUtil.waitForPesistenceToComplete();
        RollbarTestUtil.waitForPesistenceToComplete();
        RollbarTestUtil.waitForPesistenceToComplete();
        RollbarTestUtil.waitForPesistenceToComplete();
        let logItem = RollbarTestUtil.readFirstItemStringsFromLogFile()!;
        let payload = RollbarPayload(jsonString: logItem);
        let telemetry = payload.data.body.telemetry!;
        XCTAssertTrue(telemetry.count == max,
                      "Telemetry item count is \(telemetry.count), should be \(max)"
                      );
    }
    
    func testCheckIgnore() {

        RollbarTestUtil.clearLogFile();

        Rollbar.debug("Don't ignore this");
        RollbarTestUtil.waitForPesistenceToComplete();
        var logItems = RollbarTestUtil.readItemStringsFromLogFile();
        XCTAssertTrue(logItems.count == 1, "Log item count should be 1");

        Rollbar.currentConfiguration().checkIgnoreRollbarData = {rollbarData in return true; };
        Rollbar.debug("Ignore this");
        logItems = RollbarTestUtil.readItemStringsFromLogFile();
        XCTAssertTrue(logItems.count == 1, "Log item count should be 1");
    }

    func testServerData() {
        
        RollbarTestUtil.clearLogFile();
        
        let host = "testHost";
        let root = "testRoot";
        let branch = "testBranch";
        let codeVersion = "testCodeVersion";
        Rollbar.currentConfiguration()?.setServerHost(host, root: root, branch: branch, codeVersion: codeVersion);
        
        Rollbar.debug("test");

        RollbarTestUtil.waitForPesistenceToComplete();

        let logItem = RollbarTestUtil.readFirstItemStringsFromLogFile()!;
        let payload = RollbarPayload(jsonString: logItem);
        let server = payload.data.server!;

        XCTAssertTrue(host.compare(server.host!) == .orderedSame,
                      "host is \(server.host!), should be \(host)"
                      );
        XCTAssertTrue(root.compare(server.root!) == .orderedSame,
                      "root is \(server.root!), should be \(root)"
                      );
        XCTAssertTrue(branch.compare(server.branch!) == .orderedSame,
                      "branch is \(server.branch!), should be \(branch)"
                      );
        XCTAssertTrue(codeVersion.compare(server.codeVersion!) == .orderedSame,
                      "code_version is \(server.codeVersion!), should be \(codeVersion)"
                      );
    }

    func testPayloadModification() {
        
        RollbarTestUtil.clearLogFile();

        let newMsg = "Modified message";
        Rollbar.currentConfiguration()?.modifyRollbarData = {rollbarData in
            rollbarData?.body.message?.body = newMsg;
            rollbarData?.body.message?.addKeyed("body2", string: newMsg)
            return rollbarData;
        };
        Rollbar.debug("test");

        RollbarTestUtil.waitForPesistenceToComplete();

        let logItem = RollbarTestUtil.readFirstItemStringsFromLogFile()!;
        let payload = RollbarPayload(jsonString: logItem);
        let msg1 = payload.data.body.message!.body;
        let msg2 = payload.data.body.message!.getDataByKey("body2") as! String;

        XCTAssertTrue(msg1.compare(newMsg) == .orderedSame,
                      "body.message.body is \(msg1), should be \(newMsg)"
                      );
        XCTAssertTrue(msg2.compare(newMsg) == .orderedSame,
                      "body.message.body2 is \(msg2), should be \(newMsg)"
                      );
    }

    func testScrublistFields() {
        
        RollbarTestUtil.clearLogFile();

        let scrubedContent = "*****";
        let keys = ["client.ios.app_name", "client.ios.os_version", "body.message.body"];
        
        // define scrub fields:
        for key in keys {
            Rollbar.currentConfiguration().addScrubField(key);
        }
        
        Rollbar.debug("test");
        RollbarTestUtil.waitForPesistenceToComplete();
        
        // verify the fields were scrubbed:
        var logItem = RollbarTestUtil.readFirstItemStringsFromLogFile();
        var payload = RollbarPayload(jsonString: logItem!);
        for key in keys {
            let content = payload.data.jsonFriendlyData.value(forKeyPath: key) as! String;
            XCTAssertTrue(
                content.compare(scrubedContent) == .orderedSame,
                "\(key) is \(content), should be \(scrubedContent)"
            );
        }
        RollbarTestUtil.clearLogFile();

        // define scrub whitelist fields (the same as the scrub fields - to counterbalance them):
        for key in keys {
            Rollbar.currentConfiguration().addScrubSafeListField(key);
        }

        Rollbar.debug("test");
        RollbarTestUtil.waitForPesistenceToComplete();

        // verify the fields were not scrubbed:
        logItem = RollbarTestUtil.readFirstItemStringsFromLogFile();
        payload = RollbarPayload(jsonString: logItem!);
        for key in keys {
            let content = payload.data.jsonFriendlyData.value(forKeyPath: key) as! String;
            XCTAssertTrue(
                content.compare(scrubedContent) != .orderedSame,
                "\(key) is \(content), should not be \(scrubedContent)"
            );
        }
        RollbarTestUtil.clearLogFile();
    }

    
    //NOTE: enable the test below after telemetry of os_log is added!!!
//    func testLogTelemetryAutoCapture() {
//
//        RollbarTestUtil.clearLogFile();
//        RollbarTestUtil.clearTelemetryFile();
//        RollbarTelemetry.sharedInstance().clearAllData();
//
//        let logMsg = "log-message-testing";
//        RollbarTelemetry.sharedInstance().clearAllData();
//        //Rollbar.currentConfiguration.accessToken = @"2ffc7997ed864dda94f63e7b7daae0f3";
//        Rollbar.currentConfiguration().telemetryEnabled = true;
//        Rollbar.currentConfiguration().captureLogAsTelemetryEvents = true;
//        // The following line ensures the captureLogAsTelemetryData setting is flushed through the internal queue
//        RollbarTelemetry.sharedInstance().getAllData();
//        NSLog(logMsg);
//        Rollbar.debug("test");
//        RollbarTestUtil.waitForPesistenceToComplete();
//
//        let logItem = RollbarTestUtil.readFirstItemStringsFromLogFile()!;
//        let payload = RollbarPayload(jsonString: logItem);
//        let telemetryData = payload.data.body.telemetry!;
//        XCTAssertEqual(telemetryData.count, 1);
//        XCTAssertEqual(telemetryData[0].type, .log);
//        let telemetryMsg = (telemetryData[0].body as! RollbarTelemetryLogBody).message;
//        XCTAssertTrue(logMsg.compare(telemetryMsg) == .orderedSame,
//                      "body.telemetry[0].body.message is \(telemetryMsg), should be \(logMsg)"
//                      );
//    }

    static var allTests = [
        ("testDefaultRollbarConfiguration", testDefaultRollbarConfiguration),
        ("testTelemetryEnabled", testTelemetryEnabled),
        ("testScrubViewInputsTelemetryConfig", testScrubViewInputsTelemetryConfig),
        ("testViewInputTelemetrScrubFieldsConfig", testViewInputTelemetrScrubFieldsConfig),
        ("testEnabled", testEnabled),
        ("testMaximumTelemetryEvents", testMaximumTelemetryEvents),
        ("testCheckIgnore", testCheckIgnore),
        ("testServerData", testServerData),
        ("testPayloadModification", testPayloadModification),
        ("testScrublistFields", testScrublistFields),
//        ("testLogTelemetryAutoCapture", testLogTelemetryAutoCapture),
    ]
}
