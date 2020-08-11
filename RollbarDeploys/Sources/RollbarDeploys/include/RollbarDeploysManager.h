//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarDeploysProtocol.h"
@import Foundation;
@import RollbarCommon;

NS_ASSUME_NONNULL_BEGIN

/// Rollbar Deploys Manager (a facade client to the Rollbar Deploy APIs)
@interface RollbarDeploysManager : NSObject <RollbarDeploysProtocol> {
}

/// Designated initializer
/// @param writeAccessToken write AccessToken
/// @param readAccessToken read AccessToken
/// @param deploymentRegistrationObserver deployment registration observer
/// @param deploymentDetailsObserver deployment details observer
/// @param deploymentDetailsPageObserver deployment details page observer
- (instancetype)initWithWriteAccessToken:(nullable NSString *)writeAccessToken
                         readAccessToken:(nullable NSString *)readAccessToken
          deploymentRegistrationObserver:(nullable NSObject<RollbarDeploymentRegistrationObserver> *)deploymentRegistrationObserver
               deploymentDetailsObserver:(nullable NSObject<RollbarDeploymentDetailsObserver> *)deploymentDetailsObserver
           deploymentDetailsPageObserver:(nullable NSObject<RollbarDeploymentDetailsPageObserver> *)deploymentDetailsPageObserver
NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
