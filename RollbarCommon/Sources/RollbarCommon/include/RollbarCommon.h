//
//  Rollbar.h
//  Rollbar
//
//  Created by Andrey Kornich on 2020-01-17.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#ifndef RollbarCommon_h
#define RollbarCommon_h

//#import <Foundation/Foundation.h>
@import Foundation;

//#if TARGET_OS_IOS
//#import <UIKit/UIKit.h>
//#endif

//#if TARGET_OS_MACOS
//#import <Cocoa/Cocoa.h>
//#endif

//! Project version number for RollbarCommon.framework.
FOUNDATION_EXPORT double RollbarCommonVersionNumber;

//! Project version string for RollbarCommon.framework.
FOUNDATION_EXPORT const unsigned char RollbarCommonVersionString[];

// In this header, you should import all the public headers of your framework using statements like
// #import <RollbarCommon/PublicHeader.h>

#import "RollbarJSONSupport.h"
#import "RollbarPersistent.h"
#import "RollbarDTO+Protected.h"
#import "RollbarSdkLog.h"
#import "RollbarTriStateFlag.h"
#import "NSJSONSerialization+Rollbar.h"

#import "RollbarDTOAbstraction.h"

//#import <RollbarJSONSupport.h>
//#import <RollbarPersistent.h>
//#import <RollbarSdkLog.h>
//#import <RollbarTriStateFlag.h>
//#import <NSJSONSerialization+Rollbar.h>
//
//#import <RollbarDTOAbstraction.h>

#endif /* RollbarCommon_h */
