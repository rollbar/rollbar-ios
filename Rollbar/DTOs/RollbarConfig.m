//
//  RollbarConfig.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-11.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarConfig.h"
#import "DataTransferObject+Protected.h"
#import <Foundation/Foundation.h>

#pragma mark - Data Fields

static NSString * const DATAFIELD_ENABLED = @"enabled";
static NSString * const DATAFIELD_TRANSMIT = @"transmit";
static NSString * const DATAFIELD_LOGPAYLOAD = @"logPayload";
static NSString * const DATAFIELD_LOGPAYLOADFILE = @"logPayloadFile";

static NSString * const DATAFIELD_HTTP_PROXY_ENABLED = @"httpProxyEnabled";
static NSString * const DATAFIELD_HTTP_PROXY = @"httpProxy";
static NSString * const DATAFIELD_HTTP_PROXY_PORT = @"httpProxyPort";

static NSString * const DATAFIELD_HTTPS_PROXY_ENABLED = @"httpsProxyEnabled";
static NSString * const DATAFIELD_HTTPS_PROXY = @"httpsProxy";
static NSString * const DATAFIELD_HTTPS_PROXY_PORT = @"httpsProxyPort";

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

#pragma mark - RollbarConfig implementation

@implementation RollbarConfig

#pragma mark - Developer Options

- (BOOL) enabled {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_ENABLED];
    return [result boolValue];
}

- (void)setEnabled:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_ENABLED];
}

- (BOOL)transmit {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_TRANSMIT];
    return [result boolValue];
}

- (void)setTransmit:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_TRANSMIT];
}

- (BOOL)logPayload {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_LOGPAYLOAD];
    return [result boolValue];
}

- (void)setLogPayload:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_LOGPAYLOAD];
}

- (NSMutableString *)logPayloadFile {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_LOGPAYLOAD];
    return result;
}

- (void)setLogPayloadFile:(NSMutableString *)value {
    [self setString:value forKey:DATAFIELD_LOGPAYLOADFILE];
}

#pragma mark - HTTP Proxy Settings

- (BOOL)httpProxyEnabled {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_HTTP_PROXY_ENABLED];
    return [result boolValue];
}

- (void)setHttpProxyEnabled:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_HTTP_PROXY_ENABLED];
}

- (NSMutableString *)httpProxy {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_HTTP_PROXY];
    return result;
}

- (void)setHttpProxy:(NSMutableString *)value {
    [self setString:value forKey:DATAFIELD_HTTP_PROXY];
}

- (NSNumber *)httpProxyPort {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_HTTP_PROXY_PORT];
    return result;
}

- (void)setHttpProxyPort:(NSNumber *)value {
    [self setNumber:value forKey:DATAFIELD_HTTP_PROXY_PORT];
}

#pragma mark - HTTPS Proxy Settings

- (BOOL)httpsProxyEnabled {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_HTTPS_PROXY_ENABLED];
    return [result boolValue];
}

- (void)setHttpsProxyEnabled:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DATAFIELD_HTTPS_PROXY_ENABLED];
}

- (NSMutableString *)httpsProxy {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_HTTPS_PROXY];
    return result;
}

- (void)setHttpsProxy:(NSMutableString *)value {
    [self setString:value forKey:DATAFIELD_HTTPS_PROXY];
}

- (NSNumber *)httpsProxyPort {
    NSNumber *result = [self safelyGetNumberByKey:DATAFIELD_HTTPS_PROXY_PORT];
    return result;
}

- (void)setHttpsProxyPort:(NSNumber *)value {
    [self setNumber:value forKey:DATAFIELD_HTTPS_PROXY_PORT];
}

#pragma mark - Logging Options

- (NSMutableString *)crashLevel {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_CRASH_LEVEL];
    return result;
}

- (void)setCrashLevel:(NSMutableString *)value {
    [self setString:value forKey:DATAFIELD_CRASH_LEVEL];
}

- (NSMutableString *)logLevel {
    NSMutableString *result = [self safelyGetStringByKey:DATAFIELD_LOG_LEVEL];
    return result;
}

- (void)setLogLevel:(NSMutableString *)value {
    [self setString:value forKey:DATAFIELD_LOG_LEVEL];
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

- (NSMutableSet *)scrubFields {
    NSMutableSet *result = [self safelyGetSetByKey:DATAFIELD_SCRUB_FIELDS];
    return result;
}

- (void)setScrubFields:(NSMutableSet *)value {
    [self setSet:value forKey:DATAFIELD_SCRUB_FIELDS];
}

- (NSMutableSet *)scrubWhitelistFields {
    NSMutableSet *result = [self safelyGetSetByKey:DATAFIELD_SCRUB_FIELDS_WHITE_LIST];
    return result;
}

- (void)setScrubWhitelistFields:(NSMutableSet *)value {
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

#pragma mark - Telemetry:

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


//@property (nonatomic, copy) NSString *codeVersion;
//
//@property (nonatomic, copy) NSString *serverHost;
//@property (nonatomic, copy) NSString *serverRoot;
//@property (nonatomic, copy) NSString *serverBranch;
//@property (nonatomic, copy) NSString *serverCodeVersion;
//
//@property (nonatomic, copy) NSString *notifierName;
//@property (nonatomic, copy) NSString *notifierVersion;
//@property (nonatomic, copy) NSString *framework;
//
//// Person/user tracking:
//@property (nonatomic, copy) NSString *personId;
//@property (nonatomic, copy) NSString *personUsername;
//@property (nonatomic, copy) NSString *personEmail;
//
//// ID to link request between client/server
//@property (nonatomic, copy) NSString *requestId;

@end
