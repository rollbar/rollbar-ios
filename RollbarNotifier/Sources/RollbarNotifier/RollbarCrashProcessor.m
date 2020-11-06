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
        
        // Let's sleep this thread for a few seconds to give the items processing thread a chance
        // to send the payload logged above so that we can handle cases when the SDK is initialized
        // right/shortly before a persistent application crash (that we have no control over) if any:
        [NSThread sleepForTimeInterval:5.0f]; // [sec]
    }
}

@end
