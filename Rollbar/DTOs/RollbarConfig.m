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
static NSString * const DFK_HTTP_PROXY = @"httpProxy";
static NSString * const DFK_HTTPS_PROXY = @"httpsProxy";
//static NSString * const DATAFIELD_DESTINATION_ACCESS_TOKEN = @"accessToken";
//static NSString * const DATAFIELD_DESTINATION_ENVIRONMENT = @"environment";
//static NSString * const DATAFIELD_DESTINATION_ENDPOINT = @"endpoint";

//static NSString * const DATAFIELD_ENABLED = @"enabled";
//static NSString * const DATAFIELD_TRANSMIT = @"transmit";
//static NSString * const DATAFIELD_LOGPAYLOAD = @"logPayload";
//static NSString * const DATAFIELD_LOGPAYLOADFILE = @"logPayloadFile";

//static NSString * const DATAFIELD_HTTP_PROXY_ENABLED = @"httpProxyEnabled";
//static NSString * const DATAFIELD_HTTP_PROXY = @"httpProxy";
//static NSString * const DATAFIELD_HTTP_PROXY_PORT = @"httpProxyPort";
//
//static NSString * const DATAFIELD_HTTPS_PROXY_ENABLED = @"httpsProxyEnabled";
//static NSString * const DATAFIELD_HTTPS_PROXY = @"httpsProxy";
//static NSString * const DATAFIELD_HTTPS_PROXY_PORT = @"httpsProxyPort";

static NSString * const DATAFIELD_CRASH_LEVEL = @"crashLevel";
static NSString * const DATAFIELD_LOG_LEVEL = @"logLevel";
static NSString * const DATAFIELD_MAX_REPORTS_PER_MINUTE = @"maximumReportsPerMinute";
static NSString * const DATAFIELD_SHOULD_CAPTURE_CONNECTIVITY = @"shouldCaptureConnectivity";

static NSString * const DATAFIELD_SCRUB_FIELDS = @"scrubFields";
static NSString * const DATAFIELD_SCRUB_FIELDS_WHITE_LIST = @"scrubFieldsWhiteList";
static NSString * const DATAFIELD_IP_CAPTURE_TYPE = @"captureIp";

static NSString * const DATAFIELD_TELEMETRY_ENABLED = @"telemetryEnabled";
static NSString * const DATAFIELD_TELEMETRY_SCRUB_VIEW_INPUTS = @"scrubViewInputsTelemetry";
static NSString * const DATAFIELD_TELEMETRY_SCRUB_VIEW_INPUTS_FIELDS = @"telemetryViewInputsToScrub";

static NSString * const DATAFIELD_CODE_VERSION = @"codeVersion";

static NSString * const DATAFIELD_SERVER_HOST = @"serverHost";
static NSString * const DATAFIELD_SERVER_ROOT = @"serverRoot";
static NSString * const DATAFIELD_SERVER_BRANCH = @"serverBranch";
static NSString * const DATAFIELD_SERVER_CODE_VERSION = @"serverCodeVersion";

static NSString * const DATAFIELD_NOTIFIER_NAME = @"notifierName";
static NSString * const DATAFIELD_NOTIFIER_VERSION = @"notifierVersion";
static NSString * const DATAFIELD_FRAMEWORK = @"framework";

static NSString * const DATAFIELD_PERSON_ID = @"personId";
static NSString * const DATAFIELD_PERSON_USERNAME = @"personUsername";
static NSString * const DATAFIELD_PERSON_EMAIL = @"personEmail";

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

        self.notifierName = NOTIFIER_NAME;
        self.notifierVersion = NOTIFIER_VERSION;
        self.framework = OPERATING_SYSTEM;
        self.captureIp = CaptureIpFull;
        
        self.logLevel = RollbarInfo;

        self.telemetryEnabled = NO;
        self.maximumReportsPerMinute = 60;
        [self setCaptureLogAsTelemetryData:NO];
        
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
    id dto = [[RollbarDestination alloc] initWithDictionary:data];;
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

- (NSSet *)scrubFields {
    NSSet *result = [self safelyGetSetByKey:DATAFIELD_SCRUB_FIELDS];
    return result;
}

- (void)setScrubFields:(NSSet *)value {
    [self setSet:value forKey:DATAFIELD_SCRUB_FIELDS];
}

- (NSSet *)scrubWhitelistFields {
    NSSet *result = [self safelyGetSetByKey:DATAFIELD_SCRUB_FIELDS_WHITE_LIST];
    return result;
}

- (void)setScrubWhitelistFields:(NSSet *)value {
    [self setSet:value forKey:DATAFIELD_SCRUB_FIELDS_WHITE_LIST];
}

- (CaptureIpType)captureIp {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_IP_CAPTURE_TYPE];
    return [CaptureIpTypeUtil CaptureIpTypeFromString:result];
}

- (void)setCaptureIp:(CaptureIpType)value {
    [self setSet:[[CaptureIpTypeUtil CaptureIpTypeToString:value] mutableCopy]
          forKey:DATAFIELD_IP_CAPTURE_TYPE];
}

#pragma mark - Telemetry

- (BOOL)telemetryEnabled {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_TELEMETRY_ENABLED];
    return [result boolValue];
}

- (void)setTelemetryEnabled:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_TELEMETRY_ENABLED];
}

- (BOOL)scrubViewInputsTelemetry {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_TELEMETRY_SCRUB_VIEW_INPUTS];
    return [result boolValue];
}

- (void)setScrubViewInputsTelemetry:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_TELEMETRY_SCRUB_VIEW_INPUTS];
}

- (NSMutableSet *)telemetryViewInputsToScrub {
    NSMutableSet *result = [self safelyGetSetByKey:DATAFIELD_TELEMETRY_SCRUB_VIEW_INPUTS_FIELDS];
    return result;
}

- (void)setTelemetryViewInputsToScrub:(NSMutableSet *)value {
    [self setSet:value forKey:DATAFIELD_TELEMETRY_SCRUB_VIEW_INPUTS_FIELDS];
}

#pragma mark - Code version

- (NSString *)codeVersion {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_CODE_VERSION];
    return result;
}

- (void)setCodeVersion:(NSString *)value {
    [self setString:value forKey:DATAFIELD_CODE_VERSION];
}

#pragma mark - Server

- (NSString *)serverHost {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_SERVER_HOST];
    return result;
}

- (void)setServerHost:(NSString *)value {
    [self setString:value forKey:DATAFIELD_SERVER_HOST];
}

- (NSString *)serverRoot {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_SERVER_ROOT];
    return result;
}

- (void)setServerRoot:(NSString *)value {
    [self setString:value forKey:DATAFIELD_SERVER_ROOT];
}

- (NSString *)serverBranch {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_SERVER_BRANCH];
    return result;
}

- (void)setServerBranch:(NSString *)value {
    [self setString:value forKey:DATAFIELD_SERVER_BRANCH];
}

- (NSString *)serverCodeVersion {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_SERVER_CODE_VERSION];
    return result;
}

- (void)setServerCodeVersion:(NSString *)value {
    [self setString:value forKey:DATAFIELD_SERVER_CODE_VERSION];
}

#pragma mark - Notifier

- (NSString *)notifierName {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_NOTIFIER_NAME];
    return result;
}

- (void)setNotifierName:(NSString *)value {
    [self setString:value forKey:DATAFIELD_NOTIFIER_NAME];
}

- (NSString *)notifierVersion {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_NOTIFIER_VERSION];
    return result;
}

- (void)setNotifierVersion:(NSString *)value {
    [self setString:value forKey:DATAFIELD_NOTIFIER_VERSION];
}

- (NSString *)framework {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_FRAMEWORK];
    return result;
}

- (void)setFramework:(NSString *)value {
   [self setString:value forKey:DATAFIELD_FRAMEWORK];
}

#pragma mark - Person

- (NSString *)personId {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_PERSON_ID];
    return result;
}

- (void)setPersonId:(NSString *)value {
    [self setString:value forKey:DATAFIELD_PERSON_ID];
}

- (NSString *)personUsername {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_PERSON_USERNAME];
    return result;
}

- (void)setPersonUsername:(NSString *)value {
    [self setString:value forKey:DATAFIELD_PERSON_USERNAME];
}

- (NSString *)personEmail {
    NSString *result = [self safelyGetStringByKey:DATAFIELD_PERSON_EMAIL];
    return result;
}

- (void)setPersonEmail:(NSString *)value {
    [self setString:value forKey:DATAFIELD_PERSON_EMAIL];
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
    self.personId = personId;
    self.personUsername = username;
    self.personEmail = email;
}

- (void)setServerHost:(NSString *)host
                 root:(NSString*)root
               branch:(NSString*)branch
          codeVersion:(NSString*)codeVersion {
    self.serverHost = host;
    self.serverRoot = root;
    self.serverBranch = branch;
    self.serverCodeVersion = codeVersion;
}

- (void)setNotifierName:(NSString *)name
                version:(NSString *)version {
    self.notifierName = name;
    self.notifierVersion = version;
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
