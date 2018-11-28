//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "Deployment.h"

@interface DeploymentDetails : Deployment
@property (readonly, copy) NSString *deployId;
@property (readonly, copy) NSString *projectId;
@property (readonly, copy) NSDate *startTime;
@property (readonly, copy) NSDate *endTime;
@property (readonly, copy) NSString *status;
@end
