//
//  RollbarCrashCollectorProtocol.h
//  
//
//  Created by Andrey Kornich on 2020-10-27.
//

#ifndef RollbarCrashCollectorProtocol_h
#define RollbarCrashCollectorProtocol_h

@import Foundation;

@class RollbarCrashReportData;

@protocol RollbarCrashCollectorObserver

@required
-(void)onCrashReportsCollectionCompletion:(NSArray<RollbarCrashReportData *> *)crashReports;

@optional
//...

@end

@protocol RollbarCrashCollector

@required
-(void)collectCrashReportsWithObserver:(id<RollbarCrashCollectorObserver>)observer;

@optional
-(void)collectCrashReports;

@end

#endif /* RollbarCrashCollectorProtocol_h */
