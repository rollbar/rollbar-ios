//
//  RollbarDeploysManager.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RollbarDeploysProtocol.h"

@interface RollbarDeploysManager : NSObject <RollbarDeploysProtocol> {
    NSMutableData *responseData;
    NSObject<DeploymentRegistrationObserver> *_deploymentRegistrationObserver;
    NSObject<DeploymentDetailsObserver> *_deploymentDetailsObserver;
    NSObject<DeploymentDetailsPageObserver> *_deploymentDetailsPageObserver;
}
// Designated Initializer:
- (id)initWithWriteAccessToken:(NSString *)writeAccessToken
               readAccessToken:(NSString *)readAccessToken
deploymentRegistrationObserver:(NSObject<DeploymentRegistrationObserver>*)deploymentRegistrationObserver
     deploymentDetailsObserver:(NSObject<DeploymentDetailsObserver>*)deploymentDetailsObserver
 deploymentDetailsPageObserver:(NSObject<DeploymentDetailsPageObserver>*)deploymentDetailsPageObserver;
@end
