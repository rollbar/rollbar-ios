//
//  DeployApiCallOutcome.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DeployApiCallOutcome.h"

@implementation DeployApiCallOutcomeUtil

+ (NSString *) DeployApiCallOutcomeToString:(DeployApiCallOutcome)value; {
    switch (value) {
        case DeployApiCallSuccess:
            return @"success";
        case DeployApiCallError:
            return @"error";
        default:
            return @"unknown";
    }
}

+ (DeployApiCallOutcome) DeployApiCallOutcomeFromString:(NSString *)value {
    
    if (NSOrderedSame == [value caseInsensitiveCompare:@"success"]) {
        return DeployApiCallSuccess;
    }
    else  if (NSOrderedSame == [value caseInsensitiveCompare:@"error"]) {
        return DeployApiCallError;
    }
    else {
        return DeployApiCallError; // default case...
    }
}

@end
