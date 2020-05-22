//
//  RollbarDeploysDemoClient.h
//  macosAppObjC
//
//  Created by Andrey Kornich on 2020-05-22.
//  Copyright © 2020 Andrey Kornich (Wide Spectrum Computing LLC). All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RollbarDeploysDemoClient : NSObject

- (void)demoDeploymentRegistration;
- (void)demoGetDeploymentDetailsById;
- (void)demoGetDeploymentsPage;

@end

NS_ASSUME_NONNULL_END
