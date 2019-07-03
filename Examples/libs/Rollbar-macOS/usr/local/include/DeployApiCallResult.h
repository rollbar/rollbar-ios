//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"
#import "RollbarJSONFriendlyObject.h"

typedef NS_ENUM(NSInteger, DeployApiCallOutcome) {
    DeployApiCallSuccess,
    DeployApiCallError,
};

@interface DeployApiCallResult : RollbarJSONFriendlyObject
@property (readonly) DeployApiCallOutcome outcome;
@property (readonly, copy) NSString *description;

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
