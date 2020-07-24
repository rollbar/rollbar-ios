//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import RollbarCommon;

#import "RollbarLogger.h"
#import "RollbarThread.h"
#import "RollbarReachability.h"
#if TARGET_OS_IPHONE
    #import <UIKit/UIKit.h>
#endif
#import <sys/utsname.h>
//#import "KSCrash.h"
#import "RollbarTelemetry.h"
#import "RollbarPayloadTruncator.h"
#import "RollbarConfiguration.h"

#import "RollbarPayloadDTOs.h"

#define MAX_PAYLOAD_SIZE 128 // The maximum payload size in kb

static NSString *QUEUED_ITEMS_FILE_NAME = @"rollbar.items";
static NSString *STATE_FILE_NAME = @"rollbar.state";
static NSString *PAYLOADS_FILE_NAME = @"rollbar.payloads";

// Rollbar API Service enforced payload rate limit:
static NSString *RESPONSE_HEADER_RATE_LIMIT = @"x-rate-limit-limit";
// Rollbar API Service enforced remaining payload count until the limit is reached:
static NSString *RESPONSE_HEADER_REMAINING_COUNT = @"x-rate-limit-remaining";
// Rollbar API Service enforced rate limit reset time for the current limit window:
static NSString *RESPONSE_HEADER_RESET_TIME = @"x-rate-limit-reset";
// Rollbar API Service enforced rate limit remaining seconds of the current limit window:
static NSString *RESPONSE_HEADER_REMAINING_SECONDS = @"x-rate-limit-remaining-seconds";

static NSUInteger MAX_RETRY_COUNT = 5;

static NSString *queuedItemsFilePath = nil;
static NSString *stateFilePath = nil;
static NSMutableDictionary *queueState = nil;
static NSString *payloadsFilePath = nil;

static RollbarThread *rollbarThread = nil;
static RollbarReachability *reachability = nil;
static BOOL isNetworkReachable = YES;

@interface RollbarLogger ()

- (NSThread *)_rollbarThread;

- (void)_test_doNothing;

@end

#define IS_IOS7_OR_HIGHER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)
#define IS_MACOS10_10_OR_HIGHER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber10_10)

@implementation RollbarLogger {
    NSDate *nextSendTime;
    
    @private
    NSDictionary *m_osData;
}

- (instancetype)initWithAccessToken:(NSString*)accessToken
                      configuration:(RollbarConfiguration*)configuration
                             isRoot:(BOOL)isRoot {
    
    if ((self = [super init])) {
        [self updateAccessToken:accessToken
                  configuration:configuration
                         isRoot:isRoot];
        
        if (isRoot) {
            
            // make sure we have all the expected data directories/folder set:
            
            NSString *cachesDirectory = [RollbarCachesDirectory directory];
            if (nil != self.configuration.logPayloadFile
                && self.configuration.logPayloadFile.length > 0) {
                
                payloadsFilePath =
                [cachesDirectory stringByAppendingPathComponent:self.configuration.logPayloadFile];
            }
            else {
                
                payloadsFilePath =
                [cachesDirectory stringByAppendingPathComponent:PAYLOADS_FILE_NAME];
            }
            
            // create working cache directory:
            if (![[NSFileManager defaultManager] fileExistsAtPath:cachesDirectory]) {
                NSError *error;
                BOOL result =
                [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectory
                                          withIntermediateDirectories:YES
                                                           attributes:nil
                                                                error:&error
                 ];
                NSLog(@"result %@", result);
            }
            
            // make sure we have all the data files set:
            
            queuedItemsFilePath =
            [cachesDirectory stringByAppendingPathComponent:QUEUED_ITEMS_FILE_NAME];
            stateFilePath =
            [cachesDirectory stringByAppendingPathComponent:STATE_FILE_NAME];
            
            // either create or overwrite the payloads log file:
            [[NSFileManager defaultManager] createFileAtPath:payloadsFilePath
                                                    contents:nil
                                                  attributes:nil];
            
            // create the queued items file if does not exist already:
            if (![[NSFileManager defaultManager] fileExistsAtPath:queuedItemsFilePath]) {
                [[NSFileManager defaultManager] createFileAtPath:queuedItemsFilePath
                                                        contents:nil
                                                      attributes:nil];
            }
            
            // create state tracking file if does not exist already:
            if ([[NSFileManager defaultManager] fileExistsAtPath:stateFilePath]) {
                NSData *stateData = [NSData dataWithContentsOfFile:stateFilePath];
                if (stateData) {
                    NSDictionary *state = [NSJSONSerialization JSONObjectWithData:stateData
                                                                          options:0
                                                                            error:nil];
                    queueState = [state mutableCopy];
                } else {
                    RollbarSdkLog(@"There was an error restoring saved queue state");
                }
            }
            if (!queueState) {
                queueState = [@{@"offset": [NSNumber numberWithUnsignedInt:0],
                                @"retry_count": [NSNumber numberWithUnsignedInt:0]} mutableCopy];
                [self saveQueueState];
            }
            
            // Setup the worker thread
            // that sends the items that have been queued up in the item file set above:
            
            rollbarThread = [[RollbarThread alloc] initWithNotifier:self
                                                      reportingRate:configuration.maximumReportsPerMinute];
            [rollbarThread start];
            
            // Listen for reachability status
            // so that the items are only sent when the internet is available
            
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

        self->nextSendTime = [[NSDate alloc] init];
    }

    return self;
}

- (void)logCrashReport:(NSString*)crashReport {

    RollbarConfig *config = self.configuration.asRollbarConfig;
    RollbarPayload *payload = [self buildRollbarPayloadWithLevel:config.loggingOptions.crashLevel
                                                         message:nil
                                                       exception:nil
                                                           error:nil
                                                           extra:nil
                                                     crashReport:crashReport
                                                         context:nil];
    if (payload) {
        [self queuePayload:payload.jsonFriendlyData];
    }
}

- (void)log:(NSString*)level
    message:(NSString*)message
  exception:(NSException*)exception
       data:(NSDictionary*)data
    context:(NSString*) context {
    
    if (!self.configuration.enabled) {
        return;
    }
    
    RollbarConfig *config = self.configuration.asRollbarConfig;
    
    RollbarLevel rollbarLevel = [RollbarLevelUtil RollbarLevelFromString:level];
    if (rollbarLevel < config.loggingOptions.logLevel) {
        return;
    }

    RollbarPayload *payload = [self buildRollbarPayloadWithLevel:rollbarLevel
                                                         message:message
                                                       exception:exception
                                                           error:nil
                                                           extra:data
                                                     crashReport:nil
                                                         context:context
                               ];
    if (payload) {
        [self queuePayload:payload.jsonFriendlyData];
    }
}

- (void)saveQueueState {
    NSError *error;
    NSData *data = [NSJSONSerialization rollbar_dataWithJSONObject:queueState
                                                   options:0
                                                     error:&error
                                                      safe:true];
    if (error) {
        RollbarSdkLog(@"Error: %@", [error localizedDescription]);
    }
    [data writeToFile:stateFilePath atomically:YES];
}

- (void)processSavedItems {
    
    if (!isNetworkReachable) {
        RollbarSdkLog(@"Processing saved items: no network!");
        // Don't attempt sending if the network is known to be not reachable
        return;
    }

    NSUInteger startOffset = [queueState[@"offset"] unsignedIntegerValue];

    NSFileHandle *fileHandle =
    [NSFileHandle fileHandleForReadingAtPath:queuedItemsFilePath];
    [fileHandle seekToEndOfFile];
    __block unsigned long long fileLength = [fileHandle offsetInFile];
    [fileHandle closeFile];

    if (!fileLength) {
        RollbarSdkLog(@"Processing saved items: no queued items in the file!");
        return;
    }

    // Empty out the queued item file if all items have been processed already
    if (startOffset == fileLength) {
        [@"" writeToFile:queuedItemsFilePath
              atomically:YES
                encoding:NSUTF8StringEncoding
                   error:nil];

        queueState[@"offset"] = [NSNumber numberWithUnsignedInteger:0];
        queueState[@"retry_count"] = [NSNumber numberWithUnsignedInteger:0];
        [self saveQueueState];
        RollbarSdkLog(@"Processing saved items: emptied the queued items file.");

        return;
    }

    // Iterate through the items file and send the items in batches.
    RollbarFileReader *reader =
    [[RollbarFileReader alloc] initWithFilePath:queuedItemsFilePath
                                      andOffset:startOffset];
    [reader enumerateLinesUsingBlock:^(NSString *line, NSUInteger nextOffset, BOOL *stop) {
        NSData *lineData = [line dataUsingEncoding:NSUTF8StringEncoding];
        if (!lineData) {
            // All we can do is ignore this line
            RollbarSdkLog(@"Error converting file line to NSData: %@", line);
            return;
        }
        NSError *error;
        NSJSONReadingOptions serializationOptions = (NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves);
        NSDictionary *payload = [NSJSONSerialization JSONObjectWithData:lineData
                                                                options:serializationOptions
                                                                  error:&error];

        if (!payload) {
            // Ignore this line if it isn't valid json and proceed to the next line
            RollbarSdkLog(@"Error restoring data from file to JSON: %@", lineData);
            return;
        }

        BOOL shouldContinue = [self sendItem:payload nextOffset:nextOffset];

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

    }];
}

#pragma mark - Payload DTO builders

-(RollbarPerson *)buildRollbarPerson {
    
    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (config && config.person && config.person.ID) {
        return config.person;
    }
    else {
        return nil;
    }
}

-(RollbarServer *)buildRollbarServer {
    
    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (config && config.server && !config.server.isEmpty) {
        return [[RollbarServer alloc] initWithCpu:nil
                                     serverConfig:config.server];
    }
    else {
        return nil;
    }
}

-(NSDictionary *)buildOSData {
    
    if (self->m_osData) {
        return self->m_osData;
    }
    
    NSBundle *mainBundle = [NSBundle mainBundle];
    
    NSString *version = nil;
    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (config
        && config.loggingOptions
        && config.loggingOptions.codeVersion
        && config.loggingOptions.codeVersion.length > 0) {
        
        version = config.loggingOptions.codeVersion;
    }
    else {
        version = [mainBundle objectForInfoDictionaryKey:(NSString*)kCFBundleVersionKey];
    }
    
    NSString *shortVersion = [mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *bundleName = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleNameKey];
    NSString *bundleIdentifier = [mainBundle objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceCode = [NSString stringWithCString:systemInfo.machine
                                              encoding:NSUTF8StringEncoding];
    
#if TARGET_OS_IPHONE
    self->m_osData = @{
        @"os": @"iOS",
        @"os_version": [[UIDevice currentDevice] systemVersion],
        @"device_code": deviceCode,
        @"code_version": version ? version : @"",
        @"short_version": shortVersion ? shortVersion : @"",
        @"bundle_identifier": bundleIdentifier ? bundleIdentifier : @"",
        @"app_name": bundleName ? bundleName : @""
    };
#else
    NSOperatingSystemVersion osVer = [[NSProcessInfo processInfo] operatingSystemVersion];
    self->m_osData = @{
        @"os": @"macOS",
        @"os_version": [NSString stringWithFormat:@" %tu.%tu.%tu",
                        osVer.majorVersion,
                        osVer.minorVersion,
                        osVer.patchVersion
                        ],
        @"device_code": deviceCode,
        @"code_version": version ? version : @"",
        @"short_version": shortVersion ? shortVersion : @"",
        @"bundle_identifier": bundleIdentifier ? bundleIdentifier : @"",
        @"app_name": bundleName ? bundleName : [[NSProcessInfo processInfo] processName]
    };
#endif

    return self->m_osData;
}

-(RollbarClient *)buildRollbarClient {
    
    NSNumber *timestamp = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];

    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (config && config.loggingOptions) {
        switch(config.loggingOptions.captureIp) {
            case RollbarCaptureIpType_Full:
                return [[RollbarClient alloc] initWithDictionary:@{
                    @"timestamp": timestamp,
                    @"ios": [self buildOSData],
                    @"user_ip": @"$remote_ip"
                }];
            case RollbarCaptureIpType_Anonymize:
                return [[RollbarClient alloc] initWithDictionary:@{
                    @"timestamp": timestamp,
                    @"ios": [self buildOSData],
                    @"user_ip": @"$remote_ip_anonymize"
                }];
            case RollbarCaptureIpType_None:
                //no op
                break;
        }
    }

    return [[RollbarClient alloc] initWithDictionary:@{
        @"timestamp": timestamp,
        @"ios": [self buildOSData],
    }];
}

-(RollbarModule *)buildRollbarNotifierModule {

    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (config && config.notifier && !config.notifier.isEmpty) {
        
        RollbarModule *notifierModule =
        [[RollbarModule alloc] initWithDictionary:config.notifier.jsonFriendlyData.copy];
        [notifierModule setData:config.jsonFriendlyData byKey:@"configured_options"];
        return notifierModule;
    }
    
    return nil;
}

-(RollbarPayload *)buildRollbarPayloadWithLevel:(RollbarLevel)level
                                 message:(NSString*)message
                               exception:(NSException*)exception
                                   error:(NSError *)error
                                   extra:(NSDictionary*)extra
                             crashReport:(NSString*)crashReport
                                 context:(NSString*)context {

    // check critical config settings:
    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (!config
        || !config.destination
        || !config.destination.environment
        || config.destination.environment.length == 0) {
        
        return nil;
    }

    // compile payload data proper body:
    RollbarBody *body = [RollbarBody alloc];
    if (crashReport) {
        body = [body initWithCrashReport:crashReport];
    }
    else if (error) {
        body = [body initWithError:error];
    }
    else if (exception) {
        body = [body initWithException:exception];
    }
    else if (message) {
        body = [body initWithMessage:message];
    }
    else {
        return nil;
    }
    
    if (!body) {
        return nil;
    }
    
    // this is done only for backward campatibility for customers that used to rely on this undocumented
    // extra data with a message:
    if (message && extra) {
        [body.message setData:extra byKey:@"extra"];
    }
    

    // compile payload data:
    RollbarData *data = [[RollbarData alloc] initWithEnvironment:config.destination.environment
                                                            body:body];
    if (!data) {
        return nil;
    }
    
    NSMutableDictionary *customData =
        [NSMutableDictionary dictionaryWithDictionary:self.configuration.customData];
    if (crashReport || exception) {
        // neither crash report no exception payload objects have placeholders for any extra data
        // or an extra message, let's preserve them as the custom data:
        if (extra) {
            customData[@"error.extra"] = extra;
        }
        if (message && message.length > 0) {
            customData[@"error.message"] = message;
        }
    }

    data.level = level;
    data.language = RollbarAppLanguage_ObjectiveC;
    data.platform = @"client";
    data.uuid = [NSUUID UUID];
    data.custom = [[RollbarDTO alloc] initWithDictionary:customData];
    data.notifier = [self buildRollbarNotifierModule];
    data.person = [self buildRollbarPerson];
    data.server = [self buildRollbarServer];
    data.client = [self buildRollbarClient];
    if (context && context.length > 0) {
        data.context = context;
    }
    if (config.loggingOptions) {
        data.framework = config.loggingOptions.framework;
        if (config.loggingOptions.requestId
            && (config.loggingOptions.requestId.length > 0)) {

            [data setData:config.loggingOptions.requestId byKey:@"requestId"];
        }
    }
    
    // Transform payload data, if necessary
    if ([self shouldIgnoreRollbarData:data]) {
        return nil;
    }
    data = [self modifyRollbarData:data];
    data = [self scrubRollbarData:data];

    RollbarPayload *payload = [[RollbarPayload alloc] initWithAccessToken:config.destination.accessToken
                                                                     data:data];

    return payload;
}

-(BOOL)shouldIgnoreRollbarData:(nonnull RollbarData *)incomingData {

    BOOL shouldIgnore = NO;

    // This block of code is using deprecated legacy implementation of payload check-ignore:
    if (self.configuration.checkIgnore) {
        @try {
            shouldIgnore = self.configuration.checkIgnore(incomingData.jsonFriendlyData);
            return shouldIgnore;
        } @catch(NSException *e) {
            RollbarSdkLog(@"checkIgnore error: %@", e.reason);

            // Remove checkIgnore to prevent future exceptions
            [self.configuration setCheckIgnoreBlock:nil];
            return NO;
        }
    }

    if (self.configuration.checkIgnoreRollbarData) {
        @try {
            shouldIgnore = self.configuration.checkIgnoreRollbarData(incomingData);
            return shouldIgnore;
        } @catch(NSException *e) {
            RollbarSdkLog(@"checkIgnore error: %@", e.reason);

            // Remove checkIgnore to prevent future exceptions
            self.configuration.checkIgnoreRollbarData = nil;
            return NO;
        }
    }

    return shouldIgnore;
}

-(RollbarData *)modifyRollbarData:(nonnull RollbarData *)incomingData {

    // This block of code is using deprecated legacy implementation of payload modification:
    if (self.configuration.payloadModification) {
        NSMutableDictionary * jsonFriendlyMutableData = incomingData.jsonFriendlyData;
        self.configuration.payloadModification(jsonFriendlyMutableData);
        RollbarData *modifiedRollbarData = [[RollbarData alloc] initWithDictionary:jsonFriendlyMutableData];
        return modifiedRollbarData;
    }

    if (self.configuration.modifyRollbarData) {
        return self.configuration.modifyRollbarData(incomingData);
    }
    return incomingData;
}

-(RollbarData *)scrubRollbarData:(nonnull RollbarData *)incomingData {

    NSSet *scrubFieldsSet = [self getScrubFields];
    if (!scrubFieldsSet || scrubFieldsSet.count == 0) {
        return incomingData;
    }
    
    NSMutableDictionary *mutableJsonFriendlyData = incomingData.jsonFriendlyData.mutableCopy;
    for (NSString *key in scrubFieldsSet) {
        if ([mutableJsonFriendlyData valueForKeyPath:key]) {
            [self createMutablePayloadWithData:mutableJsonFriendlyData forPath:key];
            [mutableJsonFriendlyData setValue:@"*****" forKeyPath:key];
        }
    }

    return [[RollbarData alloc] initWithDictionary:mutableJsonFriendlyData];
}

-(NSSet *)getScrubFields {
    
    RollbarConfig *config = self.configuration.asRollbarConfig;
    if (!config
        || !config.dataScrubber
        || config.dataScrubber.isEmpty
        || !config.dataScrubber.enabled
        || !config.dataScrubber.scrubFields
        || config.dataScrubber.scrubFields.count == 0) {
        
        return [NSSet set];
    }
    
    NSMutableSet *actualFieldsToScrub = config.dataScrubber.scrubFields.mutableCopy;
    if (config.dataScrubber.safeListFields.count > 0) {
        // actualFieldsToScrub =
        // config.dataScrubber.scrubFields - config.dataScrubber.whitelistFields
        // while using case insensitive field name comparison:
        actualFieldsToScrub = [NSMutableSet new];
        for(NSString *key in config.dataScrubber.scrubFields) {
            BOOL isWhitelisted = false;
            for (NSString *whiteKey in config.dataScrubber.safeListFields) {
                if (NSOrderedSame == [key caseInsensitiveCompare:whiteKey]) {
                    isWhitelisted = true;
                }
            }
            if (!isWhitelisted) {
                [actualFieldsToScrub addObject:key];
            }
        }
    }
    
    return actualFieldsToScrub;
}

#pragma mark - LEGACY payload data builders

- (void)queuePayload:(NSDictionary*)payload {
    [self performSelector:@selector(queuePayload_OnlyCallOnThread:)
                 onThread:rollbarThread
               withObject:payload
            waitUntilDone:NO
     ];
}

//- (void)queuePayload_OnlyCallOnThread:(NSDictionary *)payload {
//    NSFileHandle *fileHandle =
//    [NSFileHandle fileHandleForWritingAtPath:queuedItemsFilePath];
//    [fileHandle seekToEndOfFile];
//    NSError *error = nil;
//    [fileHandle writeData:[NSJSONSerialization rollbar_dataWithJSONObject:payload
//                                                          options:0
//                                                            error:&error
//                                                             safe:true]];
//    if (error) {
//        RollbarSdkLog(@"Error: %@", [error localizedDescription]);
//    }
//    [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
//    [fileHandle closeFile];
//    [[RollbarTelemetry sharedInstance] clearAllData];
//}

- (BOOL)sendItem:(NSDictionary*)payload
       nextOffset:(NSUInteger)nextOffset {
    
    RollbarPayload *rollbarPayload =
    [[RollbarPayload alloc] initWithDictionary:[payload copy]];
    
    NSMutableDictionary *newPayload =
    [NSMutableDictionary dictionaryWithDictionary:payload];
    [RollbarPayloadTruncator truncatePayload:newPayload];

    NSData *jsonPayload = [NSJSONSerialization rollbar_dataWithJSONObject:newPayload
                                                          options:0
                                                            error:nil
                                                             safe:true];
    
    if (NSOrderedDescending != [nextSendTime compare: [[NSDate alloc] init] ]) {
        
        NSUInteger retryCount =
        [queueState[@"retry_count"] unsignedIntegerValue];

        if (0 == retryCount && YES == self.configuration.logPayload) {
            RollbarSdkLog(@"About to send payload: %@",
                       [[NSString alloc] initWithData:jsonPayload
                                             encoding:NSUTF8StringEncoding]
                       );

            // append-save this jsonPayload into the payloads log file:
            NSFileHandle *fileHandle =
            [NSFileHandle fileHandleForWritingAtPath:payloadsFilePath];
            
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:jsonPayload];
            [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [fileHandle closeFile];
        }
        
        RollbarConfig *rollbarConfig =
        [[RollbarConfig alloc] initWithDictionary:rollbarPayload.data.notifier.jsonFriendlyData[@"configured_options"]];
        
        BOOL success =
        rollbarConfig ? [self sendPayload:jsonPayload usingConfig:rollbarConfig]
        : [self sendPayload:jsonPayload]; // backward compatibility with just upgraded very old SDKs...
        
        if (!success) {
            if (retryCount < MAX_RETRY_COUNT) {
                queueState[@"retry_count"] =
                [NSNumber numberWithUnsignedInteger:retryCount + 1];
                
                [self saveQueueState];
                
                // Return NO so that the current batch will be retried next time
                return NO;
            }
        }
    }
    else {
        RollbarSdkLog(
            @"Omitting payload until nextSendTime is reached: %@",
            [[NSString alloc] initWithData:jsonPayload encoding:NSUTF8StringEncoding]
        );
    }
    
    queueState[@"offset"] = [NSNumber numberWithUnsignedInteger:nextOffset];
    queueState[@"retry_count"] = [NSNumber numberWithUnsignedInteger:0];
    [self saveQueueState];
    
    return YES;
}

- (BOOL)sendPayload:(nonnull NSData*)payload
        usingConfig:(nonnull RollbarConfig*)config {
    
    NSURL *url = [NSURL URLWithString:config.destination.endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:config.destination.accessToken forHTTPHeaderField:@"X-Rollbar-Access-Token"];
    [request setHTTPBody:payload];

    if (YES == config.developerOptions.logPayload) {
        NSString *payloadString = [[NSString alloc]initWithData:payload
                                                       encoding:NSUTF8StringEncoding
                                   ];
        NSLog(@"%@", payloadString);
        //TODO: if config.developerOptions.logPayloadFile is defined, save the payload into the file...
    }

    if (NO == config.developerOptions.transmit) {
        return YES; // we just successfully shortcircuit here...
    }

    __block BOOL result = NO;
#if TARGET_OS_IPHONE
    if (IS_IOS7_OR_HIGHER) {
#else
    if (IS_MACOS10_10_OR_HIGHER) {
#endif
        // This requires iOS 7.0+
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);

        NSURLSession *session = [NSURLSession sharedSession];

        if (config.httpProxy.enabled
            || config.httpsProxy.enabled) {

            NSDictionary *connectionProxyDictionary =
            @{
              @"HTTPEnable"   : [NSNumber numberWithBool:config.httpProxy.enabled],
              @"HTTPProxy"    : config.httpProxy.proxyUrl,
              @"HTTPPort"     : [NSNumber numberWithUnsignedInteger:config.httpProxy.proxyPort],
              @"HTTPSEnable"  : [NSNumber numberWithBool:config.httpsProxy.enabled],
              @"HTTPSProxy"   : config.httpsProxy.proxyUrl,
              @"HTTPSPort"    : [NSNumber numberWithUnsignedInteger:config.httpsProxy.proxyPort]
              };

            NSURLSessionConfiguration *sessionConfig =
            [NSURLSessionConfiguration ephemeralSessionConfiguration];
            sessionConfig.connectionProxyDictionary = connectionProxyDictionary;
            session = [NSURLSession sessionWithConfiguration:sessionConfig];
        }

        NSURLSessionDataTask *dataTask =
            [session dataTaskWithRequest:request
                       completionHandler:^(
                                           NSData * _Nullable data,
                                           NSURLResponse * _Nullable response,
                                           NSError * _Nullable error) {
                result = [self checkPayloadResponse:response
                                              error:error
                                               data:data];
                dispatch_semaphore_signal(sem);
            }];
        [dataTask resume];

        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // Using method sendSynchronousRequest, deprecated since iOS 9.0
        NSError *error;
        NSHTTPURLResponse *response;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
#pragma clang diagnostic pop
        result = [self checkPayloadResponse:response
                                      error:error
                                       data:data];
    }

    return result;
}

/// This is a DEPRECATED method left for some backward compatibility for very old clients eventually moving to this more recent implementation.
/// Use/maintain sendPayload:usingConfig: instead!
- (BOOL)sendPayload:(NSData*)payload {
    
    NSURL *url = [NSURL URLWithString:self.configuration.endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.configuration.accessToken forHTTPHeaderField:@"X-Rollbar-Access-Token"];
    [request setHTTPBody:payload];

    if (YES == self.configuration.logPayload) {
        NSString *payloadString = [[NSString alloc]initWithData:payload
                                                       encoding:NSUTF8StringEncoding
                                   ];
        NSLog(@"%@", payloadString);
        //TODO: if self.configuration.logPayloadFile is defined, save the payload into the file...
    }

    if (NO == self.configuration.transmit) {
        return YES; // we just successfully shortcircuit here...
    }

    __block BOOL result = NO;
#if TARGET_OS_IPHONE
    if (IS_IOS7_OR_HIGHER) {
#else
    if (IS_MACOS10_10_OR_HIGHER) {
#endif
        // This requires iOS 7.0+
        dispatch_semaphore_t sem = dispatch_semaphore_create(0);

        NSURLSession *session = [NSURLSession sharedSession];

        if (self.configuration.httpProxyEnabled
            || self.configuration.httpsProxyEnabled) {

            NSDictionary *connectionProxyDictionary =
            @{
              @"HTTPEnable"   : [NSNumber numberWithInt:self.configuration.httpProxyEnabled],
              @"HTTPProxy"    : self.configuration.httpProxy,
              @"HTTPPort"     : self.configuration.httpProxyPort,
              @"HTTPSEnable"  : [NSNumber numberWithInt:self.configuration.httpsProxyEnabled],
              @"HTTPSProxy"   : self.configuration.httpsProxy,
              @"HTTPSPort"    : self.configuration.httpsProxyPort
              };

            NSURLSessionConfiguration *sessionConfig =
            [NSURLSessionConfiguration ephemeralSessionConfiguration];
            sessionConfig.connectionProxyDictionary = connectionProxyDictionary;
            session = [NSURLSession sessionWithConfiguration:sessionConfig];
        }

        NSURLSessionDataTask *dataTask =
            [session dataTaskWithRequest:request
                       completionHandler:^(
                                           NSData * _Nullable data,
                                           NSURLResponse * _Nullable response,
                                           NSError * _Nullable error) {
                result = [self checkPayloadResponse:response
                                              error:error
                                               data:data];
                dispatch_semaphore_signal(sem);
            }];
        [dataTask resume];

        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    } else {
        // Using method sendSynchronousRequest, deprecated since iOS 9.0
        NSError *error;
        NSHTTPURLResponse *response;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSData *data = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:&response
                                                         error:&error];
#pragma clang diagnostic pop
        result = [self checkPayloadResponse:response
                                      error:error
                                       data:data];
    }

    return result;
}

- (BOOL)checkPayloadResponse:(NSURLResponse*)response
                       error:(NSError*)error
                        data:(NSData*)data {

    // Lookup rate limiting headers and afjust reporting rate accordingly:
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    NSDictionary *httpHeaders = [httpResponse allHeaderFields];
    //int rateLimit = [[httpHeaders valueForKey:RESPONSE_HEADER_RATE_LIMIT] intValue];
    int rateLimitLeft =
        [[httpHeaders valueForKey:RESPONSE_HEADER_REMAINING_COUNT] intValue];
    int rateLimitSeconds =
        [[httpHeaders valueForKey:RESPONSE_HEADER_REMAINING_SECONDS] intValue];
    if (rateLimitLeft > 0) {
        nextSendTime = [[NSDate alloc] init];
    }
    else {
        nextSendTime =
        [[NSDate alloc] initWithTimeIntervalSinceNow:rateLimitSeconds];
    }

    if (error) {
        RollbarSdkLog(@"There was an error reporting to Rollbar");
        RollbarSdkLog(@"Error: %@", [error localizedDescription]);
    } else {
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        if ([httpResponse statusCode] == 200) {
            RollbarSdkLog(@"Success");
            return YES;
        } else {
            RollbarSdkLog(@"There was a problem reporting to Rollbar");
            if (data) {
                RollbarSdkLog(
                           @"Response: %@",
                           [NSJSONSerialization JSONObjectWithData:data
                                                           options:0
                                                             error:nil]);
            }
        }
    }
    return NO;
}

#pragma mark - Payload truncate

- (void)createMutablePayloadWithData:(NSMutableDictionary *)data
                             forPath:(NSString *)path {
                                 
    NSArray *pathComponents = [path componentsSeparatedByString:@"."];
    NSString *currentPath = @"";

    for (int i=0; i<pathComponents.count; i++) {
        NSString *part = pathComponents[i];
        currentPath = i == 0 ? part
            : [NSString stringWithFormat:@"%@.%@", currentPath, part];
        id val = [data valueForKeyPath:currentPath];
        if (!val) return;
        if ([val isKindOfClass:[NSArray class]]
            && ![val isKindOfClass:[NSMutableArray class]]) {
            
            NSMutableArray *newVal = [NSMutableArray arrayWithArray:val];
            [data setValue:newVal forKeyPath:currentPath];
        } else if ([val isKindOfClass:[NSDictionary class]]
                   && ![val isKindOfClass:[NSMutableDictionary class]]) {
            
            NSMutableDictionary *newVal =
            [NSMutableDictionary dictionaryWithDictionary:val];
            [data setValue:newVal forKeyPath:currentPath];
        }
    }
}

#pragma mark - Payload transformations

//// Run data through custom payload modification method if available
//- (void)modifyPayload:(NSMutableDictionary *)data {
//
//    if (self.configuration.payloadModification) {
//        self.configuration.payloadModification(data);
//    }
//}

//// Determine if this payload should be ignored
//- (BOOL)shouldIgnorePayload:(NSDictionary*)data {
//
//    BOOL shouldIgnore = false;
//
//    if (self.configuration.checkIgnore) {
//        @try {
//            shouldIgnore = self.configuration.checkIgnore(data);
//        } @catch(NSException *e) {
//            RollbarSdkLog(@"checkIgnore error: %@", e.reason);
//
//            // Remove checkIgnore to prevent future exceptions
//            [self.configuration setCheckIgnoreBlock:nil];
//        }
//    }
//
//    return shouldIgnore;
//}

//// Scrub specified fields from payload
//- (void)scrubPayload:(NSMutableDictionary*)data {
//
//    if (self.configuration.scrubFields.count == 0) {
//        return;
//    }
//
//    NSMutableSet *actualFieldsToScrub = self.configuration.scrubFields.mutableCopy;
//    if (self.configuration.scrubSafeListFields.count > 0) {
//        // actualFieldsToScrub =
//        // self.configuration.scrubFields - self.configuration.scrubWhitelistFields
//        // while using case insensitive field name comparison:
//        actualFieldsToScrub = [NSMutableSet new];
//        for(NSString *key in self.configuration.scrubFields) {
//            BOOL isSafelisted = false;
//            for (NSString *safeKey in self.configuration.scrubSafeListFields) {
//                if (NSOrderedSame == [key caseInsensitiveCompare:safeKey]) {
//                    isSafelisted = true;
//                }
//            }
//            if (!isSafelisted) {
//                [actualFieldsToScrub addObject:key];
//            }
//        }
//    }
//
//    for (NSString *key in actualFieldsToScrub) {
//        if ([data valueForKeyPath:key]) {
//            [self createMutablePayloadWithData:data forPath:key];
//            [data setValue:@"*****" forKeyPath:key];
//        }
//    }
//}

#pragma mark - Update configuration methods

- (void)updateAccessToken:(NSString*)accessToken
            configuration:(RollbarConfiguration *)configuration
                   isRoot:(BOOL)isRoot {
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

- (void)updateConfiguration:(RollbarConfiguration *)configuration
                     isRoot:(BOOL)isRoot {
    NSString *currentAccessToken = self.configuration.accessToken;
    [self updateAccessToken:currentAccessToken
              configuration:configuration
                     isRoot:isRoot];
}

- (void)updateAccessToken:(NSString*)accessToken {
    self.configuration.accessToken = accessToken;
}

- (void)updateReportingRate:(NSUInteger)maximumReportsPerMinute {
    if (nil != self.configuration) {
        self.configuration.maximumReportsPerMinute = maximumReportsPerMinute;
    }
    if (nil != rollbarThread) {
        [rollbarThread cancel];
        rollbarThread =
        [[RollbarThread alloc] initWithNotifier:self
                                  reportingRate:maximumReportsPerMinute];
        [rollbarThread start];
    }
}
    
#pragma mark - Network telemetry data

- (void)captureTelemetryDataForNetwork:(BOOL)reachable {
    if (self.configuration.shouldCaptureConnectivity
        && isNetworkReachable != reachable) {
        NSString *status = reachable ? @"Connected" : @"Disconnected";
        NSString *networkType = @"Unknown";
        NetworkStatus networkStatus = [reachability currentReachabilityStatus];
        if (networkStatus == ReachableViaWiFi) {
            networkType = @"WiFi";
        }
        else if (networkStatus == ReachableViaWWAN) {
            networkType = @"Cellular";
        }
        [[RollbarTelemetry sharedInstance]
         recordConnectivityEventForLevel:RollbarLevel_Warning
                                  status:status
                               extraData:@{@"network": networkType}];
    }
}

// THIS IS ONLY FOR TESTS, DO NOT ACTUALLY USE THIS METHOD, HENCE BEING "PRIVATE"
- (NSThread *)_rollbarThread {
    return rollbarThread;
}

- (void)_test_doNothing {
}

@end
