//
//  DeploymentDetails.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef DeploymentDetails_h
//#define DeploymentDetails_h

#import <Foundation/Foundation.h>

#import "Deployment.h"

@interface DeploymentDetails : Deployment
@property (readonly, retain) NSString *deployId;
@property (readonly, retain) NSString *projectId;
@property (readonly, retain) NSDate *startTime;
@property (readonly, retain) NSDate *endTime;
@end

//#endif /* DeploymentDetails_h */
