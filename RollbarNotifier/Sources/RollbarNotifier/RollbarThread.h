//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

@class RollbarLogger;

@interface RollbarThread : NSThread

/// Disallowed initializer
- (instancetype)init
NS_UNAVAILABLE;

- (instancetype)initWithNotifier:(RollbarLogger*)logger
                   reportingRate:(NSUInteger)reportsPerMinute;
//NS_DESIGNATED_INITIALIZER;

@property(atomic) BOOL active;

@end
