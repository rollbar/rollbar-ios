//
//  Rollbar.h
//  Rollbar
//
//  Created by Andrey Kornich on 2020-01-17.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#ifndef RollbarDeploys_h
#define RollbarDeploys_h

//#import <Foundation/Foundation.h>
@import Foundation;

//#if TARGET_OS_IOS
//#import <UIKit/UIKit.h>
//#endif

//#if TARGET_OS_MACOS
//#import <Cocoa/Cocoa.h>
//#endif

//! Project version number for RollbarDeploys.framework.
FOUNDATION_EXPORT double RollbarDeploysVersionNumber;

//! Project version string for RollbarDeploys.framework.
FOUNDATION_EXPORT const unsigned char RollbarDeploysVersionString[];

// In this header, you should import all the public headers of your framework using statements like
// #import <RollbarCommon/PublicHeader.h>

#import "RollbarDeploysDTOs.h"
#import "RollbarDeploysProtocol.h"
#import "RollbarDeploysManager.h"

#endif /* RollbarDeploys_h */
