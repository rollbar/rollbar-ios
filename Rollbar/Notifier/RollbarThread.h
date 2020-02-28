//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarNotifier.h"

@interface RollbarThread : NSThread

- (id)initWithNotifier:(RollbarNotifier*)notifier reportingRate:(NSUInteger)reportsPerMinute;

@property(atomic) BOOL active;

@end
