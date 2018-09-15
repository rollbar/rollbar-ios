//
//  DeploymentDetails.h
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-14.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef DeploymentDetails_h
//#define DeploymentDetails_h

#import <Foundation/Foundation.h>

#import "Deployment.h"

@interface DeploymentDetails : Deployment

@property (readonly) NSString *deployId;
@property (readonly) NSString *projectId;
@property (readonly) NSDate *startTime;
@property (readonly) NSDate *endTime;

@end

//#endif /* DeploymentDetails_h */
