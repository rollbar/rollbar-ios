//
//  RollbarDeployApiCallOutcome.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarDeployApiCallOutcome.h"

@implementation RollbarDeployApiCallOutcomeUtil

+ (NSString *) DeployApiCallOutcomeToString:(RollbarDeployApiCallOutcome)value; {
    switch (value) {
        case RollbarDeployApiCall_Success:
            return @"success";
        case RollbarDeployApiCall_Error:
            return @"error";
        default:
            return @"unknown";
    }
}

+ (RollbarDeployApiCallOutcome) DeployApiCallOutcomeFromString:(NSString *)value {
    
    if (NSOrderedSame == [value caseInsensitiveCompare:@"success"]) {
        return RollbarDeployApiCall_Success;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"error"]) {
        return RollbarDeployApiCall_Error;
    }
    else {
        return RollbarDeployApiCall_Error; // default case...
    }
}

@end
