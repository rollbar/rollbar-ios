//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"
#import "DataTransferObject.h"
#import "DeployApiCallOutcome.h"

@interface DeployApiCallResult : DataTransferObject
@property (readonly) DeployApiCallOutcome outcome;
@property (readonly, copy) NSString *description;

- (instancetype)initWithResponse:(NSHTTPURLResponse*)httpResponse
                            data:(NSData*)data
                           error:(NSError*)error
                      forRequest:(NSURLRequest*)request
NS_DESIGNATED_INITIALIZER;

@end

@interface DeploymentRegistrationResult : DeployApiCallResult
@property (readonly, copy) NSString *deploymentId;
@end

@interface DeploymentDetailsResult : DeployApiCallResult
@property (readonly, retain) DeploymentDetails *deployment;
@end

@interface DeploymentDetailsPageResult : DeployApiCallResult
@property (readonly, retain) NSArray<DeploymentDetails *> *deployments;
@property (readonly) NSUInteger pageNumber;
@end
