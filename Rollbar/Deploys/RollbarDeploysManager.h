//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "RollbarDeploysProtocol.h"

@interface RollbarDeploysManager : NSObject <RollbarDeploysProtocol> {
    NSMutableData *responseData;
    NSObject<DeploymentRegistrationObserver> *_deploymentRegistrationObserver;
    NSObject<DeploymentDetailsObserver> *_deploymentDetailsObserver;
    NSObject<DeploymentDetailsPageObserver> *_deploymentDetailsPageObserver;
}

- (instancetype)initWithWriteAccessToken:(NSString *)writeAccessToken
                         readAccessToken:(NSString *)readAccessToken
          deploymentRegistrationObserver:(NSObject<DeploymentRegistrationObserver>*)deploymentRegistrationObserver
               deploymentDetailsObserver:(NSObject<DeploymentDetailsObserver>*)deploymentDetailsObserver
           deploymentDetailsPageObserver:(NSObject<DeploymentDetailsPageObserver>*)deploymentDetailsPageObserver
NS_DESIGNATED_INITIALIZER;

@end
