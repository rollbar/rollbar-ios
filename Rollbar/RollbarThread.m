//
//  RollbarThread.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 4/8/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "RollbarThread.h"
#import "RollbarLogger.h"

@implementation RollbarThread {
    
    @private NSUInteger maxReportsPerMinute;
    @private NSTimer *timer;
}

- (id)initWithNotifier:(RollbarNotifier*)aNotifier
  andWithReportingRate:(NSUInteger)reportsPerMinute {
    
    timer = nil;
    maxReportsPerMinute = 60; //default rate
    
    if ((self = [super initWithTarget:self selector:@selector(run) object:nil])) {
        notifier = aNotifier;
        if(reportsPerMinute > 0) {
            maxReportsPerMinute = reportsPerMinute;
        }
        self.active = YES;
    }
    return self;
}

- (void)checkItems {
    
#ifdef DEBUG
    RollbarLog(@"Checking items...");
#endif
    
    if (self.cancelled) {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
        [NSThread exit];
    }
    @autoreleasepool {
        [notifier processSavedItems];
    }
}

- (void)run {
    @autoreleasepool {
        
        NSTimeInterval timeIntervalInSeconds = 60.0 / maxReportsPerMinute;
        timer = [NSTimer timerWithTimeInterval:timeIntervalInSeconds
                                        target:self
                                      selector:@selector(checkItems)
                                      userInfo:nil
                                       repeats:YES
                 ];
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        while (self.active) {
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}
@end
