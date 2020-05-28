//
//  RollbarNotifier.h
//  Rollbar
//
//  Created by Andrey Kornich on 2020-01-27.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#ifndef RollbarNotifier_h
#define RollbarNotifier_h

//#import <Foundation/Foundation.h>
@import Foundation;

//#if TARGET_OS_IOS
//#import <UIKit/UIKit.h>
//#endif

//#if TARGET_OS_MACOS
//#import <Cocoa/Cocoa.h>
//#endif

//! Project version number for RollbarNotifier.framework.
FOUNDATION_EXPORT double RollbarNotifierVersionNumber;

//! Project version string for RollbarNotifier.framework.
FOUNDATION_EXPORT const unsigned char RollbarNotifierVersionString[];

// In this header, you should import all the public headers of your framework using statements like
// #import <RollbarNotifier/PublicHeader.h>

#import "Rollbar.h"
#import "RollbarTelemetry.h"

#endif /* RollbarNotifier_h */
