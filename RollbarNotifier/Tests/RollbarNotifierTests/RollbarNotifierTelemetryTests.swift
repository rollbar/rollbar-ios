import XCTest
import Foundation
@testable import RollbarNotifier

final class RollbarNotifierTelemetryTests: XCTestCase {
    
    override class func setUp() {
        super.setUp();
        RollbarTestUtil.clearLogFile();
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
    
    func doNothing() {}
    
    func testTelemetryCapture() {
        
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
        Rollbar.debug("Test");

        //RollbarTestUtil.flushFileThread(logger: Rollbar.currentLogger());
        usleep(1000);
        
        let logItem = RollbarTestUtil.readFirstItemStringsFromLogFile()!;
        let payload = RollbarPayload(jsonString: logItem);
        let telemetryEvents = payload.data.body.telemetry!;
        XCTAssertTrue(telemetryEvents.count > 0);

        for event in telemetryEvents {
            switch event.type {
            case .error:
                let body = event.body as! RollbarTelemetryErrorBody;
                if event.level == .debug {
                    XCTAssertTrue(body.message.compare("test") == .orderedSame);
                }
                else {
                    XCTAssertTrue(body.message.compare("reason") == .orderedSame);
                    let exceptionClass = body.getDataByKey("class") as! String;
                    XCTAssertTrue(exceptionClass.compare("NSException") == .orderedSame);
                    let description = body.getDataByKey("description") as! String;
                    XCTAssertTrue(description.compare("reason") == .orderedSame);
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
            default: break
            }
        }
    }
    
//    func testExample() {
//        // This is an example of a functional test case.
//        // Use XCTAssert and related functions to verify your tests produce the correct
//        // results.
//        XCTAssertEqual(RollbarNotifier().text, "Hello, World!")
//    }

    static var allTests = [
        //("testExample", testExample),
        //("doNothing", doNothing),
        ("testTelemetryCapture", testTelemetryCapture),
    ]
}
