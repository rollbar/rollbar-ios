//
//  RollbarBody.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-11-27.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarBody.h"

#import "RollbarMessage.h"
#import "RollbarCrashReport.h"
#import "RollbarTrace.h"
#import "RollbarTelemetry.h"
#import "RollbarTelemetryEvent.h"

static NSString * const DFK_TELEMETRY = @"telemetry";
static NSString * const DFK_TRACE = @"trace";
static NSString * const DFK_TRACE_CHAIN = @"trace_chain";
static NSString * const DFK_MESSAGE = @"message";
static NSString * const DFK_CRASH_REPORT = @"crash_report";

@implementation RollbarBody
#pragma mark - Properties

- (nullable RollbarMessage *)message {
    id data = [self getDataByKey:DFK_MESSAGE];
    if (data != nil) {
        return [[RollbarMessage alloc] initWithDictionary:data];
    }
    return nil;
}

- (void)setMessage:(RollbarMessage *)message {
    [self setDictionary:message.jsonFriendlyData forKey:DFK_MESSAGE];
}

- (nullable RollbarCrashReport *)crashReport {
    id data = [self getDataByKey:DFK_CRASH_REPORT];
    if (data != nil) {
        return [[RollbarCrashReport alloc] initWithDictionary:data];
    }
    return nil;
}

- (void)setCrashReport:(RollbarCrashReport *)crashReport {
    [self setDictionary:crashReport.jsonFriendlyData forKey:DFK_CRASH_REPORT];
}

- (nullable RollbarTrace *)trace {
    id data = [self getDataByKey:DFK_TRACE];
    if (data != nil) {
        return [[RollbarTrace alloc] initWithDictionary:data];
    }
    return nil;
}

- (void)setTrace:(nullable RollbarTrace *)trace {
    [self setDictionary:trace.jsonFriendlyData forKey:DFK_TRACE];
}

- (nullable NSArray<RollbarTrace *> *)traceChain {
    NSArray *dataArray = [self getDataByKey:DFK_TRACE_CHAIN];
    if (dataArray) {
        NSMutableArray<RollbarTrace *> *result = [NSMutableArray arrayWithCapacity:dataArray.count];
        for(NSDictionary *data in dataArray) {
            if (data) {
                [result addObject:[[RollbarTrace alloc] initWithDictionary:data]];
            }
        }
        return result;
    }
    return nil; //[NSMutableArray array];
}

- (void)setTraceChain:(nullable NSArray<RollbarTrace *> *)traceChain {

    [self setData:[self getJsonFriendlyDataFromTraceChain:traceChain] byKey:DFK_TRACE_CHAIN];
}

- (nullable NSArray<RollbarTelemetryEvent *> *)telemetry {
    NSArray *dataArray = [self getDataByKey:DFK_TELEMETRY];
    if (dataArray) {
        NSMutableArray<RollbarTelemetryEvent *> *result = [NSMutableArray arrayWithCapacity:dataArray.count];
        for(NSDictionary *data in dataArray) {
            if (data) {
                [result addObject:[[RollbarTelemetryEvent alloc] initWithDictionary:data]];
            }
        }
        return result;
    }
    return [NSMutableArray array];
}

- (void)setTelemetry:(nullable NSArray<RollbarTelemetryEvent *> *)telemetry {

    [self setData:[self getJsonFriendlyDataFromTelemetry:telemetry] byKey:DFK_TELEMETRY];
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

-(NSArray *)getJsonFriendlyDataFromTraceChain:(NSArray<RollbarTrace *> *)traces {
    if (traces) {
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:traces.count];
        for(RollbarTrace *trace in traces) {
            if (trace) {
                [data addObject:trace.jsonFriendlyData];
            }
        }
        return data;
    }
    else {
        return nil;
    }
}

-(NSArray *)getJsonFriendlyDataFromTelemetry:(NSArray<RollbarTelemetryEvent *> *)telemetry {
    if (telemetry) {
        NSMutableArray *data = [NSMutableArray arrayWithCapacity:telemetry.count];
        for(RollbarTelemetryEvent *event in telemetry) {
            if (event) {
                [data addObject:event.jsonFriendlyData];
            }
        }
        return data;
    }
    else {
        return nil;
    }
}

-(id)snapTelemetryData {
    
    if (![RollbarTelemetry sharedInstance].enabled) {
        return [NSNull null];;
    }
    
    NSArray *telemetryData = [[RollbarTelemetry sharedInstance] getAllData];
    if (telemetryData && telemetryData.count > 0) {
        return telemetryData;
    }
    else {
        return [NSNull null];
    }
}

@end
