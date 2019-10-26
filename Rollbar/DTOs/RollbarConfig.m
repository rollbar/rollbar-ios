//
//  RollbarConfig.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-11.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarConfig.h"
#import "DataTransferObject+Protected.h"
#import "RollbarCachesDirectory.h"
#import "RollbarDestination.h"
#import "RollbarDeveloperOptions.h"
#import "RollbarProxy.h"
#import "RollbarScrubbingOptions.h"
#import "RollbarServer.h"
#import "RollbarPerson.h"
#import "RollbarModule.h"
#import "RollbarTelemetryOptions.h"
#import "RollbarTelemetryOptions.h"
#import <Foundation/Foundation.h>

#pragma mark - constants

static NSString * const NOTIFIER_VERSION = @"1.9.0";

#define NOTIFIER_NAME_PREFIX = @"rollbar-";
#if TARGET_OS_IPHONE
static NSString * const OPERATING_SYSTEM = @"ios";
static NSString * const NOTIFIER_NAME = @"rollbar-ios";
#else
static NSString * const OPERATING_SYSTEM = @"macos";
static NSString * const NOTIFIER_NAME = @"rollbar-macos";
#endif

static NSString * const CONFIGURATION_FILENAME = @"rollbar.config";

#pragma mark - static data

static NSString *configurationFilePath = nil;

#pragma mark - data fields

static NSString * const DFK_DESTINATION = @"destination";
static NSString * const DFK_DEVELOPER_OPTIONS = @"developerOptions";
static NSString * const DFK_DATA_SCRUBBER = @"dataScrubber";
static NSString * const DFK_HTTP_PROXY = @"httpProxy";
static NSString * const DFK_HTTPS_PROXY = @"httpsProxy";
static NSString * const DFK_SERVER = @"server";
static NSString * const DFK_PERSON = @"person";
static NSString * const DFK_NOTIFIER = @"notifier";
static NSString * const DFK_TELEMETRY = @"telemetry";



static NSString * const DATAFIELD_CRASH_LEVEL = @"crashLevel";
static NSString * const DATAFIELD_LOG_LEVEL = @"logLevel";
static NSString * const DATAFIELD_MAX_REPORTS_PER_MINUTE = @"maximumReportsPerMinute";
static NSString * const DATAFIELD_SHOULD_CAPTURE_CONNECTIVITY = @"shouldCaptureConnectivity";

static NSString * const DATAFIELD_IP_CAPTURE_TYPE = @"captureIp";

static NSString * const DATAFIELD_CODE_VERSION = @"codeVersion";

static NSString * const DATAFIELD_FRAMEWORK = @"framework";

static NSString * const DATAFIELD_REQUEST_ID = @"requestId";

static NSString * const DATAFIELD_CUSTOM_DATA = @"customData";

#pragma mark - class implementation

@implementation RollbarConfig

#pragma mark - initializers

- (id)init {
    if (!configurationFilePath) {
        NSString *cachesDirectory = [RollbarCachesDirectory directory];
        configurationFilePath = [cachesDirectory stringByAppendingPathComponent:CONFIGURATION_FILENAME];
    }

    if (self = [super init]) {
        //self.customData = [NSMutableDictionary dictionaryWithCapacity:10];
        self.destination = [RollbarDestination new];
        self.developerOptions = [RollbarDeveloperOptions new];
        self.httpProxy = [RollbarProxy new];
        self.httpsProxy = [RollbarProxy new];


        self.crashLevel = @"error";
        //self.scrubFields = @[@"one", @"two"]; //NSMutableSet setWithCapacity:3];
        //self.scrubWhitelistFields =  @[@"one", @"two"]; //[NSMutableSet setWithCapacity:3];
        //self.telemetryViewInputsToScrub = @[@"one", @"two"];//[NSMutableSet setWithCapacity:3];

        self.notifier.name = NOTIFIER_NAME;
        self.notifier.version = NOTIFIER_VERSION;
        self.framework = OPERATING_SYSTEM;
        self.captureIp = CaptureIpFull;
        
        self.logLevel = RollbarInfo;

        self.telemetry.enabled = NO;
        self.telemetry.captureLog = NO;
        self.maximumReportsPerMinute = 60;
        
//        self.httpProxyEnabled = NO;
//        self.httpProxy = @"";
//        self.httpProxyPort = [NSNumber numberWithInteger:0];
//
//        self.httpsProxyEnabled = NO;
//        self.httpsProxy = @"";
//        self.httpsProxyPort = [NSNumber numberWithInteger:0];

        //[self save];
    }

    return self;
}


#pragma mark - Rollbar destination

- (RollbarDestination *)destination {
    id data = [self safelyGetDictionaryByKey:DFK_DESTINATION];
    id dto = [[RollbarDestination alloc] initWithDictionary:data];
    return dto;
}

- (void)setDestination:(RollbarDestination *)destination {
    [self setDataTransferObject:destination forKey:DFK_DESTINATION];
}

#pragma mark - Developer options

- (RollbarDeveloperOptions *)developerOptions {
    id data = [self safelyGetDictionaryByKey:DFK_DEVELOPER_OPTIONS];
    return [[RollbarDeveloperOptions alloc] initWithDictionary:data];
}

- (void)setDeveloperOptions:(RollbarDeveloperOptions *)developerOptions {
    [self setDataTransferObject:developerOptions forKey:DFK_DEVELOPER_OPTIONS];
}

#pragma mark - Notifier

- (RollbarModule *)notifier {
    id data = [self safelyGetDictionaryByKey:DFK_NOTIFIER];
    return [[RollbarModule alloc] initWithDictionary:data];
}

- (void)setNotifier:(RollbarModule *)developerOptions {
    [self setDataTransferObject:developerOptions forKey:DFK_NOTIFIER];
}

#pragma mark - Data scrubber

- (RollbarScrubbingOptions *)dataScrubber {
    id data = [self safelyGetDictionaryByKey:DFK_DATA_SCRUBBER];
    return [[RollbarScrubbingOptions alloc] initWithDictionary:data];
}

- (void)setDataScrubber:(RollbarScrubbingOptions *)value {
    [self setDataTransferObject:value forKey:DFK_DATA_SCRUBBER];
}

#pragma mark - Server

- (RollbarServer *)server {
    id data = [self safelyGetDictionaryByKey:DFK_SERVER];
    return [[RollbarServer alloc] initWithDictionary:data];
}

- (void)setServer:(RollbarServer *)value {
    [self setDataTransferObject:value forKey:DFK_SERVER];
}

#pragma mark - Person

- (RollbarPerson *)person {
    id data = [self safelyGetDictionaryByKey:DFK_PERSON];
    return [[RollbarPerson alloc] initWithDictionary:data];
}

- (void)setPerson:(RollbarPerson *)value {
    [self setDataTransferObject:value forKey:DFK_PERSON];
}

#pragma mark - HTTP Proxy Settings

- (RollbarProxy *)httpProxy {
    id data = [self safelyGetDictionaryByKey:DFK_HTTP_PROXY];
    return [[RollbarProxy alloc] initWithDictionary:data];
}

- (void)setHttpProxy:(RollbarProxy *)value {
    [self setDataTransferObject:value forKey:DFK_HTTP_PROXY];
}

#pragma mark - HTTPS Proxy Settings

- (RollbarProxy *)httpsProxy {
    id data = [self safelyGetDictionaryByKey:DFK_HTTPS_PROXY];
    return [[RollbarProxy alloc] initWithDictionary:data];
}

- (void)setHttpsProxy:(RollbarProxy *)value {
    [self setDataTransferObject:value forKey:DFK_HTTPS_PROXY];
}

#pragma mark - Telemetry

- (RollbarTelemetryOptions *)telemetry {
    id data = [self safelyGetDictionaryByKey:DFK_TELEMETRY];
    return [[RollbarTelemetryOptions alloc] initWithDictionary:data];
}

- (void)setTelemetry:(RollbarTelemetryOptions *)value {
    [self setDataTransferObject:value forKey:DFK_TELEMETRY];
}


#pragma mark - Logging Options

- (NSString *)crashLevel {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_CRASH_LEVEL];
    return result;
}

- (void)setCrashLevel:(NSString *)value {
    [self setString:value forKey:DATAFIELD_CRASH_LEVEL];
}

- (RollbarLevel)logLevel {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_LOG_LEVEL];
    return [RollbarLevelUtil RollbarLevelFromString:result];
}

- (void)setLogLevel:(RollbarLevel)value {
    [self setString:[RollbarLevelUtil RollbarLevelToString:value]
             forKey:DATAFIELD_LOG_LEVEL];
}

- (NSUInteger)maximumReportsPerMinute {
    NSUInteger result = [[self safelyGetNumberByKey:DATAFIELD_MAX_REPORTS_PER_MINUTE] unsignedIntegerValue];
    return result;
}

- (void)setMaximumReportsPerMinute:(NSUInteger)value {
    [self setNumber:[[NSNumber alloc] initWithUnsignedInteger:value] forKey:DATAFIELD_MAX_REPORTS_PER_MINUTE];
}

- (BOOL)shouldCaptureConnectivity {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_SHOULD_CAPTURE_CONNECTIVITY];
    return [result boolValue];
}

- (void)setShouldCaptureConnectivity:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_SHOULD_CAPTURE_CONNECTIVITY];
}

#pragma mark - Payload Content Related

- (void)setCaptureIp:(CaptureIpType)value {
    [self setString:[[CaptureIpTypeUtil CaptureIpTypeToString:value] mutableCopy]
          forKey:DATAFIELD_IP_CAPTURE_TYPE];
}

#pragma mark - Code version

- (NSString *)codeVersion {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_CODE_VERSION];
    return result;
}

- (void)setCodeVersion:(NSString *)value {
    [self setString:value forKey:DATAFIELD_CODE_VERSION];
}

#pragma mark - Request (an ID to link request between client/server)

- (NSString *)requestId {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_REQUEST_ID];
    return result;
}

- (void)setRequestId:(NSString *)value {
    [self setString:value forKey:DATAFIELD_REQUEST_ID];
}

#pragma mark - Convenience Methods

- (void)setPersonId:(NSString*)personId
           username:(NSString*)username
              email:(NSString*)email {
    self.person.ID = personId;
    self.person.username = username;
    self.person.email = email;
}

- (void)setServerHost:(NSString *)host
                 root:(NSString*)root
               branch:(NSString*)branch
          codeVersion:(NSString*)codeVersion {
    self.server.host = host;
    self.server.root = root;
    self.server.branch = branch;
    self.server.codeVersion = codeVersion;
}

- (void)setNotifierName:(NSString *)name
                version:(NSString *)version {
    self.notifier.name = name;
    self.notifier.version = version;
}

#pragma mark - Custom data

- (NSDictionary *)customData {
    NSMutableDictionary *result = [self safelyGetDictionaryByKey:DATAFIELD_CUSTOM_DATA];
    return result;
}

- (void)setCustomData:(NSDictionary *)value {
    [self setDictionary:value forKey:DATAFIELD_CUSTOM_DATA];
}

@end
