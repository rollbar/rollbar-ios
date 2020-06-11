//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarDeployment.h"

@import Foundation;

/// Models Deployment details
@interface RollbarDeploymentDetails : RollbarDeployment

/// Deployment ID
@property (readonly, copy) NSString *deployId;

/// Rollbar project ID
@property (readonly, copy) NSString *projectId;

/// Start time
@property (readonly, copy) NSDate *startTime;

/// End time
@property (readonly, copy) NSDate *endTime;

/// Status
@property (readonly, copy) NSString *status;

@end
