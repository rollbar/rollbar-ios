//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarTelemetry.h"
#import "NSJSONSerialization+Rollbar.h"
#import "RollbarCachesDirectory.h"

#define DEFAULT_DATA_LIMIT 10
#define TELEMETRY_FILE_NAME @"rollbar.telemetry"

static BOOL captureLog = false;

// this queue is used for serializing state changes to the various
// state in this class: captureLog, limit, dataArray
static dispatch_queue_t queue = nil;
// this queue is used for dispatching file system writes, we don't
// want or need to block our state queue by file system writes
static dispatch_queue_t fileQueue = nil;

@implementation RollbarTelemetry {
    NSMutableArray *_dataArray;
    NSInteger _limit;
    NSString *_dataFilePath;
}

+ (instancetype)sharedInstance {
    static RollbarTelemetry *sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedInstance = [[RollbarTelemetry alloc] init];
        queue = dispatch_queue_create("com.rollbar.telemetryQueue", DISPATCH_QUEUE_SERIAL);
        fileQueue = dispatch_queue_create("com.rollbar.telemetryFileQueue", DISPATCH_QUEUE_SERIAL);
    });
    return sharedInstance;
}

+ (void)NSLogReplacement:(NSString *)format, ... {
    va_list args, argsCopy;
    va_start(args, format);
    if (captureLog) {
        va_copy (argsCopy, args);
        NSString *message = [[NSString alloc] initWithFormat:format arguments:args];
        [[RollbarTelemetry sharedInstance] recordLogEventForLevel:RollbarDebug
                                                          message:message
                                                        extraData:nil];
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
        _dataArray = [NSMutableArray array];
        _limit = DEFAULT_DATA_LIMIT;
        
        // Create cache file
        NSString *cachesDirectory = [RollbarCachesDirectory directory];
        _dataFilePath = [cachesDirectory stringByAppendingPathComponent:TELEMETRY_FILE_NAME];
        
        _viewInputsToScrub = [NSMutableSet new];
        
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
        captureLog = shouldCapture;
    });
}

/**
 * Sets max number of telemetry events to capture.
 */
- (void)setDataLimit:(NSInteger)dataLimit {
    dispatch_async(queue, ^{
        self->_limit = dataLimit;
        [self truncateDataArray];
    });
}

- (void)truncateDataArray {
    if (@available(iOS 10.0, macOS 10.12, *)) {
        dispatch_assert_queue_debug(queue);
    }
    if (_limit > 0 && _dataArray.count > _limit) {
        [_dataArray removeObjectsInRange:NSMakeRange(0, _dataArray.count - _limit)];
    }
}

#pragma mark -

- (void)recordEventForLevel:(RollbarLevel)level
                       type:(RollbarTelemetryType)type
                       data:(NSDictionary *)data {
    
    if (!_enabled) {
        return;
    }
    
    NSTimeInterval timestamp = NSDate.date.timeIntervalSince1970 * 1000.0;
    NSString *telemetryLvl = RollbarStringFromLevel(level);
    NSString *telemetryType = RollbarStringFromTelemetryType(type);
    NSDictionary *info = @{@"level": telemetryLvl,
                           @"type": telemetryType,
                           @"source": @"client",
                           @"timestamp_ms": [NSString stringWithFormat:@"%.0f", round(timestamp)],
                           @"body": data
                           };

    dispatch_async(queue, ^{
        [self->_dataArray addObject:info];
        [self truncateDataArray];
        NSData *data = [self serializedDataArray];
        dispatch_async(fileQueue, ^{
            [self saveTelemetryData:data];
        });
    });
}

#pragma mark -

- (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element
                      extraData:(NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    // check if the extradata needs some scrubbing based on the element name:
    __block BOOL needsScrubbing = false;
    [_viewInputsToScrub enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if( [element caseInsensitiveCompare:obj] == NSOrderedSame ) {
            needsScrubbing = true;
            *stop = YES;
        }
    }];
    // scrub the extradata as needed:
    if (needsScrubbing) {
        for (NSString * key in data)
        {
            [data setValue:@"[scrubbed]" forKey:key];
        }
    }
    // add the element name:
    [data setObject:element forKey:@"element"];

    [self recordEventForLevel:level type:RollbarTelemetryView data:data];
}

#pragma mark -

- (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode
                         extraData:(NSDictionary *)extraData {
    
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

- (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status
                              extraData:(NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:status forKey:@"change"];

    [self recordEventForLevel:level type:RollbarTelemetryConnectivity data:data];
}

#pragma mark -

- (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message
                       extraData:(NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:message forKey:@"message"];

    [self recordEventForLevel:level type:RollbarTelemetryError data:data];
}

#pragma mark -

- (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to
                            extraData:(NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [data setObject:from forKey:@"from"];
    [data setObject:to forKey:@"to"];

    [self recordEventForLevel:level type:RollbarTelemetryNavigation data:data];
}

#pragma mark -

- (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }

    [self recordEventForLevel:level type:RollbarTelemetryManual data:data];
}

#pragma mark -

- (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message
                     extraData:(NSDictionary *)extraData {
    
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
        dataCopy = [self->_dataArray copy];
    });
    return dataCopy;
}

- (void)clearAllData {
    dispatch_async(queue, ^{
        [self->_dataArray removeAllObjects];
        NSData *data = [self serializedDataArray];
        dispatch_async(fileQueue, ^{
            [self saveTelemetryData:data];
        });
    });
}

#pragma mark - Data storage

// This is used for getting a read-only copy of our shared dataArray
// which can later be written to a file. This method must be called
// on the internal queue to serialize the dataArray read, but the result
// is free to be used anywhere
- (NSData *)serializedDataArray {
    if (@available(iOS 10.0, macOS 10.12, *)) {
        dispatch_assert_queue_debug(queue);
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:_dataArray
                                                   options:0
                                                     error:nil
                                                      safe:true];
    return data;
}

- (void)saveTelemetryData:(NSData *)data {
    if (@available(iOS 10.0, macOS 10.12, *)) {
        dispatch_assert_queue_debug(fileQueue);
    }
    [data writeToFile:_dataFilePath atomically:true];
}

// This must only be called in init, calls to this method at any other time
// would present a race condition because dataArray is modified without
// protecting which thread/queue we are being called from
- (void)loadTelemetryData {
    if ([[NSFileManager defaultManager] fileExistsAtPath:_dataFilePath]) {
        NSData *data = [NSData dataWithContentsOfFile:_dataFilePath];
        if (data) {
            NSArray *telemetryDataList = [NSJSONSerialization JSONObjectWithData:data
                                                                         options:NSJSONReadingMutableContainers
                                                                           error:nil];
            if (telemetryDataList) {
                _dataArray = [telemetryDataList mutableCopy];
            }
        }
    }
}

@end
