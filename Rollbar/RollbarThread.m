//
//  RollbarThread.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 4/8/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "RollbarThread.h"

@implementation RollbarThread

- (id)initWithNotifier:(RollbarNotifier *)aNotifier {
    if ((self = [super initWithTarget:self selector:@selector(run) object:nil])) {
        notifier = aNotifier;
        self.active = YES;
    }
    
    return self;
}

- (void)checkItems {
    @autoreleasepool {
        [notifier processSavedItems];
    }
}

- (void)run {
    @autoreleasepool {
        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:10 target:self selector:@selector(checkItems) userInfo:nil repeats:YES];
        
        [runLoop addTimer:timer forMode:NSDefaultRunLoopMode];
        
        while (self.active) {
            [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
}

@end
