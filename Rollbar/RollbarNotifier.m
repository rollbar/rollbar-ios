//
//  RollbarNotifier.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "RollbarNotifier.h"
#import "RollbarThread.h"
#import "RollbarFileReader.h"
#import "RollbarReachability.h"
#import "RollbarLogger.h"
#import <UIKit/UIKit.h>
#include <sys/utsname.h>
#import "NSJSONSerialization+Rollbar.h"
#import <KSCrash/KSCrash.h>
#import "RollbarTelemetry.h"

#define MAX_PAYLOAD_SIZE 128 // The maximum payload size in kb

static NSString *NOTIFIER_VERSION = @"0.2.0";
static NSString *QUEUED_ITEMS_FILE_NAME = @"rollbar.items";
static NSString *STATE_FILE_NAME = @"rollbar.state";

static NSUInteger MAX_RETRY_COUNT = 5;
static NSUInteger MAX_BATCH_SIZE = 10;

static NSString *queuedItemsFilePath = nil;
static NSString *stateFilePath = nil;
static NSMutableDictionary *queueState = nil;

static RollbarThread *rollbarThread = nil;
static RollbarReachability *reachability = nil;
static BOOL isNetworkReachable = YES;

#define IS_IOS7_OR_HIGHER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

@implementation RollbarNotifier

- (id)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration isRoot:(BOOL)isRoot {
    
    if ((self = [super init])) {
        [self updateAccessToken:accessToken configuration:configuration isRoot:isRoot];

        if (isRoot) {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *cachesDirectory = [paths objectAtIndex:0];
            queuedItemsFilePath = [cachesDirectory stringByAppendingPathComponent:QUEUED_ITEMS_FILE_NAME];
            stateFilePath = [cachesDirectory stringByAppendingPathComponent:STATE_FILE_NAME];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:queuedItemsFilePath]) {
                [[NSFileManager defaultManager] createFileAtPath:queuedItemsFilePath contents:nil attributes:nil];
            }
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:stateFilePath]) {
                NSData *stateData = [NSData dataWithContentsOfFile:stateFilePath];
                NSDictionary *state = [NSJSONSerialization JSONObjectWithData:stateData options:0 error:nil];
                
                queueState = [state mutableCopy];
            } else {
                queueState = [@{@"offset": [NSNumber numberWithUnsignedInt:0],
                                @"retry_count": [NSNumber numberWithUnsignedInt:0]} mutableCopy];
            }
            
            // Deals with sending items that have been queued up
            rollbarThread = [[RollbarThread alloc] initWithNotifier:self];
            [rollbarThread start];
            
            // Listen for reachability status so that items are only sent when the internet is available
            reachability = [RollbarReachability reachabilityForInternetConnection];
            
            isNetworkReachable = [reachability isReachable];
            
            reachability.reachableBlock = ^(RollbarReachability*reach) {
                [self captureTelemetryDataForNetwork:true];
                isNetworkReachable = YES;
            };
            
            reachability.unreachableBlock = ^(RollbarReachability*reach) {
                [self captureTelemetryDataForNetwork:false];
                isNetworkReachable = NO;
            };
            
            [reachability startNotifier];
        }
    }
    
    return self;
}

- (void)logCrashReport:(NSString*)crashReport {
    NSDictionary *payload = [self buildPayloadWithLevel:self.configuration.crashLevel message:nil exception:nil extra:nil crashReport:crashReport context:nil];
    if (payload) {
        [self queuePayload:payload];
    }
}

- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*) context {
    NSDictionary *payload = [self buildPayloadWithLevel:level message:message exception:exception extra:data crashReport:nil context:context];
    if (payload) {
        [self queuePayload:payload];
    }
}

- (void)saveQueueState {
    NSData *data = [NSJSONSerialization dataWithJSONObject:queueState options:0 error:nil safe:true];
    [data writeToFile:stateFilePath atomically:YES];
}

- (void)processSavedItems {
    if (!isNetworkReachable) {
        // Don't attempt sending if the network is known to be not reachable
        return;
    }
    
    __block NSString *lastAccessToken = nil;
    NSMutableArray *items = [NSMutableArray array];

    NSUInteger startOffset = [queueState[@"offset"] unsignedIntegerValue];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForReadingAtPath:queuedItemsFilePath];
    [fileHandle seekToEndOfFile];
    __block unsigned long long fileLength = [fileHandle offsetInFile];
    [fileHandle closeFile];
    
    if (!fileLength) {
        return;
    }
    
    // Empty out the queued item file if all items have been processed already
    if (startOffset == fileLength) {
        [@"" writeToFile:queuedItemsFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        
        queueState[@"offset"] = [NSNumber numberWithUnsignedInteger:0];
        queueState[@"retry_count"] = [NSNumber numberWithUnsignedInteger:0];
        [self saveQueueState];
        
        return;
    }
    
    // Iterate through the items file and send the items in batches.
    RollbarFileReader *reader = [[RollbarFileReader alloc] initWithFilePath:queuedItemsFilePath andOffset:startOffset];
    [reader enumerateLinesUsingBlock:^(NSString *line, NSUInteger nextOffset, BOOL *stop) {
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:[line dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        
        if (!payload) {
            // Ignore this line if it isn't valid json and proceed to the next line
            // TODO: report an internal error
            return;
        }
        
        NSString *accessToken = payload[@"access_token"];
        
        // If the max batch size is reached as the file is being processed,
        // try sending the current batch before starting a new one
        if ([items count] >= MAX_BATCH_SIZE || (lastAccessToken != nil && [accessToken compare:lastAccessToken] != NSOrderedSame)) {
            BOOL shouldContinue = [self sendItems:items withAccessToken:lastAccessToken nextOffset:nextOffset];
            
            if (!shouldContinue) {
                // Stop processing the file so that the current file offset will be
                // retried next time the file is processed
                *stop = YES;
                return;
            }
            
            // The file has had items added since we started iterating through it,
            // update the known file length to equal the next offset
            if (nextOffset > fileLength) {
                fileLength = nextOffset;
            }
            
            [items removeAllObjects];
        }
        
        [items addObject:payload[@"data"]];
        
        lastAccessToken = accessToken;
    }];
    
    // The whole file has been read, send all of the pending items
    if ([items count]) {
        [self sendItems:items withAccessToken:lastAccessToken nextOffset:(NSUInteger)fileLength];
    }
}

- (NSDictionary*)buildPersonData {
    NSMutableDictionary *personData = [NSMutableDictionary dictionary];
    
    if (self.configuration.personId) {
        personData[@"id"] = self.configuration.personId;
    }
    if (self.configuration.personUsername) {
        personData[@"username"] = self.configuration.personUsername;
    }
    if (self.configuration.personEmail) {
        personData[@"email"] = self.configuration.personEmail;
    }
    
    if ([[personData allKeys] count]) {
        return personData;
    }
    
    return nil;
}

- (NSDictionary*)buildOptionalData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];

    // Add client/server linking ID
    if (self.configuration.requestId) {
        [data setObject:self.configuration.requestId forKey:@"requestId"];
    }

    // Add server data
    NSDictionary *serverData = [self buildServerData];

    if (serverData) {
        [data setObject:serverData forKey:@"server"];
    }

    if ([[data allKeys] count]) {
        return data;
    }

    return nil;
}

- (NSDictionary*)buildServerData {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];

    if (self.configuration.serverHost) {
        data[@"host"] = self.configuration.serverHost;
    }
    if (self.configuration.serverRoot) {
        data[@"root"] = self.configuration.serverRoot;
    }
    if (self.configuration.serverBranch) {
        data[@"branch"] = self.configuration.serverBranch;
    }
    if (self.configuration.serverCodeVersion) {
        data[@"code_version"] = self.configuration.serverCodeVersion;
    }

    if ([[data allKeys] count]) {
        return data;
    }

    return nil;
}

- (NSDictionary*)buildClientData {
    NSNumber *timestamp = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
    ;
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *version = [mainBundle objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    NSString *shortVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *bundleName = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    NSString *bundleIdentifier = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceCode = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *iosData = @{@"ios_version": [[UIDevice currentDevice] systemVersion],
                              @"device_code": deviceCode,
                              @"code_version": version ? version : @"",
                              @"short_version": shortVersion ? shortVersion : @"",
                              @"bundle_identifier": bundleIdentifier ? bundleIdentifier : @"",
                              @"app_name": bundleName ? bundleName : @""};
    
    NSDictionary *data = @{@"timestamp": timestamp,
                           @"ios": iosData,
                           @"user_ip": @"$remote_ip"};
    
    return data;
}

- (NSDictionary*)buildPayloadWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra crashReport:(NSString*)crashReport context:(NSString*)context {
    
    NSDictionary *clientData = [self buildClientData];
    NSDictionary *notifierData = @{@"name": @"rollbar-ios",
                                   @"version": NOTIFIER_VERSION};
    
    NSDictionary *customData = self.configuration.customData;
    
    NSDictionary *body = [self buildPayloadBodyWithMessage:message exception:exception extra:extra crashReport:crashReport];
    
    NSMutableDictionary *data = [@{@"environment": self.configuration.environment,
                                   @"level": level,
                                   @"language": @"objective-c",
                                   @"framework": @"ios",
                                   @"platform": @"ios",
                                   @"uuid": [self generateUUID],
                                   @"client": clientData,
                                   @"notifier": notifierData,
                                   @"custom": customData,
                                   @"body": body} mutableCopy];
    
    NSDictionary *personData = [self buildPersonData];
    
    if (personData) {
        data[@"person"] = personData;
    }

    NSDictionary *optionalData = [self buildOptionalData];

    if (optionalData) {
        [data addEntriesFromDictionary:optionalData];
    }

    if (context) {
        data[@"context"] = context;
    }

    // Transform payload, if necessary
    [self modifyPayload:data];
    [self scrubPayload:data];
    if ([self shouldIgnorePayload:data]) {
        return nil;
    }

    return @{@"access_token": self.configuration.accessToken,
             @"data": data};
}

- (NSDictionary*)buildPayloadBodyWithCrashReport:(NSString*)crashReport {
    return @{@"crash_report": @{@"raw": crashReport}};
}

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message extra:(NSDictionary*)extra {
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    result[@"body"] = message ? message : @"";
    
    if (extra) {
        result[@"extra"] = extra;
    }
    
    return @{@"message": result};
}

- (NSDictionary*)buildPayloadBodyWithException:(NSException*)exception {
    NSDictionary *exceptionInfo = @{@"class": NSStringFromClass([exception class]), @"message": exception.reason, @"description": exception.description};
    NSMutableArray *frames = [NSMutableArray array];
    for (NSString *line in exception.callStackSymbols) {
        NSMutableArray *components =  [NSMutableArray arrayWithArray:[line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]]];
        [components removeObject:@""];
        [components removeObjectAtIndex:0];
        if (components.count >= 4) {
            NSString *method = [self methodNameFromStackTrace:components];
            NSString *filename = [components componentsJoinedByString:@" "];
            [frames addObject:@{@"library": components[0], @"filename": filename, @"address": components[1], @"lineno": components[components.count-1], @"method": method}];
        }
    }
    
    return @{@"trace": @{@"frames": frames, @"exception": exceptionInfo}};
}

- (NSString*)methodNameFromStackTrace:(NSArray*)stackTraceComponents {
    int start = false;
    NSString *buf;
    for (NSString *component in stackTraceComponents) {
        if (!start && [component hasPrefix:@"0x"]) {
            start = true;
        } else if (start && [component isEqualToString:@"+"]) {
            break;
        } else if (start) {
            buf = buf ? [NSString stringWithFormat:@"%@ %@", buf, component] : component;
        }
    }
    return buf ? buf : @"Unknown";
}

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra crashReport:(NSString*)crashReport {
    NSDictionary *payloadBody;
    if (crashReport) {
        payloadBody = [self buildPayloadBodyWithCrashReport:crashReport];
    } else if (exception) {
        payloadBody = [self buildPayloadBodyWithException:exception];
    } else {
        payloadBody = [self buildPayloadBodyWithMessage:message extra:extra];
    }
    
    NSArray *telemetryData = [[RollbarTelemetry sharedInstance] getAllData];
    if (payloadBody && telemetryData.count > 0) {
        NSMutableDictionary *newPayloadBody = nil;
        newPayloadBody = [NSMutableDictionary dictionaryWithDictionary:payloadBody];
        [newPayloadBody setObject:telemetryData forKey:@"telemetry"];
        return newPayloadBody;
    }
    
    return payloadBody;
}

- (void)queuePayload:(NSDictionary*)payload {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:queuedItemsFilePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil safe:true]];
    [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
    [[RollbarTelemetry sharedInstance] clearAllData];
}

- (BOOL)sendItems:(NSArray*)itemData withAccessToken:(NSString*)accessToken nextOffset:(NSUInteger)nextOffset {
    NSMutableArray *payloadItems = [NSMutableArray array];
    for (NSDictionary *item in itemData) {
        NSMutableDictionary *newItem = [NSMutableDictionary dictionaryWithDictionary:item];
        [self truncatePayloadIfNecessary:newItem];
        [payloadItems addObject:newItem];
    }
    NSMutableDictionary *newPayload = [NSMutableDictionary dictionaryWithDictionary:@{@"access_token": accessToken, @"data": payloadItems}];
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:newPayload options:0 error:nil safe:true];
    
    BOOL success = [self sendPayload:jsonPayload];
    if (!success) {
        NSUInteger retryCount = [queueState[@"retry_count"] unsignedIntegerValue];
        
        if (retryCount < MAX_RETRY_COUNT) {
            queueState[@"retry_count"] = [NSNumber numberWithUnsignedInteger:retryCount + 1];
            [self saveQueueState];
            
            // Return NO so that the current batch will be retried next time
            return NO;
        }
    }
    
    queueState[@"offset"] = [NSNumber numberWithUnsignedInteger:nextOffset];
    queueState[@"retry_count"] = [NSNumber numberWithUnsignedInteger:0];
    [self saveQueueState];
    
    return YES;
}

- (BOOL)sendPayload:(NSData*)payload {
    NSURL *url = [NSURL URLWithString:self.configuration.endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.configuration.accessToken forHTTPHeaderField:@"X-Rollbar-Access-Token"];
    [request setHTTPBody:payload];

    __block BOOL result = NO;
    if (IS_IOS7_OR_HIGHER) {
        // This requires iOS 7.0+
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);
        NSURLSessionDataTask *dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            result = [self checkPayloadResponse:response error:error data:data];
            dispatch_semaphore_signal(sem);
        }];
        [dataTask resume];
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // Using method sendSynchronousRequest, deprecated since iOS 9.0
        NSError *error;
        NSHTTPURLResponse *response;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        result = [self checkPayloadResponse:response error:error data:data];
    }
    
    return result;
}

- (BOOL)checkPayloadResponse:(NSURLResponse*)response error:(NSError*)error data:(NSData*)data {
    if (error) {
        RollbarLog(@"There was an error reporting to Rollbar");
        RollbarLog(@"Error: %@", [error localizedDescription]);
    } else {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] == 200) {
            RollbarLog(@"Success");
            return YES;
        } else {
            RollbarLog(@"There was a problem reporting to Rollbar");
            RollbarLog(@"Response: %@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
        }
    }
    return NO;
}

- (NSString*)generateUUID {
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *string = (__bridge_transfer NSString*)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    return string;
}

#pragma mark - Payload truncate

- (void)createMutablePayloadWithData:(NSMutableDictionary *)data forPath:(NSString *)path {
    NSArray *pathComponents = [path componentsSeparatedByString:@"."];
    NSString *currentPath = @"";

    for (int i=0; i<pathComponents.count; i++) {
        NSString *part = pathComponents[i];
        currentPath = i == 0 ? part : [NSString stringWithFormat:@"%@.%@", currentPath, part];
        id val = [data valueForKeyPath:currentPath];
        if (!val) return;
        if ([val isKindOfClass:[NSArray class]] && ![val isKindOfClass:[NSMutableArray class]]) {
            NSMutableArray *newVal = [NSMutableArray arrayWithArray:val];
            [data setValue:newVal forKeyPath:currentPath];
        } else if ([val isKindOfClass:[NSDictionary class]] && ![val isKindOfClass:[NSMutableDictionary class]]) {
            NSMutableDictionary *newVal = [NSMutableDictionary dictionaryWithDictionary:val];
            [data setValue:newVal forKeyPath:currentPath];
        }
    }
}

- (void)truncatePayload:(NSMutableDictionary *)data forKeyPath:(NSString *)keypath {
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil safe:true];
    NSInteger dataSize = jsonPayload.length * 0.001;

    if (dataSize <= MAX_PAYLOAD_SIZE) {
        return;
    }

    [self createMutablePayloadWithData:data forPath:keypath];
    NSMutableArray *array = [data valueForKeyPath:keypath];
    [data setValue:@[] forKeyPath:keypath];

    jsonPayload = [NSJSONSerialization dataWithJSONObject:data options:0 error:nil safe:true];
    NSInteger sizeDiff = dataSize - jsonPayload.length * 0.001;

    double sizePerItem = sizeDiff / (double)array.count;
    if (dataSize - sizeDiff + (sizePerItem * 2) >= MAX_PAYLOAD_SIZE) {
        // Not enough to truncate, will do the best we can
    } else {
        // Cut the number of items necessary from the middle
        NSInteger truncateCnt = (dataSize - MAX_PAYLOAD_SIZE) / sizePerItem;
        NSInteger start = array.count / 2 - truncateCnt / 2;
        [array removeObjectsInRange:NSMakeRange(start, truncateCnt)];
    }

    [data setValue:array forKeyPath:keypath];
}

- (void)truncatePayloadIfNecessary:(NSMutableDictionary *)data {
    NSArray *keyPaths = @[@"body.message.extra.crash.threads", @"body.trace.frames"];

    for (NSString *keyPath in keyPaths) {
        NSArray *obj = [data valueForKeyPath:keyPath];
        if (obj) {
            [self truncatePayload:data forKeyPath:keyPath];
            break;
        }
    }
}

#pragma mark - Payload transformations

// Run data through custom payload modification method if available
- (void)modifyPayload:(NSMutableDictionary *)data {
    if (self.configuration.payloadModification) {
        self.configuration.payloadModification(data);
    }
}

// Determine if this payload should be ignored
- (BOOL)shouldIgnorePayload:(NSDictionary*)data {
    BOOL shouldIgnore = false;

    if (self.configuration.checkIgnore) {
        @try {
            shouldIgnore = self.configuration.checkIgnore(data);
        } @catch(NSException *e) {
            RollbarLog(@"checkIgnore error: %@", e.reason);

            // Remove checkIgnore to prevent future exceptions
            [self.configuration setCheckIgnore:nil];
        }
    }

    return shouldIgnore;
}

// Scrub specified fields from payload
- (void)scrubPayload:(NSMutableDictionary*)data {
    if (self.configuration.scrubFields.count == 0) {
        return;
    }

    for (NSString *key in self.configuration.scrubFields) {
        if ([data valueForKeyPath:key]) {
            [data setValue:@"*****" forKeyPath:key];
        }
    }
}

#pragma mark - Update configuration methods

- (void)updateAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration *)configuration isRoot:(BOOL)isRoot {
    if (configuration) {
        self.configuration = configuration;
    } else {
        self.configuration = [RollbarConfiguration configuration];
    }

    [self updateAccessToken:accessToken];

    if (isRoot) {
        [self.configuration _setRoot];
    }
}

- (void)updateConfiguration:(RollbarConfiguration *)configuration isRoot:(BOOL)isRoot {
    NSString *currentAccessToken = self.configuration.accessToken;
    [self updateAccessToken:currentAccessToken configuration:configuration isRoot:isRoot];
}

- (void)updateAccessToken:(NSString*)accessToken {
    self.configuration.accessToken = accessToken;
}

#pragma mark - Network telemetry data

- (void)captureTelemetryDataForNetwork:(BOOL)reachable {
    if (self.configuration.shouldCaptureConnectivity && isNetworkReachable != reachable) {
        NSString *status = reachable ? @"Connected" : @"Disconnected";
        NSString *networkType = @"Unknown";
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus == ReachableViaWiFi) {
            networkType = @"WiFi";
        }
        else if (networkStatus == ReachableViaWWAN) {
            networkType = @"Cellular";
        }
        [[RollbarTelemetry sharedInstance] recordConnectivityEventForLevel:RollbarWarning status:status extraData:@{@"network": networkType}];
    }
}

@end
