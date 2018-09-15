//
//  ApiCallResult.m
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ApiCallResult.h"

@implementation ApiCallResult
@synthesize outcome;
@synthesize outcomeDescription;
@end

@implementation DeploymentDetailsResult
@synthesize deployment;
@end

@implementation DeploymentDetailsPageResult
@synthesize deployments;
@end

