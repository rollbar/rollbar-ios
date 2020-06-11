import XCTest
import Foundation
//import os.log
@testable import RollbarNotifier

final class RollbarNotifierTelemetryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp();
        RollbarTestUtil.clearLogFile();
        RollbarTestUtil.clearTelemetryFile();
        if Rollbar.currentConfiguration() != nil {
            print("Info: Rollbar already pre-configured!");
        }
        else {
            Rollbar.initWithAccessToken("2ffc7997ed864dda94f63e7b7daae0f3");
            Rollbar.currentConfiguration().environment = "unit-tests";
        }
    }
    
    override func tearDown() {
        Rollbar.update(RollbarConfiguration(), isRoot: true);
        super.tearDown();
    }
    
    func testTelemetryCapture() {
        
        RollbarTestUtil.clearLogFile();
        RollbarTestUtil.clearTelemetryFile();

        Rollbar.currentConfiguration().telemetryEnabled = true;
        
        Rollbar.recordNavigationEvent(
            for: .info,
            from: "from",
            to: "to"
        );
        Rollbar.recordConnectivityEvent(
            for: .info,
            status: "connactivity_status"
        );
        Rollbar.recordNetworkEvent(
            for: .info,
            method: "DELETE",
            url: "url",
            statusCode: "status_code",
            extraData: nil
        );
        Rollbar.recordErrorEvent(
            for: .debug,
            message: "test"
        );
        Rollbar.recordErrorEvent(
            for: .error,
            exception: NSException(name: NSExceptionName(rawValue: "name"), reason: "reason", userInfo: nil)
        );
        Rollbar.recordManualEvent(
            for: .debug,
            withData: ["data" : "content"]
        );

        //RollbarTestUtil.waitForPesistenceToComplete();
        
        Rollbar.debug("Test");

        RollbarTestUtil.waitForPesistenceToComplete();

        let logItem = RollbarTestUtil.readFirstItemStringsFromLogFile()!;
        let payload = RollbarPayload(jsonString: logItem);
        let telemetryEvents = payload.data.body.telemetry!;
        XCTAssertTrue(telemetryEvents.count > 0);

        for event in telemetryEvents {
            switch event.type {
            case .error:
                let body = event.body as! RollbarTelemetryErrorBody;
                switch event.level {
                case .error:
                    XCTAssertTrue(body.message.compare("reason") == .orderedSame);
                    let exceptionClass = body.getDataByKey("class") as! String;
                    XCTAssertTrue(exceptionClass.compare("NSException") == .orderedSame);
                    let description = body.getDataByKey("description") as! String;
                    XCTAssertTrue(description.compare("reason") == .orderedSame);
                case .debug:
                    XCTAssertTrue(body.message.compare("test") == .orderedSame);
                default:
                    XCTFail();
                }
            case .navigation:
                let body = event.body as! RollbarTelemetryNavigationBody;
                XCTAssertEqual(body.from, "from");
                XCTAssertEqual(body.to, "to");
            case .network:
                let body = event.body as! RollbarTelemetryNetworkBody;
                XCTAssertEqual(body.method, .delete);
                XCTAssertEqual(body.statusCode, "status_code");
                XCTAssertEqual(body.url, "url");
            case .connectivity:
                let body = event.body as! RollbarTelemetryConnectivityBody;
                XCTAssertEqual(body.status, "connactivity_status");
            case .manual:
                let body = event.body as! RollbarTelemetryManualBody;
                let data = body.getDataByKey("data") as! String;
                XCTAssertTrue(data.compare("content") == .orderedSame);
            //case .log:
            //case .view:
            //@unknown default:
            default:
                break;
            }
        }
    }
    
    func testErrorReportingWithTelemetry() {
        
        RollbarTestUtil.clearLogFile();
        RollbarTestUtil.clearTelemetryFile();

        Rollbar.currentConfiguration().telemetryEnabled = true;

        Rollbar.recordNavigationEvent(
            for: .info,
            from: "SomeNavigationSource",
            to: "SomeNavigationDestination"
        );
        Rollbar.recordConnectivityEvent(
            for: .info,
            status: "SomeConnectivityStatus"
        );
        Rollbar.recordNetworkEvent(
            for: .info,
            method: "POST",
            url: "www.myservice.com",
            statusCode: "200",
            extraData: nil
        );
        Rollbar.recordErrorEvent(
            for: .debug,
            message: "Some telemetry message..."
        );
        Rollbar.recordErrorEvent(
            for: .error,
            exception: NSException(
                name: NSExceptionName(rawValue: "someExceptionName"),
                reason: "someExceptionReason",
                userInfo: nil
            )
        );
        Rollbar.recordManualEvent(
            for: .debug,
            withData: ["myTelemetryParameter": "itsValue"]
        );

        //RollbarTestUtil.waitForPesistenceToComplete();

        Rollbar.debug("Demonstrate Telemetry capture");
        Rollbar.debug("Demonstrate Telemetry capture once more...");
        Rollbar.debug("DO Demonstrate Telemetry capture once more...");

        RollbarTestUtil.waitForPesistenceToComplete();
        
        let logItems = RollbarTestUtil.readItemStringsFromLogFile();
        for item in logItems {
            let payload = RollbarPayload(jsonString: item);
            let telemetryEvents = payload.data.body.telemetry;
            for event in telemetryEvents! {
                switch event.type {
                case .error:
                    let body = event.body as! RollbarTelemetryErrorBody;
                    switch event.level {
                    case .error:
                        XCTAssertTrue(body.message.compare("someExceptionReason") == .orderedSame);
                        let exceptionClass = body.getDataByKey("class") as! String;
                        XCTAssertTrue(exceptionClass.compare("NSException") == .orderedSame);
                        let description = body.getDataByKey("description") as! String;
                        XCTAssertTrue(description.compare("someExceptionReason") == .orderedSame);
                    case .debug:
                        XCTAssertTrue(body.message.compare("Some telemetry message...") == .orderedSame);
                    default:
                        XCTFail();
                    }
                case .navigation:
                    let body = event.body as! RollbarTelemetryNavigationBody;
                    XCTAssertEqual(body.from, "SomeNavigationSource");
                    XCTAssertEqual(body.to, "SomeNavigationDestination");
                case .connectivity:
                    let body = event.body as! RollbarTelemetryConnectivityBody;
                    XCTAssertEqual(body.status, "SomeConnectivityStatus");
                case .network:
                    let body = event.body as! RollbarTelemetryNetworkBody;
                    XCTAssertEqual(body.method, .post);
                    XCTAssertEqual(body.statusCode, "200");
                    XCTAssertEqual(body.url, "www.myservice.com");
                case .manual:
                    let body = event.body as! RollbarTelemetryManualBody;
                    let data = body.getDataByKey("myTelemetryParameter") as! String;
                    XCTAssertTrue(data.compare("itsValue") == .orderedSame);
                default:
                    break;
                }
            }

        }
    }

    func testTelemetryViewEventScrubbing() {
        
        Rollbar.currentConfiguration().telemetryEnabled = true;
        Rollbar.currentConfiguration().scrubViewInputsTelemetry = true;
        Rollbar.currentConfiguration().addTelemetryViewInput(toScrub: "password");
        Rollbar.currentConfiguration().addTelemetryViewInput(toScrub: "pin");
        
        Rollbar.recordViewEvent(
            for: .debug,
            element: "password",
            extraData: ["content": "My Password"]
        );
        Rollbar.recordViewEvent(
            for: .debug,
            element: "not-password",
            extraData: ["content": "My Password"]
        );

        let telemetryEvents = RollbarTelemetry.sharedInstance().getAllEvents();

        XCTAssertTrue("password".compare(telemetryEvents[0].value(forKeyPath: "body.element") as! String) == .orderedSame);
        XCTAssertTrue("[scrubbed]".compare(telemetryEvents[0].body.getDataByKey("content") as! String) == .orderedSame);

        XCTAssertTrue("not-password".compare(telemetryEvents[1].value(forKeyPath: "body.element") as! String) == .orderedSame);
        XCTAssertTrue("My Password".compare(telemetryEvents[1].body.getDataByKey("content") as! String) == .orderedSame);
    }
    
    //NOTE: enable the test below after telemetry of os_log is added!!!
//    @available(OSX 10.14, *)
//    func testOsLogAsTelemetry() {
//        Rollbar.currentConfiguration().telemetryEnabled = true;
//        Rollbar.currentConfiguration().captureLogAsTelemetryEvents = true;
//
//        os_log("Variadic function is unavailable", log: OSLog(subsystem: "UnitTest", category: .pointsOfInterest), type: .default);
//        let telemetryEvents = RollbarTelemetry.sharedInstance().getAllData();
//        XCTAssertEqual(telemetryEvents!.count, 1);
//    }

//    @available(OSX 10.14, *)
    static var allTests = [
        ("testTelemetryCapture", testTelemetryCapture),
        ("testErrorReportingWithTelemetry", testErrorReportingWithTelemetry),
        ("testTelemetryViewEventScrubbing", testTelemetryViewEventScrubbing),
//        ("testOsLogAsTelemetry", testOsLogAsTelemetry),
    ]
}
