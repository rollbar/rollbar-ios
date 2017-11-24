//
//  RollbarTelemetry.m
//  Rollbar
//
//  Created by Ben Wong on 11/21/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarTelemetry.h"

@implementation RollbarTelemetry

+ (instancetype)sharedInstance {
    static RollbarTelemetry *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[RollbarTelemetry alloc] init];
    });
    return sharedInstance;
}

+ (void)NSLogReplacement:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
    [[RollbarTelemetry sharedInstance] recordLogEventForLevel:RollbarDebug message:message];
    NSLogv(format, args);
    va_end(args);
}

#pragma mark -

- (id)init {
    id obj = [super init];
    if (obj) {
        telemetryData = [NSMutableArray array];
    }
    return obj;
}

#pragma mark -

- (void)recordEventForLevel:(RollbarLevel)level type:(RollbarTelemetryType)type data:(NSDictionary *)data {
    NSTimeInterval timestamp = NSDate.date.timeIntervalSince1970 * 1000;
    NSString *telemetryLvl = [Rollbar stringFromLevel:level];
    NSString *telemetryType = [Rollbar stringFromTelemetryType:type];
    NSDictionary *info = @{@"level": telemetryLvl, @"type": telemetryType, @"source": @"client", @"timestamp_ms": [NSNumber numberWithDouble:timestamp], @"body": data };
    [telemetryData addObject:info];
}

#pragma mark -

- (void)recordDomEventForLevel:(RollbarLevel)level element:(NSString *)element {
    [self recordDomEventForLevel:level element:element extraData:nil];
}

- (void)recordDomEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:element forKey:@"element"];

    [self recordEventForLevel:level type:RollbarTelemetryDom data:data];
}

#pragma mark -

- (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode {
    [self recordNetworkEventForLevel:level method:method url:url statusCode:statusCode extraData:nil];
}

- (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:method forKey:@"method"];
    [data setObject:url forKey:@"url"];
    [data setObject:statusCode forKey:@"status_code"];

    [self recordEventForLevel:level type:RollbarTelemetryNetwork data:data];
}

#pragma mark -

- (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status {
    [self recordConnectivityEventForLevel:level status:status extraData:nil];
}

- (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:status forKey:@"change"];

    [self recordEventForLevel:level type:RollbarTelemetryConnectivity data:data];
}

#pragma mark -

- (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message {
    [self recordErrorEventForLevel:level message:message extraData:nil];
}

- (void)recordErrorEventForLevel:(RollbarLevel)level exception:(NSException *)exception {
    [self recordErrorEventForLevel:level message:exception.reason extraData:@{@"description": exception.description, @"class": NSStringFromClass(exception.class)}];
}

- (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:message forKey:@"message"];

    [self recordEventForLevel:level type:RollbarTelemetryError data:data];
}

#pragma mark -

- (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to {
    [self recordNavigationEventForLevel:level from:from to:to extraData:nil];
}

- (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:from forKey:@"from"];
    [data setObject:to forKey:@"to"];

    [self recordEventForLevel:level type:RollbarTelemetryNavigation data:data];
}

#pragma mark -

- (void)recordManualEventForLevel:(RollbarLevel)level withData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [self recordEventForLevel:level type:RollbarTelemetryManual data:data];
}

#pragma mark -

- (void)recordLogEventForLevel:(RollbarLevel)level message:(NSString *)message {
    [self recordLogEventForLevel:level message:message extraData:nil];
}

- (void)recordLogEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:message forKey:@"message"];

    [self recordEventForLevel:level type:RollbarTelemetryLog data:data];
}

@end
