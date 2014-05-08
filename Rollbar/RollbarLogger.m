//
//  RollbarLogger.m
//  rollbar-ios-app
//
//  Created by Sergei Bezborodko on 5/8/14.
//  Copyright (c) 2014 Rollbar Inc. All rights reserved.
//

#import "RollbarLogger.h"

void RollbarLog(NSString *format, ...) {
#ifdef DEBUG
    va_list args;
    va_start(args, format);
    NSLog(@"[Rollbar] %@", [[NSString alloc] initWithFormat:format arguments:args]);
    va_end(args);
#endif
}
