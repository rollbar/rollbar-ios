//
//  Rollbar.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import "Rollbar.h"
#import "RollbarNotifier.h"

@implementation Rollbar

static RollbarNotifier *notifier = nil;

void uncaught_exception(NSException *exception) {
    if (notifier) {
        [notifier uncaughtException:exception];
    }
}

+ (void)initWithAccessToken:(NSString *)accessToken environment:(NSString*)environment {
    if (notifier) {
        NSLog(@"Rollbar has already been initialized.");
    } else {
        notifier = [[RollbarNotifier alloc] initWithAccessToken:accessToken environment:environment];
        
        NSSetUncaughtExceptionHandler(&uncaught_exception);
    }
}

// Log

+ (void)logWithLevel:(NSString*)level message:(NSString*)message {
    [notifier log:level message:message exception:nil data:nil];
}

+ (void)logWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception {
    [notifier log:level message:message exception:nil data:nil];
}

+ (void)logWithLevel:(NSString*)level message:(NSString*)message data:(NSDictionary*)data {
    [notifier log:level message:message exception:nil data:data];
}

+ (void)logWithLevel:(NSString*)level exception:(NSException*)exception {
    [notifier log:level message:nil exception:exception data:nil];
}

+ (void)logWithLevel:(NSString*)level exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:level message:nil exception:exception data:data];
}

+ (void)logWithLevel:(NSString*)level data:(NSDictionary*)data {
    [notifier log:level message:nil exception:nil data:data];
}

+ (void)logWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:level message:message exception:exception data:data];
}

// Debug

+ (void)debugWithMessage:(NSString*)message {
    [notifier log:@"debug" message:message exception:nil data:nil];
}

+ (void)debugWithMessage:(NSString*)message exception:(NSException*)exception {
    [notifier log:@"debug" message:message exception:nil data:nil];
}

+ (void)debugWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"debug" message:message exception:nil data:data];
}

+ (void)debugWithException:(NSException*)exception {
    [notifier log:@"debug" message:nil exception:exception data:nil];
}

+ (void)debugWithException:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"debug" message:nil exception:exception data:data];
}

+ (void)debugWithData:(NSDictionary*)data {
    [notifier log:@"debug" message:nil exception:nil data:data];
}

+ (void)debug:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"debug" message:message exception:exception data:data];
}

// Info

+ (void)infoWithMessage:(NSString*)message {
    [notifier log:@"info" message:message exception:nil data:nil];
}

+ (void)infoWithMessage:(NSString*)message exception:(NSException*)exception {
    [notifier log:@"info" message:message exception:nil data:nil];
}

+ (void)infoWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"info" message:message exception:nil data:data];
}

+ (void)infoWithException:(NSException*)exception {
    [notifier log:@"info" message:nil exception:exception data:nil];
}

+ (void)infoWithException:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"info" message:nil exception:exception data:data];
}

+ (void)infoWithData:(NSDictionary*)data {
    [notifier log:@"info" message:nil exception:nil data:data];
}

+ (void)info:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"info" message:message exception:exception data:data];
}

// Warning

+ (void)warningWithMessage:(NSString*)message {
    [notifier log:@"warning" message:message exception:nil data:nil];
}

+ (void)warningWithMessage:(NSString*)message exception:(NSException*)exception {
    [notifier log:@"warning" message:message exception:nil data:nil];
}

+ (void)warningWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"warning" message:message exception:nil data:data];
}

+ (void)warningWithException:(NSException*)exception {
    [notifier log:@"warning" message:nil exception:exception data:nil];
}

+ (void)warningWithException:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"warning" message:nil exception:exception data:data];
}

+ (void)warningWithData:(NSDictionary*)data {
    [notifier log:@"warning" message:nil exception:nil data:data];
}

+ (void)warning:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"warning" message:message exception:exception data:data];
}

// Error

+ (void)errorWithMessage:(NSString*)message {
    [notifier log:@"error" message:message exception:nil data:nil];
}

+ (void)errorWithMessage:(NSString*)message exception:(NSException*)exception {
    [notifier log:@"error" message:message exception:nil data:nil];
}

+ (void)errorWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"error" message:message exception:nil data:data];
}

+ (void)errorWithException:(NSException*)exception {
    [notifier log:@"error" message:nil exception:exception data:nil];
}

+ (void)errorWithException:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"error" message:nil exception:exception data:data];
}

+ (void)errorWithData:(NSDictionary*)data {
    [notifier log:@"error" message:nil exception:nil data:data];
}

+ (void)error:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"error" message:message exception:exception data:data];
}

// Critical

+ (void)criticalWithMessage:(NSString*)message {
    [notifier log:@"critical" message:message exception:nil data:nil];
}

+ (void)criticalWithMessage:(NSString*)message exception:(NSException*)exception {
    [notifier log:@"critical" message:message exception:nil data:nil];
}

+ (void)criticalWithMessage:(NSString*)message data:(NSDictionary*)data {
    [notifier log:@"critical" message:message exception:nil data:data];
}

+ (void)criticalWithException:(NSException*)exception {
    [notifier log:@"critical" message:nil exception:exception data:nil];
}

+ (void)criticalWithException:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"critical" message:nil exception:exception data:data];
}

+ (void)criticalWithData:(NSDictionary*)data {
    [notifier log:@"critical" message:nil exception:nil data:data];
}

+ (void)critical:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    [notifier log:@"critical" message:message exception:exception data:data];
}

@end
