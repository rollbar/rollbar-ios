//
//  RollbarDeploysProtocol.h
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef RollbarDeploysProtocol_h
//#define RollbarDeploysProtocol_h

#import <Foundation/Foundation.h>

#import "Deployment.h"
#import "DeploymentDetails.h"
#import "ApiCallResult.h"

// Deploys Service Callback Protocols:

@protocol RegisterDeploymentDelegate
@required
- (void)registrationCompleted:(ApiCallResult *)result;
@end

@protocol GetDeploymentDetailsDelegate
@required
- (void)getDeploymentDetailsCompleted:(DeploymentDetailsResult *)result;
@end

@protocol GetDeploymentDetailsPageDelegate
@required
- (void)getDeploymentDetailsPageCompleted:(DeploymentDetailsPageResult *)result;
@end

// Deploys Service Requests Protocol:

@protocol RollbarDeploysProtocol
@required
- (void) registerDeployment:(Deployment *)deployment;
- (void) getDeploymentUsing:(NSString *)deployId;
- (void) getDeploymentsPageForEnvironment:(NSString *)environmentId
                          usingPageNumber:(NSUInteger)pageNumber;
@optional
@end

//#endif /* RollbarDeploysProtocol_h */
