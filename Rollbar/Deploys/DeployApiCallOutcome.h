//
//  DeployApiCallOutcome.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeployApiCallOutcome) {
    DeployApiCallSuccess,
    DeployApiCallError,
};

NS_ASSUME_NONNULL_BEGIN

/// Enum to/from NSString conversion utility
@interface DeployApiCallOutcomeUtil : NSObject

/// Converts DeployApiCallOutcome value into a NSString
/// @param value DeployApiCallOutcome value to convert
+ (NSString *) DeployApiCallOutcomeToString:(DeployApiCallOutcome)value;

/// Converts NSString into a DeployApiCallOutcome value
/// @param value NSString to convert
+ (DeployApiCallOutcome) DeployApiCallOutcomeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
