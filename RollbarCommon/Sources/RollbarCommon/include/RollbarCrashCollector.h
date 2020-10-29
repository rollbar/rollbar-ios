//
//  RollbarCrashCollector.h
//  
//
//  Created by Andrey Kornich on 2020-10-27.
//

#ifndef RollbarCrashCollector_h
#define RollbarCrashCollector_h

@class RollbarCrashReportData;
//#import "RollbarCrashReportData.h"

@protocol RollbarCrashCollector <NSObject>

@required
-(nullable RollbarCrashReportData *)collectCrashReport;

@optional
//...

@end

#endif /* RollbarCrashCollector_h */
