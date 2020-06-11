//
//  File.swift
//  
//
//  Created by Andrey Kornich on 2020-05-22.
//

import Foundation
import RollbarDeploys

internal class RollbarDeploysObserver
    : NSObject
    , RollbarDeploymentRegistrationObserver
    , RollbarDeploymentDetailsObserver
    , RollbarDeploymentDetailsPageObserver {
    
    func onRegisterDeploymentCompleted(_ result: RollbarDeploymentRegistrationResult) {
        
        print("result: \(result)");
        print("result.description: \(result.description ?? "")");
        print("result.outcome: \(result.outcome)", result.outcome);
        print("result.deploymentId: \(result.deploymentId)");

    }
    
    func onGetDeploymentDetailsCompleted(_ result: RollbarDeploymentDetailsResult) {
        
        print("result: \(result)");
        print("result.description: \(result.description ?? "")");
        print("result.outcome: \(result.outcome)");
        print("result.deployment.deployId: \(result.deployment?.deployId ?? "")");
        print("result.deployment.projectId: \(result.deployment?.projectId ?? "")");
        print("result.deployment.revision: \(result.deployment?.revision ?? "")");
        print("result.deployment.startTime: \(String(describing: result.deployment?.startTime ?? nil))");
        print("result.deployment.endTime: \(String(describing: result.deployment?.endTime ?? nil))");
    }
    
    func onGetDeploymentDetailsPageCompleted(_ result: RollbarDeploymentDetailsPageResult) {
        
        print("result: \(result)");
        print("result.description: \(result.description ?? "")");
        print("result.outcome: \(result.outcome)");
        print("result.pageNumber: \(result.pageNumber)");
        print("result.deployments.count: \(String(describing: result.deployments?.count ?? nil))");
        if (result.deployments?.count ?? 0 > 0) {
            print("result.deployments[0].description: \(result.deployments?[0].description ?? "")");

            print("result.deployments[0].deployId: \(result.deployments?[0].deployId ?? "")");
            print("result.deployments[0].projectId: \(result.deployments?[0].projectId ?? "")");
            print("result.deployments[0].revision: \(result.deployments?[0].revision ?? "")");
            print("result.deployments[0].startTime: \(String(describing: result.deployments?[0].startTime ?? nil))");
            print("result.deployments[0].endTime: \(String(describing: result.deployments?[0].endTime ?? nil))");
        }
    }        
}
