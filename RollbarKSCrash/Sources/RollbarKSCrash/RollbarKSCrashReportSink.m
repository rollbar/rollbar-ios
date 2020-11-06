//
//  RollbarKSCrashReportSink.m
//  
//
//  Created by Andrey Kornich on 2020-10-28.
//

#import "RollbarKSCrashReportSink.h"

@implementation RollbarKSCrashReportSink

- (id<KSCrashReportFilter>)defaultFilterSet {
    /*
     TODO: We can switch to the SideBySide type of Apple format:
     KSAppleReportStyleSymbolicatedSideBySide
     once the backend gets updated handle that type of crash report
     */
    
    KSCrashReportFilterAppleFmt *format =
    [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStylePartiallySymbolicated];
    // other style alternatives:
    // - KSAppleReportStyleSymbolicatedSideBySide
    // - KSAppleReportStyleSymbolicated
    
    KSCrashReportFilterPipeline *pipeline =
    [KSCrashReportFilterPipeline filterWithFilters:format, self, nil];
    
    return pipeline;
}

- (void)filterReports:(NSArray*) reports onCompletion:(KSCrashReportFilterCompletion)onCompletion {
    for (NSString *report in reports) {
        //[Rollbar logCrashReport:report];
    }
    kscrash_callCompletion(onCompletion, reports, YES, nil);
}

@end
