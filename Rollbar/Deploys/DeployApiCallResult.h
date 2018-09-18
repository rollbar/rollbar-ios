//
//  ApiCallResult.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef ApiCallResult_h
//#define ApiCallResult_h

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"
#import "RollbarJSONFriendlyObject.h"

typedef enum DeployApiCallOutcome {
    Outcome_Success,
    Outcome_Error,
} DeployApiCallOutcome;

@interface DeployApiCallResult : RollbarJSONFriendlyObject
@property (readonly) DeployApiCallOutcome outcome;
@property (readonly, retain) NSString *description;
// Designated Initializer:
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description;
@end

@interface DeploymentDetailsResult : DeployApiCallResult
@property (readonly, retain) DeploymentDetails *deployment;
// Designated Initializer:
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description
           deployment:(DeploymentDetails *)deployment;
@end

@interface DeploymentDetailsPageResult : DeployApiCallResult
@property (readonly, retain) NSSet<DeploymentDetails *> *deployments;
// Designated Initializer:
- (id)initWithOutcome:(DeployApiCallOutcome)outcome
          description:(NSString *)description
          deployments:(NSSet<DeploymentDetails *> *)deployments;
@end

//#endif /* ApiCallResult_h */
