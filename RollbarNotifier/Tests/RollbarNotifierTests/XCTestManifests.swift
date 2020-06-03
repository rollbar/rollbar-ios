import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RollbarNotifierDTOsTests.allTests),
        testCase(RollbarNotifierTelemetryTests.allTests),
    ]
}
#endif
