//
//  RollbarCrashCollector.h
//  
//
//  Created by Andrey Kornich on 2020-10-27.
//

#ifndef RollbarCrashCollector_h
#define RollbarCrashCollector_h

@import Foundation;

@class RollbarCrashReportData;

typedef void(^RollbarCrashCollectionCompletion)(
                                                NSArray<RollbarCrashReportData *> *filteredReports,
                                                BOOL completed,
                                                NSError *error
                                                );

@protocol RollbarCrashCollector <NSObject>

@required
-(void)collectCrashReportsWithCompletion:(RollbarCrashCollectionCompletion)onCompletion;

@optional
//...

@end

@protocol RollbarCrashCollectorObserver <NSObject>

@required
-(void)onCrashReportsCollectionCompletion:(NSArray<RollbarCrashReportData *> *)crashReports;

@optional
    //...

@end

#endif /* RollbarCrashCollector_h */
