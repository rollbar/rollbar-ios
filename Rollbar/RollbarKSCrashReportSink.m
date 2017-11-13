//
//  RollbarKSCrashReportSink.m
//  Rollbar
//
//  Created by Ben Wong on 11/9/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarKSCrashReportSink.h"
#import "Rollbar.h"

@implementation RollbarKSCrashReportSink

- (void) filterReports:(NSArray*) reports onCompletion:(KSCrashReportFilterCompletion) onCompletion {
    for (NSDictionary *report in reports) {
        NSDictionary *userInfo = [report valueForKeyPath:@"user"];
        NSString *reason = [report valueForKeyPath:@"crash.error.reason"];
        NSString *exceptionName = [report valueForKeyPath:@"crash.error.nsexception.name"];
        NSException *exception;
        if (exceptionName) {
            exception = [NSException exceptionWithName:exceptionName reason:reason userInfo:userInfo];
        }
        [Rollbar error:(reason ? reason : @"Unknown Error") exception:(exception ? exception : nil) data:report];
    }
    kscrash_callCompletion(onCompletion, reports, YES, nil);
}
@end
