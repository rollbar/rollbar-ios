//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarNotifier.h"

@interface RollbarThread : NSThread

/// Disallowed initializer
- (instancetype)init
NS_UNAVAILABLE;

- (instancetype)initWithNotifier:(RollbarNotifier*)notifier
                   reportingRate:(NSUInteger)reportsPerMinute;
//NS_DESIGNATED_INITIALIZER;

@property(atomic) BOOL active;

@end
