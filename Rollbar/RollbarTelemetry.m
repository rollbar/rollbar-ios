//
//  RollbarTelemetry.m
//  Rollbar
//
//  Created by Ben Wong on 11/21/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarTelemetry.h"
#import "NSJSONSerialization+Rollbar.h"

#define DEFAULT_DATA_LIMIT 10
#define TELEMETRY_FILE_NAME @"rollbar.telemetry"

static BOOL captureLog = false;

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
    if (captureLog) {
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [[RollbarTelemetry sharedInstance] recordLogEventForLevel:RollbarDebug message:message extraData:nil];
    }
    NSLogv(format, args);
    va_end(args);
}

#pragma mark -

- (id)init {
    self = [super init];
    if (self) {
        dataArray = [NSMutableArray array];
        limit = DEFAULT_DATA_LIMIT;
        
        // Create cache file
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory = [paths objectAtIndex:0];
        dataFilePath = [cachesDirectory stringByAppendingPathComponent:TELEMETRY_FILE_NAME];
        
        [self loadTelemetryData];
    }
    return self;
}

#pragma mark -

/**
 * Sets whether or not to use replacement log.
 */
- (void)setCaptureLog:(BOOL)shouldCapture {
    captureLog = shouldCapture;
}

/**
 * Sets max number of telemetry events to capture.
 */
- (void)setDataLimit:(NSInteger)dataLimit {
    limit = dataLimit;
    [self truncateDataArray];
}

- (void)truncateDataArray {
    if (limit > 0 && dataArray.count > limit) {
        [dataArray removeObjectsInRange:NSMakeRange(0, dataArray.count - limit)];
    }
}

#pragma mark -

- (void)recordEventForLevel:(RollbarLevel)level type:(RollbarTelemetryType)type data:(NSDictionary *)data {
    NSTimeInterval timestamp = NSDate.date.timeIntervalSince1970 * 1000.0;
    NSString *telemetryLvl = RollbarStringFromLevel(level);
    NSString *telemetryType = RollbarStringFromTelemetryType(type);
    NSDictionary *info = @{@"level": telemetryLvl, @"type": telemetryType, @"source": @"client", @"timestamp_ms": [NSString stringWithFormat:@"%.0f", round(timestamp)], @"body": data };
    [dataArray addObject:info];
    [self truncateDataArray];
    [self saveTelemetryData];
}

#pragma mark -

- (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:element forKey:@"element"];

    [self recordEventForLevel:level type:RollbarTelemetryDom data:data];
}

#pragma mark -

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

- (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:status forKey:@"change"];

    [self recordEventForLevel:level type:RollbarTelemetryConnectivity data:data];
}

#pragma mark -

- (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:message forKey:@"message"];

    [self recordEventForLevel:level type:RollbarTelemetryError data:data];
}

#pragma mark -

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

- (void)recordLogEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:message forKey:@"message"];

    [self recordEventForLevel:level type:RollbarTelemetryLog data:data];
}

#pragma mark -

- (NSArray *)getAllData {
    return [NSArray arrayWithArray:dataArray];
}

- (void)clearAllData {
    [dataArray removeAllObjects];
    [self saveTelemetryData];
}

#pragma mark - Data storage

- (void)saveTelemetryData {
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil safe:true];
    [data writeToFile:dataFilePath atomically:true];
}

- (void)loadTelemetryData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        if (data) {
            NSArray *telemetryDataList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            dataArray = [telemetryDataList mutableCopy];
        }
    }
}

@end
