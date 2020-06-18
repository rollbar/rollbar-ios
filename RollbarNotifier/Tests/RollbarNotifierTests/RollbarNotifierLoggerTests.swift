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
            Rollbar.currentConfiguration().accessToken = "2ffc7997ed864dda94f63e7b7daae0f3";
            Rollbar.currentConfiguration().environment = "unit-tests";
            Rollbar.currentConfiguration().transmit = true;
            Rollbar.currentConfiguration().logPayload = true;
            Rollbar.currentConfiguration().maximumReportsPerMinute = 5000;
            Rollbar.currentConfiguration()?.asRollbarConfig()?.customData = ["someKey": "someValue", ];
        //}
    }
    
    override func tearDown() {
        
        RollbarTestUtil.waitForPesistenceToComplete(waitTimeInSeconds: 2.0);

        Rollbar.update(RollbarConfiguration(), isRoot: true);
        super.tearDown();
    }
    
    func testRollbarConfiguration() {
        NSLog("%@", Rollbar.currentConfiguration());
    }

    func testRollbarNotifiersIndependentConfiguration() {

        //RollbarTestUtil.clearLogFile();
        //RollbarTestUtil.clearTelemetryFile();

        Rollbar.currentConfiguration().transmit = false;
        Rollbar.currentConfiguration().logPayload = true;

        // configure the root notifier:
        Rollbar.currentConfiguration().accessToken = "AT_0";
        Rollbar.currentConfiguration().environment = "ENV_0";
        
        XCTAssertEqual(Rollbar.currentLogger().configuration.accessToken,
                       Rollbar.currentConfiguration().accessToken);
        XCTAssertEqual(Rollbar.currentLogger().configuration.environment,
                       Rollbar.currentConfiguration().environment);
        
        XCTAssertEqual(Rollbar.currentLogger().configuration.asRollbarConfig().destination.accessToken,
                       Rollbar.currentConfiguration().accessToken);
        XCTAssertEqual(Rollbar.currentLogger().configuration.asRollbarConfig().destination.environment,
                       Rollbar.currentConfiguration().environment);
        
        // create and configure another notifier:
        let notifier = RollbarLogger(accessToken: "AT_1", configuration: nil, isRoot: false)!;
        notifier.configuration.environment = "ENV_1";
        XCTAssertTrue(notifier.configuration.asRollbarConfig().destination.accessToken.compare("AT_1") == .orderedSame);
        XCTAssertTrue(notifier.configuration.asRollbarConfig().destination.environment.compare("ENV_1") == .orderedSame);

        // reconfigure the root notifier:
        Rollbar.currentConfiguration().accessToken = "AT_N";
        Rollbar.currentConfiguration().environment = "ENV_N";
        XCTAssertTrue(Rollbar.currentLogger().configuration.asRollbarConfig().destination.accessToken.compare("AT_N") == .orderedSame);
        XCTAssertTrue(Rollbar.currentLogger().configuration.asRollbarConfig().destination.environment.compare("ENV_N") == .orderedSame);

        // make sure the other notifier is still has its original configuration:
        XCTAssertTrue(notifier.configuration.asRollbarConfig().destination.accessToken.compare("AT_1") == .orderedSame);
        XCTAssertTrue(notifier.configuration.asRollbarConfig().destination.environment.compare("ENV_1") == .orderedSame);

        //TODO: to make this test even more valuable we need to make sure the other notifier's payloads
        //      are actually sent to its intended destination. But that is something we will be able to do
        //      once we add to this SDK a feature similar to Rollbar.NET's Internal Events...
    }

    func testRollbarTransmit() {

        //RollbarTestUtil.clearLogFile();
        //RollbarTestUtil.clearTelemetryFile();

        Rollbar.currentConfiguration().accessToken = "2ffc7997ed864dda94f63e7b7daae0f3";
        Rollbar.currentConfiguration().environment = "unit-tests";
        Rollbar.currentConfiguration().transmit = true;

        Rollbar.currentConfiguration().transmit = true;
        Rollbar.critical("Transmission test YES");
        RollbarTestUtil.waitForPesistenceToComplete();

        Rollbar.currentConfiguration().transmit = false;
        Rollbar.critical("Transmission test NO");
        RollbarTestUtil.waitForPesistenceToComplete();

        Rollbar.currentConfiguration().transmit = true;
        //Rollbar.currentConfiguration.enabled = NO;
        Rollbar.critical("Transmission test YES2");
        RollbarTestUtil.waitForPesistenceToComplete();

        var count = 50;
        while (count > 0) {
            Rollbar.critical("Rate Limit Test \(count)");
            RollbarTestUtil.waitForPesistenceToComplete();
            count -= 1;
        }
    }
    
    func testNotification() {

//        RollbarTestUtil.clearLogFile();
//        RollbarTestUtil.clearTelemetryFile();

        let notificationText = [
            "error": ["testing-error-with-message", NSException(name: NSExceptionName("testing-error"), reason: "testing-error-2", userInfo: nil)],
            "debug": ["testing-debug"],
            "warning": ["testing-warning"],
            "info": ["testing-info"],
            "critical": ["testing-critical"]
        ];
        
        for type in notificationText.keys {
            let params = notificationText[type]!;
            if (type.compare("error") == .orderedSame) {
                Rollbar.error(params[0] as? String, exception: params[1] as? NSException);
            } else if (type.compare("warning") == .orderedSame) {
                Rollbar.warning(params[0] as? String);
            } else if (type.compare("debug") == .orderedSame) {
                Rollbar.debug(params[0] as? String);
            } else if (type.compare("info") == .orderedSame) {
                Rollbar.info(params[0] as? String);
            } else if (type.compare("critical") == .orderedSame) {
                Rollbar.critical(params[0] as? String);
            }
        }

        RollbarTestUtil.waitForPesistenceToComplete();

        let items = RollbarTestUtil.readItemStringsFromLogFile();
        for item in items {
            let payload = RollbarPayload(jsonString: item);
            let level = payload.data.level;
            let message: String? = payload.data.body.message?.body;
            let params = notificationText[RollbarLevelUtil.rollbarLevel(toString: level)]!;
            switch level {
            case .debug:
                XCTAssertTrue(message!.compare(params[0] as! String) == .orderedSame, "Expects '\(params[0])', got '\(message ?? "")'.");
            case .error:
                let exception = params[1] as! NSException;
                XCTAssertNotNil(exception);
            case .info:
                XCTAssertTrue(message!.compare(params[0] as! String) == .orderedSame, "Expects '\(params[0])', got '\(message ?? "")'.");
            case .critical:
                XCTAssertTrue(message!.compare(params[0] as! String) == .orderedSame, "Expects '\(params[0])', got '\(message ?? "")'.");
            case .warning:
                XCTAssertTrue(message!.compare(params[0] as! String) == .orderedSame, "Expects '\(params[0])', got '\(message ?? "")'.");
            @unknown default:
                break;
            }
        }
    }
    
    static var allTests = [
        ("testRollbarConfiguration", testRollbarConfiguration),
        ("testRollbarNotifiersIndependentConfiguration", testRollbarNotifiersIndependentConfiguration),
        ("testRollbarTransmit", testRollbarTransmit),
        ("testNotification", testNotification),
    ]
}
