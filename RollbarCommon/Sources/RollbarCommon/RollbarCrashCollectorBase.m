//
//  RollbarCrashCollectorBase.m
//  
//
//  Created by Andrey Kornich on 2020-11-02.
//

#import "RollbarCrashCollectorBase.h"
#import "RollbarSdkLog.h"

@implementation RollbarCrashCollectorBase

- (instancetype)init {
    
    return [self initWithObserver:nil];
}

- (instancetype)initWithObserver:(id<RollbarCrashCollectorObserver>)observer {
    
    if (self = [super init]) {
        self->_observer = observer;
    }
    return self;
}

- (void)collectCrashReportsWithObserver:(id<RollbarCrashCollectorObserver>)observer {
    
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)collectCrashReports {
    if (nil == self->_observer) {
        RollbarSdkLog(@"RollbarCrashCollectorBase was not initialized with a valid observer.");
    }
    [self collectCrashReportsWithObserver:self->_observer];
}

@end
