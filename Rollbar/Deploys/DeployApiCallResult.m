//
//  ApiCallResult.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeployApiCallResult.h"

// DeployApiCallResult
//////////////////////

//@interface DeployApiCallResult()
//// redeclare the properties as read-write:
//@property (readwrite) DeployApiCallOutcome outcome;
//@property (readwrite, retain) NSString *description;
//@end

@implementation DeployApiCallResult
//@synthesize outcome;
//@synthesize description;
static NSString * const PROPERTY_outcome = @"outcome";
static NSString * const PROPERTY_description = @"description";

- (DeployApiCallOutcome)outcome {
    return [[self.dataDictionary objectForKey:PROPERTY_outcome] intValue];
}
- (NSString *)description {
    return (NSString *) [self.dataDictionary objectForKey:PROPERTY_description];
}
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description {
    self = [super init];
    if (nil != self) {
        [self.dataDictionary setObject:[NSNumber numberWithInt:outcome]
                                forKey:PROPERTY_outcome];
        [self.dataDictionary setObject:description
                                forKey:PROPERTY_description];
    }
    return self;
}
//- (id)init {
//    static NSString * const defaultDescription = @"Default response";
//    return [self initWithOutcome:Outcome_Error
//                     description:defaultDescription];
//}
//- (id)initWithJSONData:(NSData *)jsonData {
//
//}
@end

// DeploymentDetailsResult
//////////////////////////

//@interface DeploymentDetailsResult()
//// redeclare the properties as read-write:
//@property (readwrite, retain) DeploymentDetails *deployment;
//@end

@implementation DeploymentDetailsResult
//@synthesize deployment;
static NSString * const PROPERTY_deplyment = @"deployment";

- (DeploymentDetails *)deployment {
    return (DeploymentDetails *) [self.dataDictionary objectForKey:PROPERTY_deplyment];
}
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description
           deployment:(DeploymentDetails *)deployment {
    self = [super initWithOutcome:outcome
                      description:description];
    if (nil != self) {
        [self.dataDictionary setObject:deployment forKey:PROPERTY_deplyment];
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

//@interface DeploymentDetailsPageResult()
//@property (readwrite, retain) NSSet<DeploymentDetails *> *deployments;
//@end

@implementation DeploymentDetailsPageResult
//@synthesize deployments;
static NSString * const PROPERTY_deplyments = @"deployments";

- (NSSet<DeploymentDetails *> *)deployments {
    return (NSSet<DeploymentDetails *> *) [self.dataDictionary objectForKey:PROPERTY_deplyments];
}
// Designated Initializer:
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description
          deployments:(NSSet<DeploymentDetails *> *)deployments {
    self = [super initWithOutcome:outcome
                      description:description];
    if (nil != self) {
        [self.dataDictionary setObject:deployments forKey:PROPERTY_deplyments];
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

