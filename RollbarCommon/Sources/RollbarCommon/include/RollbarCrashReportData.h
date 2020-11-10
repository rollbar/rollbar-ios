//
//  RollbarCrashReportData.h
//  
//
//  Created by Andrey Kornich on 2020-10-27.
//

#ifndef RollbarCrashReportData_h
#define RollbarCrashReportData_h

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarCrashReportData : NSObject

@property (nonatomic, readonly, nullable) NSDate *timestamp;
@property (nonatomic, readonly, nonnull) NSString *crashReport;

-(instancetype)initWithCrashReport:(nonnull NSString *)report;

-(instancetype)initWithCrashReport:(nonnull NSString *)report
                         timestamp:(nullable NSDate *)timestamp
NS_DESIGNATED_INITIALIZER;

-(instancetype)init
NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END

#endif //RollbarCrashReportData_h
