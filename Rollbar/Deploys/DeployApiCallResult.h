//
//  ApiCallResult.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"
#import "../RollbarJSONFriendlyObject.h"

typedef enum DeployApiCallOutcome {
    Outcome_Success,
    Outcome_Error,
} DeployApiCallOutcome;

@interface DeployApiCallResult : RollbarJSONFriendlyObject
@property (readonly) DeployApiCallOutcome outcome;
@property (readonly, copy) NSString *description;
// Designated Initializer:
- (id)initWithResponse:(NSHTTPURLResponse*)httpResponse
                  data:(NSData*)data
                 error:(NSError*)error
            forRequest:(NSURLRequest*)request;
@end

@interface DeploymentRegistrationResult : DeployApiCallResult
@property (readonly, copy) NSString *deploymentId;
@end

@interface DeploymentDetailsResult : DeployApiCallResult
@property (readonly, retain) DeploymentDetails *deployment;
@end

@interface DeploymentDetailsPageResult : DeployApiCallResult
@property (readonly, retain) NSSet<DeploymentDetails *> *deployments;
@property (readonly, copy) NSNumber *pageNumber;
@end
