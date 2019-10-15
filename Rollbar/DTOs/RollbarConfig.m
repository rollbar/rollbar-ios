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


@implementation RollbarConfig

#pragma -mark Developer Options

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

#pragma -mark HTTP Proxy Settings

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

#pragma -mark HTTPS Proxy Settings

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

#pragma -mark Logging Options

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

#pragma -mark Payload Content Related



@end
