//
//  RollbarCrashCollectorBase.m
//  
//
//  Created by Andrey Kornich on 2020-11-02.
//

#import "RollbarCrashCollectorBase.h"

@implementation RollbarCrashCollectorBase

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
    
    [self collectCrashReportsWithObserver:self->_observer];
}

@end
