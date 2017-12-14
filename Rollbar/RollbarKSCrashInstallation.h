//
//  RollbarKSCrashInstallation.h
//  Rollbar
//
//  Created by Ben Wong on 11/9/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrash.h"
#import "KSCrashInstallation.h"

@interface RollbarKSCrashInstallation : KSCrashInstallation

+ (instancetype)sharedInstance;
- (void)sendAllReports;

@end
