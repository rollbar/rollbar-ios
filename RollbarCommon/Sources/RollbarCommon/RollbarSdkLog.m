//  Copyright (c) 2018 Rollbar Inc. All rights reserved.

#import "RollbarSdkLog.h"

void RollbarSdkLog(NSString *format, ...) {
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSLog(@"[Rollbar] %@", [[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
#endif
}
