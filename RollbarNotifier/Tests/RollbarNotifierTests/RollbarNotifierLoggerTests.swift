#if !os(watchOS)
import XCTest
import Foundation
import os.log
@testable import RollbarNotifier

final class RollbarNotifierLoggerTests: XCTestCase {
    
    override class func setUp() {
        
        super.setUp();
        
        RollbarTestUtil.clearLogFile();
        RollbarTestUtil.clearTelemetryFile();
        RollbarTestUtil.waitForPesistenceToComplete();
        
        
        //if Rollbar.currentConfiguration() != nil {
        Rollbar.initWithAccessToken("2ffc7997ed864dda94f63e7b7daae0f3");
        Rollbar.currentConfiguration()?.destination.accessToken = "2ffc7997ed864dda94f63e7b7daae0f3";
        Rollbar.currentConfiguration()?.destination.environment = "unit-tests";
        Rollbar.currentConfiguration()?.developerOptions.transmit = true;
        Rollbar.currentConfiguration()?.developerOptions.logPayload = true;
        Rollbar.currentConfiguration()?.loggingOptions.maximumReportsPerMinute = 5000;
        Rollbar.currentConfiguration()?.customData = ["someKey": "someValue", ];
        //}
    }
    
    override func tearDown() {
        
        RollbarTestUtil.waitForPesistenceToComplete(waitTimeInSeconds: 2.0);

        Rollbar.updateConfiguration(RollbarConfig());
        super.tearDown();
    }
    
    func testRollbarConfiguration() {
        NSLog("%@", Rollbar.currentConfiguration()!);
    }

    func testRollbarNotifiersIndependentConfiguration() {

        //RollbarTestUtil.clearLogFile();
        //RollbarTestUtil.clearTelemetryFile();

        Rollbar.currentConfiguration()?.developerOptions.transmit = false;
        Rollbar.currentConfiguration()?.developerOptions.logPayload = true;

        // configure the root notifier:
        Rollbar.currentConfiguration()?.destination.accessToken = "AT_0";
        Rollbar.currentConfiguration()?.destination.environment = "ENV_0";
        
        XCTAssertEqual(Rollbar.currentLogger().configuration!.destination.accessToken,
                       Rollbar.currentConfiguration()!.destination.accessToken);
        XCTAssertEqual(Rollbar.currentLogger().configuration!.destination.environment,
                       Rollbar.currentConfiguration()?.destination.environment);
        
        XCTAssertEqual(Rollbar.currentLogger().configuration!.destination.accessToken,
                       Rollbar.currentConfiguration()?.destination.accessToken);
        XCTAssertEqual(Rollbar.currentLogger().configuration?.destination.environment,
                       Rollbar.currentConfiguration()?.destination.environment);
        
        // create and configure another notifier:
        let notifier = RollbarLogger(accessToken: "AT_1");
        notifier.configuration!.destination.environment = "ENV_1";
        XCTAssertTrue(notifier.configuration!.destination.accessToken.compare("AT_1") == .orderedSame);
        XCTAssertTrue(notifier.configuration!.destination.environment.compare("ENV_1") == .orderedSame);

        // reconfigure the root notifier:
        Rollbar.currentConfiguration()?.destination.accessToken = "AT_N";
        Rollbar.currentConfiguration()?.destination.environment = "ENV_N";
        XCTAssertTrue(Rollbar.currentLogger().configuration!.destination.accessToken.compare("AT_N") == .orderedSame);
        XCTAssertTrue(Rollbar.currentLogger().configuration!.destination.environment.compare("ENV_N") == .orderedSame);

        // make sure the other notifier is still has its original configuration:
        XCTAssertTrue(notifier.configuration!.destination.accessToken.compare("AT_1") == .orderedSame);
        XCTAssertTrue(notifier.configuration!.destination.environment.compare("ENV_1") == .orderedSame);

        //TODO: to make this test even more valuable we need to make sure the other notifier's payloads
        //      are actually sent to its intended destination. But that is something we will be able to do
        //      once we add to this SDK a feature similar to Rollbar.NET's Internal Events...
    }

    func testRollbarTransmit() {

        //RollbarTestUtil.clearLogFile();
        //RollbarTestUtil.clearTelemetryFile();

        Rollbar.currentConfiguration()?.destination.accessToken = "2ffc7997ed864dda94f63e7b7daae0f3";
        Rollbar.currentConfiguration()?.destination.environment = "unit-tests";
        Rollbar.currentConfiguration()?.developerOptions.transmit = true;

        Rollbar.currentConfiguration()?.developerOptions.transmit = true;
        Rollbar.criticalMessage("Transmission test YES");
        RollbarTestUtil.waitForPesistenceToComplete();

        Rollbar.currentConfiguration()?.developerOptions.transmit = false;
        Rollbar.criticalMessage("Transmission test NO");
        RollbarTestUtil.waitForPesistenceToComplete();

        Rollbar.currentConfiguration()?.developerOptions.transmit = true;
        //Rollbar.currentConfiguration.enabled = NO;
        Rollbar.criticalMessage("Transmission test YES2");
        RollbarTestUtil.waitForPesistenceToComplete();

        var count = 50;
        while (count > 0) {
            Rollbar.criticalMessage("Rate Limit Test \(count)");
            RollbarTestUtil.waitForPesistenceToComplete();
            count -= 1;
        }
    }
    
    func testNotification() {

//        RollbarTestUtil.clearLogFile();
//        RollbarTestUtil.clearTelemetryFile();

        let notificationText = [
            "error": ["testing-error"],
            "debug": ["testing-debug"],
            "warning": ["testing-warning"],
            "info": ["testing-info"],
            "critical": ["testing-critical"]
        ];
        
        for type in notificationText.keys {
            let params = notificationText[type]!;
            if (type.compare("error") == .orderedSame) {
                Rollbar.errorMessage(params[0] as String);
            } else if (type.compare("warning") == .orderedSame) {
                Rollbar.warningMessage(params[0] as String);
            } else if (type.compare("debug") == .orderedSame) {
                Rollbar.debugMessage(params[0] as String);
            } else if (type.compare("info") == .orderedSame) {
                Rollbar.infoMessage(params[0] as String);
            } else if (type.compare("critical") == .orderedSame) {
                Rollbar.criticalMessage(params[0] as String);
            }
        }

        RollbarTestUtil.waitForPesistenceToComplete();

        let items = RollbarTestUtil.readItemStringsFromLogFile();
        for item in items {
            let payload = RollbarPayload(jsonString: item);
            let level = payload.data.level;
            let message: String? = payload.data.body.message?.body;
            let params = notificationText[RollbarLevelUtil.rollbarLevel(toString: level)]!;
            XCTAssertTrue(message!.compare(params[0] as String) == .orderedSame, "Expects '\(params[0])', got '\(message ?? "")'.");
        }
    }
    
    func testNSErrorReporting() {
        do {
            try RollbarTestUtil.makeTroubledCall();
            //var expectedErrorCallDepth: uint = 5;
            //try RollbarTestUtil.simulateError(callDepth: &expectedErrorCallDepth);
        }
        catch RollbarTestUtilError.simulatedException(let errorDescription, let errorCallStack) {
            print("Caught an error: \(errorDescription)");
            print("Caught error's call stack:");
            errorCallStack.forEach({print($0)});
        }
        catch let e as BackTracedErrorProtocol {
            //print("Caught an error: \(e.localizedDescription)");
            print("Caught an error: \(e.errorDescription)");
            print("Caught error's call stack:");
            e.errorCallStack.forEach({print($0)});
        }
        catch {
            print("Caught an error: \(error)");
            //print("Caught an error: \(error.localizedDescription)");
            //print("Corresponding call stack trace at the catch point:");
            Thread.callStackSymbols.forEach{print($0)}
        }
    }
    
    static var allTests = [
        ("testRollbarConfiguration", testRollbarConfiguration),
        ("testRollbarNotifiersIndependentConfiguration", testRollbarNotifiersIndependentConfiguration),
        ("testRollbarTransmit", testRollbarTransmit),
        ("testNotification", testNotification),
        ("testNSErrorReporting", testNSErrorReporting),
    ]
}
#endif
