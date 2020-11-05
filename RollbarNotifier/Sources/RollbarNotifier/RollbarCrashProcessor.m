//
//  MyClass.m
//  
//
//  Created by Andrey Kornich on 2020-11-04.
//

#import "RollbarCrashProcessor.h"
#import "Rollbar.h"

@implementation RollbarCrashProcessor

- (void)onCrashReportsCollectionCompletion:(NSArray<RollbarCrashReportData *> *)crashReports {
    for (RollbarCrashReportData *crashRecord in crashReports) {
        [Rollbar logCrashReport:crashRecord.crashReport];
    }
}

@end
