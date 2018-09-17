//
//  ApiCallResult.m
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeployApiCallResult.h"

// DeployApiCallResult
//////////////////////

@interface DeployApiCallResult()
// redeclare the properties as read-write:
@property (readwrite) DeployApiCallOutcome outcome;
@property (readwrite, retain) NSString *description;
@end

@implementation DeployApiCallResult
@synthesize outcome;
@synthesize description;
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description {
    self = [super init];
    if (nil != self) {
        self.outcome = outcome;
        self.description = description;
    }
    return self;
}
- (id)init {
    static NSString * const defaultDescription = @"Default response";
    return [self initWithOutcome:Outcome_Error
                     description:defaultDescription];
}
@end

// DeploymentDetailsResult
//////////////////////////

@interface DeploymentDetailsResult()
// redeclare the properties as read-write:
@property (readwrite, retain) DeploymentDetails *deployment;
@end

@implementation DeploymentDetailsResult
@synthesize deployment;
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description
           deployment:(DeploymentDetails *)deployment {
    self = [super initWithOutcome:outcome
                      description:description];
    if (nil != self) {
        self.deployment = deployment;
    }
    return self;
}
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description {
    return [self initWithOutcome:outcome
                     description:description
                      deployment:nil];
}
@end

// DeploymentDetailsPageResult
//////////////////////////////

@interface DeploymentDetailsPageResult()
@property (readwrite, retain) NSSet *deployments;
@end

@implementation DeploymentDetailsPageResult
@synthesize deployments;
// Designated Initializer:
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description
          deployments:(NSSet *)deployments {
    self = [super initWithOutcome:outcome
                      description:description];
    if (nil != self) {
        self.deployments = deployments;
    }
    return self;
}
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description {
    return [self initWithOutcome:outcome
                     description:description
                      deployments:nil];
}
@end

