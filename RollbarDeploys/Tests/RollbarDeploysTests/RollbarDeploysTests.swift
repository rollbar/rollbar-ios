import XCTest
import Foundation
@testable import RollbarDeploys

final class RollbarDeploysTests: XCTestCase {
    
    func testDeploymentDto() {
        
        let environment = "unit-tests"
        let comment = "a new deploy"
        let revision = "a_revision"
        let localUsername = "UnitTestRunner"
        let rollbarUsername = "rollbar"
        
        let deployment = RollbarDeployment(
            environment:environment,
            comment:comment,
            revision:revision,
            localUserName:localUsername,
            rollbarUserName:rollbarUsername
        )

        XCTAssertTrue(nil != deployment)

        XCTAssertTrue(nil != deployment?.environment)
        XCTAssertTrue(nil != deployment?.comment)
        XCTAssertTrue(nil != deployment?.revision)
        XCTAssertTrue(nil != deployment?.localUsername)
        XCTAssertTrue(nil != deployment?.rollbarUsername)
        
        XCTAssertTrue(environment == deployment?.environment)
        XCTAssertTrue(comment == deployment?.comment)
        XCTAssertTrue(revision == deployment?.revision)
        XCTAssertTrue(localUsername == deployment?.localUsername)
        XCTAssertTrue(rollbarUsername == deployment?.rollbarUsername)
    }
    
    func testDeploymentRegistration() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let environment = "unit-tests123"
        let comment = "a new deploy at \(dateFormatter.string(from:Date.init()))"
        let revision = "a_revision"
        let localUsername = "UnitTestRunner"
        let rollbarUsername = "rollbar"
        
        let observer = RollbarDeploysObserver()
        
        let deployment = RollbarDeployment(
            environment:environment,
            comment:comment,
            revision:revision,
            localUserName:localUsername,
            rollbarUserName:rollbarUsername
            )
        
        let deploysManager = RollbarDeploysManager(
            writeAccessToken:"2d6e0add5d9b403d9126b4bcea7e0199",
            readAccessToken:"d1fd12f1bd7e4340a0a55378d41061f0",
            deploymentRegistrationObserver:observer,
            deploymentDetailsObserver:observer,
            deploymentDetailsPageObserver:observer
        )
        
        deploysManager?.register(deployment!)

    }

    func testGetDeploymentDetailsById() {

        let testDeploymentId = "9961771";

        let observer = RollbarDeploysObserver()

        let deploysManager = RollbarDeploysManager(
            writeAccessToken:"2d6e0add5d9b403d9126b4bcea7e0199",
            readAccessToken:"d1fd12f1bd7e4340a0a55378d41061f0",
            deploymentRegistrationObserver:observer,
            deploymentDetailsObserver:observer,
            deploymentDetailsPageObserver:observer
        )

        deploysManager?.getDeploymentWithDeployId(testDeploymentId)
    }

    func testGetDeploymentsPage() {
        
        let observer = RollbarDeploysObserver()

        let deploysManager = RollbarDeploysManager(
            writeAccessToken:"2d6e0add5d9b403d9126b4bcea7e0199",
            readAccessToken:"d1fd12f1bd7e4340a0a55378d41061f0",
            deploymentRegistrationObserver:observer,
            deploymentDetailsObserver:observer,
            deploymentDetailsPageObserver:observer
        )

        deploysManager?.getDeploymentsPageNumber(1)
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        //XCTAssertEqual(RollbarDeploys().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
