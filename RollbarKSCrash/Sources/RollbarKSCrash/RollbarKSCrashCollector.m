//
//  RollbarKSCrashCollector.m
//  
//
//  Created by Andrey Kornich on 2020-10-28.
//

#import "RollbarKSCrashCollector.h"
#import "RollbarKSCrashInstallation.h"
#import "RollbarKSCrashReportSink.h"

@implementation RollbarKSCrashCollector

//- (nullable NSArray<RollbarCrashReportData *> *)collectCrashReports {
//
//    RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
//    [installation install];
//    [installation sendAllReportsWithCompletion:^(NSArray *filteredReports, BOOL completed, NSError *error) {
//        if (error) {
//            RollbarSdkLog(@"Could not enable crash reporter: %@", [error localizedDescription]);
//        } else if (completed) {
//            //[notifier processSavedItems];
//        }
//    }];}

- (void)collectCrashReportsWithCompletion:(RollbarCrashCollectionCompletion)onCompletion { 
    
    RollbarKSCrashInstallation *installation = [RollbarKSCrashInstallation sharedInstance];
    [installation install];
    [installation sendAllReportsWithCompletion:onCompletion];
}

@end
