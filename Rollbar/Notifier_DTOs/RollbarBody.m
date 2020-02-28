//
//  RollbarBody.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarBody.h"

#import <Foundation/Foundation.h>
#import "DataTransferObject+Protected.h"
#import "RollbarMessage.h"
#import "RollbarCrashReport.h"
#import "RollbarTrace.h"
#import "RollbarTelemetry.h"

static NSString * const DFK_TELEMETRY = @"telemetry";
static NSString * const DFK_TRACE = @"trace";
static NSString * const DFK_TRACE_CHAIN = @"trace_chain";
static NSString * const DFK_MESSAGE = @"message";
static NSString * const DFK_CRASH_REPORT = @"crash_report";

@implementation RollbarBody
#pragma mark - Properties

- (RollbarMessage *)message {
    id data = [self getDataByKey:DFK_MESSAGE];
    if (data != nil) {
        return [[RollbarMessage alloc] initWithDictionary:data];
    }
    return nil;
}

- (void)setMessage:(RollbarMessage *)message {
    [self setDictionary:message.jsonFriendlyData forKey:DFK_MESSAGE];
}

- (RollbarCrashReport *)crashReport {
    id data = [self getDataByKey:DFK_CRASH_REPORT];
    if (data != nil) {
        return [[RollbarCrashReport alloc] initWithDictionary:data];
    }
    return nil;
}

- (void)setCrashReport:(RollbarCrashReport *)crashReport {
    [self setDictionary:crashReport.jsonFriendlyData forKey:DFK_CRASH_REPORT];
}

#pragma mark - Initializers

-(instancetype)initWithMessage:(nonnull NSString *)message {
    
    self = [super initWithDictionary:@{
        DFK_MESSAGE: [[RollbarMessage alloc] initWithBody:message].jsonFriendlyData,
        DFK_CRASH_REPORT: [NSNull null],
        DFK_TRACE: [NSNull null],
        DFK_TRACE_CHAIN: [NSNull null],
        DFK_TELEMETRY: [self snapTelemetryData],
    }];
    return self;
}

-(instancetype)initWithException:(nonnull NSException *)exception {
    
    RollbarTrace *trace = [[RollbarTrace alloc] initWithException:exception];
    self = [super initWithDictionary:@{
        DFK_MESSAGE: [NSNull null],
        DFK_CRASH_REPORT: [NSNull null],
        DFK_TRACE: trace.jsonFriendlyData,
        DFK_TRACE_CHAIN: [NSNull null],
        DFK_TELEMETRY: [self snapTelemetryData],
    }];
    return self;
}

-(instancetype)initWithError:(nonnull NSError *)error {
    
    self = [super initWithDictionary:@{
        DFK_MESSAGE: [[RollbarMessage alloc] initWithNSError:error].jsonFriendlyData,
        DFK_CRASH_REPORT: [NSNull null],
        DFK_TRACE: [NSNull null],
        DFK_TRACE_CHAIN: [NSNull null],
        DFK_TELEMETRY: [self snapTelemetryData],
    }];
    return self;
}

-(instancetype)initWithCrashReport:(nonnull NSString *)crashReport {
    
    self = [super initWithDictionary:@{
        DFK_MESSAGE: [NSNull null],
        DFK_CRASH_REPORT: [[RollbarCrashReport alloc] initWithRawCrashReport:crashReport].jsonFriendlyData,
        DFK_TRACE: [NSNull null],
        DFK_TRACE_CHAIN: [NSNull null],
        DFK_TELEMETRY: [self snapTelemetryData],
    }];
    return self;
}

#pragma mark - Private methods

-(id)snapTelemetryData {
    
    NSArray *telemetryData = [[RollbarTelemetry sharedInstance] getAllData];
    if (telemetryData && telemetryData.count > 0) {
        return telemetryData;
    }
    else {
        return [NSNull null];
    }
}

@end
