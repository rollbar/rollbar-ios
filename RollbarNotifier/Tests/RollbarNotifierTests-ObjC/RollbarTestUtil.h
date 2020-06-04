//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>

@import RollbarNotifier;

void RollbarClearLogFile(void);
NSArray* RollbarReadLogItemFromFile(void);
void RollbarFlushFileThread(RollbarLogger *logger);

@interface RollbarLogger (Tests)

- (NSThread *)_rollbarThread;
- (void)_test_doNothing;

@end
