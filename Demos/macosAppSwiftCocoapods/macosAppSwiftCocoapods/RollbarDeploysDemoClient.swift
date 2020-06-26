//
//  RollbarDeploysDemoClient.swift
//  macosAppSwiftCocoapods
//
//  Created by Andrey Kornich on 2020-06-19.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

import Foundation
import RollbarDeploys

class RollbarDeploysObserver
    : RollbarDeploymentRegistrationObserver
    , RollbarDeploymentDetailsObserver
    , RollbarDeploymentDetailsPageObserver {
    
    func onRegisterDeploymentCompleted(_ result: RollbarDeploymentRegistrationResult) {
        print("result: \(result)");
        print("result.description: \(result.description ?? "")");
        print("result.outcome: \(result.outcome)");
        print("result.deploymentId: \(result.deploymentId)");
    }
    
    func onGetDeploymentDetailsCompleted(_ result: RollbarDeploymentDetailsResult) {
        print("result: \(result)");
        print("result.description: \(String(describing: result.description))");
        print("result.outcome: %li", result.outcome);
        print("result.deployment.deployId: \(String(describing: result.deployment?.deployId))");
        print("result.deployment.projectId: \(String(describing: result.deployment?.projectId))");
        print("result.deployment.revision: \(String(describing: result.deployment?.revision))");
        print("result.deployment.startTime: \(String(describing: result.deployment?.startTime))");
        print("result.deployment.endTime: \(String(describing: result.deployment?.endTime))");
    }
    
    func onGetDeploymentDetailsPageCompleted(_ result: RollbarDeploymentDetailsPageResult) {
        print("result: \(result)");
        print("result.description: \(String(describing: result.description))");
        print("result.outcome: \(result.outcome)");
        print("result.pageNumber: \(result.pageNumber)");
        print("result.deployments.count: \(result.deployments!.count)");
        if (result.deployments!.count > 0) {
            print("result.deployments[0].description: \(result.deployments![0].description)");
        }
    }
}

class RollbarDeploysDemoClient {

    func demoDeploymentRegistration() {

        let dateFormatter = DateFormatter();
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";

        let environment = "unit-tests123";
        let comment = "a new deploy at \(dateFormatter.string(from: Date()))";
        let revision = "a_revision";
        let localUsername = "UnitTestRunner";
        let rollbarUsername = "rollbar";

        let observer = RollbarDeploysObserver()
        let deployment = RollbarDeployment(
            environment: environment,
            comment: comment,
            revision: revision,
            localUserName: localUsername,
            rollbarUserName: rollbarUsername);
        let deploysManager = RollbarDeploysManager(
            writeAccessToken: "2d6e0add5d9b403d9126b4bcea7e0199",
            readAccessToken: "d1fd12f1bd7e4340a0a55378d41061f0",
            deploymentRegistrationObserver: (observer as! NSObjectProtocol & RollbarDeploymentRegistrationObserver),
            deploymentDetailsObserver: (observer as! NSObjectProtocol & RollbarDeploymentDetailsObserver),
            deploymentDetailsPageObserver: (observer as! NSObjectProtocol & RollbarDeploymentDetailsPageObserver));
        deploysManager!.register(deployment!)
    }

    func demoGetDeploymentDetailsById() {

        let testDeploymentId = "9961771";
        let observer = RollbarDeploysObserver();
        let deploysManager = RollbarDeploysManager(
            writeAccessToken: "0d7ef175a2e14bc9b48732af2b2652f9",
            readAccessToken: "d1fd12f1bd7e4340a0a55378d41061f0",
            deploymentRegistrationObserver: (observer as! NSObjectProtocol & RollbarDeploymentRegistrationObserver),
            deploymentDetailsObserver: (observer as! NSObjectProtocol & RollbarDeploymentDetailsObserver),
            deploymentDetailsPageObserver: (observer as! NSObjectProtocol & RollbarDeploymentDetailsPageObserver));
        deploysManager!.getDeploymentWithDeployId(testDeploymentId);
    }

    func demoGetDeploymentsPage() {

        let observer = RollbarDeploysObserver();
        let deploysManager = RollbarDeploysManager(
            writeAccessToken: "0d7ef175a2e14bc9b48732af2b2652f9",
            readAccessToken: "d1fd12f1bd7e4340a0a55378d41061f0",
            deploymentRegistrationObserver: (observer as! NSObjectProtocol & RollbarDeploymentRegistrationObserver),
            deploymentDetailsObserver: (observer as! NSObjectProtocol & RollbarDeploymentDetailsObserver),
            deploymentDetailsPageObserver: (observer as! NSObjectProtocol & RollbarDeploymentDetailsPageObserver));
        deploysManager!.getDeploymentsPageNumber(1);
    }
}


