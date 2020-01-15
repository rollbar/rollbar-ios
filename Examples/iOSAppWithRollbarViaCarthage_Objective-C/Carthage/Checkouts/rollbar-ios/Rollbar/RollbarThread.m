//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarThread.h"
#import "SdkLog.h"

@implementation RollbarThread {
    @private RollbarNotifier *_notifier;
    @private NSUInteger _maxReportsPerMinute;
    @private NSTimer *_timer;
}

- (id)initWithNotifier:(RollbarNotifier*)notifier reportingRate:(NSUInteger)reportsPerMinute {
    if ((self = [super initWithTarget:self selector:@selector(run) object:nil])) {
        _notifier = notifier;
        if(reportsPerMinute > 0) {
            _maxReportsPerMinute = reportsPerMinute;
        } else {
            _maxReportsPerMinute = 60;
        }
        self.active = YES;
    }
    return self;
}

- (void)checkItems {
    if (self.cancelled) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        [NSThread exit];
    }
    @autoreleasepool {
        [_notifier processSavedItems];
    }
}

- (void)run {
    @autoreleasepool {
        NSTimeInterval timeIntervalInSeconds = 60.0 / _maxReportsPerMinute;
        _timer = [NSTimer timerWithTimeInterval:timeIntervalInSeconds
                                        target:self
                                      selector:@selector(checkItems)
                                      userInfo:nil
                                       repeats:YES
                 ];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:_timer forMode:NSDefaultRunLoopMode];
        while (self.active) {
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

@end
