//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "Deployment.h"
#import "DeploymentDetails.h"
#import "DeployApiCallResult.h"

// Deploys Service Response Observer Protocols:

@protocol DeploymentRegistrationObserver
@required
- (void)onRegisterDeploymentCompleted:(DeployApiCallResult *)result;
@end

@protocol DeploymentDetailsObserver
@required
- (void)onGetDeploymentDetailsCompleted:(DeploymentDetailsResult *)result;
@end

@protocol DeploymentDetailsPageObserver
@required
- (void)onGetDeploymentDetailsPageCompleted:(DeploymentDetailsPageResult *)result;
@end

// Deploys Service Requests Protocol:

@protocol RollbarDeploysProtocol
@required
- (void) registerDeployment:(Deployment *)deployment;
- (void) getDeploymentWithDeployId:(NSString *)deployId;
- (void) getDeploymentsPageNumber:(NSUInteger)pageNumber;
@optional
@end
