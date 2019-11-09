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

@interface DeployApiCallOutcomeUtil : NSObject

+ (NSString *) DeployApiCallOutcomeToString:(DeployApiCallOutcome)value;
+ (DeployApiCallOutcome) DeployApiCallOutcomeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
