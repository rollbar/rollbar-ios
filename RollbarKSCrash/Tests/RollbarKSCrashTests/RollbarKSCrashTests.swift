import XCTest
@testable import RollbarKSCrash

final class RollbarKSCrashTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(RollbarKSCrash().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
