//
//  RollbarKSCrashReportSink.h
//  Rollbar
//
//  Created by Ben Wong on 11/9/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KSCrash.h"

@interface RollbarKSCrashReportSink : NSObject <KSCrashReportFilter>

- (id<KSCrashReportFilter>)defaultFilterSet;

@end
