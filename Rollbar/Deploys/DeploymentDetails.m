//
//  DeploymentDetails.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"

@interface DeploymentDetails()
// redeclare the properties as read-write:
@property (readwrite, retain) NSString *deployId;
@property (readwrite, retain) NSString *projectId;
@property (readwrite, retain) NSDate *startTime;
@property (readwrite, retain) NSDate *endTime;
@end

@implementation DeploymentDetails
@synthesize deployId;
@synthesize projectId;
@synthesize startTime;
@synthesize endTime;
@end
