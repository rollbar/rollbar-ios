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
static dispatch_queue_t queue = nil;
static dispatch_queue_t globalConcurrentQueue = nil;

@implementation RollbarTelemetry

+ (instancetype)sharedInstance {
    static RollbarTelemetry *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[RollbarTelemetry alloc] init];
        queue = dispatch_queue_create("com.rollbar.telemetryQueue", DISPATCH_QUEUE_SERIAL);
        globalConcurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    });
    return sharedInstance;
}

+ (void)NSLogReplacement:(NSString *)format, ... {
    va_list args, argsCopy;
    va_start(args, format);
    if (captureLog) {
        va_copy (argsCopy, args);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [[RollbarTelemetry sharedInstance] recordLogEventForLevel:RollbarDebug message:message extraData:nil];
        NSLogv(format, argsCopy);
    } else {
        NSLogv(format, args);
    }
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
    dispatch_async(queue, ^{
        self.captureLog = shouldCapture;
    });
}

/**
 * Sets max number of telemetry events to capture.
 */
- (void)setDataLimit:(NSInteger)dataLimit {
    dispatch_async(queue, ^{
        limit = dataLimit;
        [self truncateDataArray];
    });
}

- (void)truncateDataArray {
    dispatch_assert_queue_debug(queue);
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

    dispatch_async(queue, ^{
        [dataArray addObject:info];
        [self truncateDataArray];
        NSData *data = [self serializedDataArray];
        dispatch_async(globalConcurrentQueue, ^{
            [self saveTelemetryData:data];
        });
    });
}

#pragma mark -

- (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:element forKey:@"element"];

    [self recordEventForLevel:level type:RollbarTelemetryView data:data];
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
    __block NSArray *dataCopy = nil;
    dispatch_sync(queue, ^{
        dataCopy = [dataArray copy];
    });
    return dataCopy;
}

- (void)clearAllData {
    dispatch_async(queue, ^{
        [dataArray removeAllObjects];
        NSData *data = [self serializedDataArray];
        dispatch_async(globalConcurrentQueue, ^{
            [self saveTelemetryData:data];
        });
    });
}

#pragma mark - Data storage

- (NSData *)serializedDataArray {
    dispatch_assert_queue_debug(queue);
    NSData *data = [NSJSONSerialization dataWithJSONObject:dataArray options:0 error:nil safe:true];
    return data;
}

- (void)saveTelemetryData:(NSData *)data {
    [data writeToFile:dataFilePath atomically:true];
}

- (void)loadTelemetryData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:dataFilePath];
        if (data) {
            NSArray *telemetryDataList = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (telemetryDataList) {
                dataArray = [telemetryDataList mutableCopy];
            }
        }
    }
}

@end
