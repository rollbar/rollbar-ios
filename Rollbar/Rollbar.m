//
//  Rollbar.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "Rollbar.h"
#import "RollbarNotifier.h"
#import "RollbarLogger.h"
#import <CrashReporter/CrashReporter.h>


@implementation Rollbar

static RollbarNotifier *notifier = nil;

+ (void)enableCrashReporter {
    NSError *error;
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    
    if ([crashReporter hasPendingCrashReport]) {
        NSData *crashData = [crashReporter loadPendingCrashReportData];
        PLCrashReport *report = [[PLCrashReport alloc] initWithData:crashData error:&error];
        
        if (error) {
            RollbarLog(@"Could not load crash file: %@", [error localizedDescription]);
        } else {
            PLCrashReportTextFormat textFormat = PLCrashReportTextFormatiOS;
            
            NSString *crashReportText = [PLCrashReportTextFormatter stringValueForCrashReport:report withTextFormat:textFormat];
            
            // Grab the configuration saved to disk before the crash happened
            RollbarConfiguration *config = [[RollbarConfiguration alloc] initWithLoadedConfiguration];
            
            // Create a temporary notifier using the above configuration and report the crash
            RollbarNotifier *tempNotifier = [[RollbarNotifier alloc] initWithAccessToken:config.accessToken configuration:config isRoot:NO];
            
            [tempNotifier logCrashReport:crashReportText];
        }
        
        [crashReporter purgePendingCrashReport];
    }
    
    [crashReporter enableCrashReporterAndReturnError:&error];
    if (error) {
        RollbarLog(@"Could not enable crash reporter: %@", [error localizedDescription]);
    }
}

+ (void)initWithAccessToken:(NSString *)accessToken {
    [self initWithAccessToken:accessToken configuration:nil];
}

+ (void)initWithAccessToken:(NSString *)accessToken configuration:(RollbarConfiguration*)configuration {
    [self initWithAccessToken:accessToken configuration:configuration enableCrashReporter:YES];
}

+ (void)initWithAccessToken:(NSString *)accessToken configuration:(RollbarConfiguration*)configuration
        enableCrashReporter:(BOOL)enable {
    if (notifier) {
        RollbarLog(@"Rollbar has already been initialized.");
    } else {
        notifier = [[RollbarNotifier alloc] initWithAccessToken:accessToken configuration:configuration isRoot:YES];

        if (enable) {
            [self enableCrashReporter];
        }
        
        [notifier.configuration save];
    }
}

+ (RollbarConfiguration*)currentConfiguration {
    return notifier.configuration;
}

// Log

+ (void)logWithLevel:(NSString*)level message:(NSString*)message {
    [notifier log:level message:message exception:nil data:nil];
}

+ (void)logWithLevel:(NSString*)level message:(NSString*)message data:(NSDictionary*)data {
    [notifier log:level message:message exception:nil data:data];
}

+ (void)logWithLevel:(NSString*)level data:(NSDictionary*)data {
    [notifier log:level message:nil exception:nil data:data];
}

// Debug

+ (void)debugWithMessage:(NSString*)message {
    [notifier log:@"debug" message:message exception:nil data:nil];
}

+ (void)debugWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"debug" message:message exception:nil data:data];
}

+ (void)debugWithData:(NSDictionary*)data {
    [notifier log:@"debug" message:nil exception:nil data:data];
}

// Info

+ (void)infoWithMessage:(NSString*)message {
    [notifier log:@"info" message:message exception:nil data:nil];
}

+ (void)infoWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"info" message:message exception:nil data:data];
}

+ (void)infoWithData:(NSDictionary*)data {
    [notifier log:@"info" message:nil exception:nil data:data];
}

// Warning

+ (void)warningWithMessage:(NSString*)message {
    [notifier log:@"warning" message:message exception:nil data:nil];
}

+ (void)warningWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"warning" message:message exception:nil data:data];
}

+ (void)warningWithData:(NSDictionary*)data {
    [notifier log:@"warning" message:nil exception:nil data:data];
}

// Error

+ (void)errorWithMessage:(NSString*)message {
    [notifier log:@"error" message:message exception:nil data:nil];
}

+ (void)errorWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"error" message:message exception:nil data:data];
}

+ (void)errorWithData:(NSDictionary*)data {
    [notifier log:@"error" message:nil exception:nil data:data];
}

// Critical

+ (void)criticalWithMessage:(NSString*)message {
    [notifier log:@"critical" message:message exception:nil data:nil];
}

+ (void)criticalWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"critical" message:message exception:nil data:data];
}

+ (void)criticalWithData:(NSDictionary*)data {
    [notifier log:@"critical" message:nil exception:nil data:data];
}

@end
