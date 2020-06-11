import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(RollbarCommonTests.allTests),
        testCase(RollbarTriStateFlagTests.allTests),
        testCase(NSJSONSerializationRollbarTests.allTests),
    ]
}
#endif
