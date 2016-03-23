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


static NSString *NOTIFIER_VERSION = @"0.1.6";
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

@implementation RollbarNotifier

- (id)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration isRoot:(BOOL)isRoot {
    
    if ((self = [super init])) {
        if (configuration) {
            self.configuration = configuration;
        } else {
            self.configuration = [RollbarConfiguration configuration];
        }
        
        self.configuration.accessToken = accessToken;
        
        if (isRoot) {
            [self.configuration _setRoot];
            
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
                isNetworkReachable = YES;
            };
            
            reachability.unreachableBlock = ^(RollbarReachability*reach) {
                isNetworkReachable = NO;
            };
            
            [reachability startNotifier];
        }
    }
    
    return self;
}

- (void)logCrashReport:(NSString*)crashReport {
    NSDictionary *payload = [self buildPayloadWithLevel:self.configuration.crashLevel message:nil exception:nil extra:nil crashReport:crashReport];
    
    [self queuePayload:payload];
}

- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    NSDictionary *payload = [self buildPayloadWithLevel:level message:message exception:exception extra:data crashReport:nil];
    
    [self queuePayload:payload];
}

- (void)saveQueueState {
    NSData *data = [NSJSONSerialization dataWithJSONObject:queueState options:0 error:nil];
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
                              @"code_version": version,
                              @"short_version": shortVersion,
                              @"bundle_identifier": bundleIdentifier,
                              @"app_name": bundleName};
    
    NSDictionary *data = @{@"timestamp": timestamp,
                           @"ios": iosData,
                           @"user_ip": @"$remote_ip"};
    
    return data;
}

- (NSDictionary*)buildPayloadWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra crashReport:(NSString*)crashReport {
    
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

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra crashReport:(NSString*)crashReport {
    if (crashReport) {
        return [self buildPayloadBodyWithCrashReport:crashReport];
    } else {
        return [self buildPayloadBodyWithMessage:message extra:extra];
    }
}

- (void)queuePayload:(NSDictionary*)payload {
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:queuedItemsFilePath];
    [fileHandle seekToEndOfFile];
    [fileHandle writeData:[NSJSONSerialization dataWithJSONObject:payload options:0 error:nil]];
    [fileHandle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandle closeFile];
}

- (BOOL)sendItems:(NSArray*)itemData withAccessToken:(NSString*)accessToken nextOffset:(NSUInteger)nextOffset {
    NSDictionary *newPayload = @{@"access_token": accessToken,
                                 @"data": itemData};
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:newPayload options:0 error:nil];
    
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
    
    NSError *error;
    NSHTTPURLResponse *response;
    
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
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
        
@end
