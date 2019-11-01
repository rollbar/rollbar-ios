//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarNotifier.h"

void RollbarClearLogFile(void);
NSArray* RollbarReadLogItemFromFile(void);
void RollbarFlushFileThread(RollbarNotifier *notifier);

@interface RollbarNotifier (Tests)
- (NSThread *)_rollbarThread;
- (void)_test_doNothing;
@end
