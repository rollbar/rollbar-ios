//
//  ApiCallResult.h
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef ApiCallResult_h
//#define ApiCallResult_h

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"

typedef enum DeployApiCallOutcome {
    Outcome_Success,
    Outcome_Error,
} DeployApiCallOutcome;


@interface ApiCallResult : NSObject
@property DeployApiCallOutcome outcome;
@property NSString *outcomeDescription;
@end

@interface DeploymentDetailsResult : ApiCallResult
@property DeploymentDetails *deployment;
@end

@interface DeploymentDetailsPageResult : ApiCallResult
@property NSSet  *deployments;
@end

//#endif /* ApiCallResult_h */
