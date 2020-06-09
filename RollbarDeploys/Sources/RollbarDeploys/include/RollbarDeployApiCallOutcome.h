//
//  RollbarDeployApiCallOutcome.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSInteger, RollbarDeployApiCallOutcome) {
    RollbarDeployApiCall_Success,
    RollbarDeployApiCall_Error,
};

NS_ASSUME_NONNULL_BEGIN

/// Enum to/from NSString conversion utility
@interface RollbarDeployApiCallOutcomeUtil : NSObject

/// Converts RollbarDeployApiCallOutcome value into a NSString
/// @param value DeployApiCallOutcome value to convert
+ (NSString *) DeployApiCallOutcomeToString:(RollbarDeployApiCallOutcome)value;

/// Converts NSString into a RollbarDeployApiCallOutcome value
/// @param value NSString to convert
+ (RollbarDeployApiCallOutcome) DeployApiCallOutcomeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
