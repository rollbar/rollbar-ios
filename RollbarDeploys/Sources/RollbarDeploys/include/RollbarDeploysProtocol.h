//  Copyright © 2018 Rollbar. All rights reserved.

@import Foundation;

@class RollbarDeployment;
@class RollbarDeploymentDetails;
@class RollbarDeployApiCallResult;
@class RollbarDeploymentRegistrationResult;
@class RollbarDeploymentDetailsResult;
@class RollbarDeploymentDetailsPageResult;

#pragma mark - Deploys API Service Response Observer Protocols

/// Deployment reqistration observer protocol
@protocol RollbarDeploymentRegistrationObserver
@required
/// Deployment reqistration observer's callback method
/// @param result deployment registration result object
- (void)onRegisterDeploymentCompleted:(nonnull RollbarDeploymentRegistrationResult *)result;
@end



/// Deployment details observer protocol
@protocol RollbarDeploymentDetailsObserver
@required
/// Deployment details observer's callback method
/// @param result result obect
- (void)onGetDeploymentDetailsCompleted:(nonnull RollbarDeploymentDetailsResult *)result;
@end



/// Deployment details page observer protocol
@protocol RollbarDeploymentDetailsPageObserver
@required
/// Deployment details page observer's callback method
/// @param result result object
- (void)onGetDeploymentDetailsPageCompleted:(nonnull RollbarDeploymentDetailsPageResult *)result;
@end

#pragma mark - Deploys API Service Requests Protocol

/// Rollbar Deploys API protocol
@protocol RollbarDeploysProtocol

@required

/// Register deployment API call
/// @param deployment deployment registration result
- (void) registerDeployment:(nonnull RollbarDeployment *)deployment;

/// Individual deployment details API call
/// @param deployId deployment ID
- (void) getDeploymentWithDeployId:(nonnull NSString *)deployId;

/// Deployment details page request API call
/// @param pageNumber requested page number
- (void) getDeploymentsPageNumber:(NSUInteger)pageNumber;

@optional
@end
