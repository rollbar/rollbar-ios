//
//  RollbarCrashReportData.m
//  
//
//  Created by Andrey Kornich on 2020-10-27.
//

#import "RollbarCrashReportData.h"

@implementation RollbarCrashReportData

-(instancetype)initWithCrashReport:(NSString *)report {
    
    return [self initWithCrashReport:report timestamp:nil];
}

-(instancetype)initWithCrashReport:(NSString *)report
                         timestamp:(NSDate *)timestamp {

    if (self = [super init]) {
        _crashReport = report;
        _timestamp = timestamp;
    }
    return self;
}

@end
