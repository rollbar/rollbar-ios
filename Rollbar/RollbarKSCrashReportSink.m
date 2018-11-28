//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarKSCrashReportSink.h"
#import "Rollbar.h"
#import "KSCrashReportFilterBasic.h"
#import "KSCrashReportFilterAppleFmt.h"

@implementation RollbarKSCrashReportSink

- (id<KSCrashReportFilter>)defaultFilterSet {
    /*
     TODO: We can switch to the SideBySide type of Apple format:
     KSAppleReportStyleSymbolicatedSideBySide
     once the backend gets updated handle that type of crash report
     */
  return [KSCrashReportFilterPipeline filterWithFilters:
     [KSCrashReportFilterAppleFmt filterWithReportStyle:KSAppleReportStylePartiallySymbolicated],
     self,
     nil];
}

- (void)filterReports:(NSArray*) reports onCompletion:(KSCrashReportFilterCompletion)onCompletion {
    for (NSString *report in reports) {
        [Rollbar logCrashReport:report];
    }
    kscrash_callCompletion(onCompletion, reports, YES, nil);
}
@end
