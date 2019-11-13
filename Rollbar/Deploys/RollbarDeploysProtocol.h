//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>
#import "Deployment.h"
#import "DeploymentDetails.h"
#import "DeployApiCallResult.h"

#pragma mark - Deploys Service Response Observer Protocols

/// Deployment reqistration observer protocol
@protocol DeploymentRegistrationObserver
@required
/// Deployment reqistration observer's callback method
/// @param result deployment registration result object
- (void)onRegisterDeploymentCompleted:(DeployApiCallResult *)result;
@end

/// Deployment details observer protocol
@protocol DeploymentDetailsObserver
@required
/// Deployment details observer's callback method
/// @param result result obect
- (void)onGetDeploymentDetailsCompleted:(DeploymentDetailsResult *)result;
@end

/// Deployment details page observer protocol
@protocol DeploymentDetailsPageObserver
@required
/// Deployment details page observer's callback method
/// @param result result object
- (void)onGetDeploymentDetailsPageCompleted:(DeploymentDetailsPageResult *)result;
@end

#pragma mark - Deploys Service Requests Protocol

/// Rollbar Deploys API protocol
@protocol RollbarDeploysProtocol

@required

/// Register deployment API call
/// @param deployment deployment registration result
- (void) registerDeployment:(Deployment *)deployment;

/// Individual deployment details API call
/// @param deployId deployment ID
- (void) getDeploymentWithDeployId:(NSString *)deployId;

/// Deployment details page request API call
/// @param pageNumber requested page number
- (void) getDeploymentsPageNumber:(NSUInteger)pageNumber;

@optional
@end
