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
    
    @private NSTimer *timer;
}

- (id)initWithNotifier:(RollbarNotifier *)aNotifier {
    timer = nil;
    if ((self = [super initWithTarget:self selector:@selector(run) object:nil])) {
        notifier = aNotifier;
        self.active = YES;
    }
    
    return self;
}

- (void)checkItems {
    RollbarLog(@"Checking items...");
    @autoreleasepool {
        [notifier processSavedItems];
    }
}

- (void)run {
    @autoreleasepool {

        [self updateReportingRate:notifier.configuration.maximumReportsPerMinute];
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        while (self.active) {
//            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
//        }
    }
}

- (void)updateReportingRate:(NSUInteger)maximumReportsPerMinute {
    
    if (nil != timer) {
        [timer invalidate];
    }
    NSTimeInterval timeIntervalInSeconds = 60.0 / maximumReportsPerMinute;
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

@end
