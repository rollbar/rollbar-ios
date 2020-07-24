//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import RollbarCommon;

#import "RollbarConfiguration.h"
#import "RollbarTelemetry.h"
#import "RollbarCachesDirectory.h"
#import "RollbarConfig.h"
#import "RollbarDestination.h"
#import "RollbarDeveloperOptions.h"
#import "RollbarProxy.h"
#import "RollbarScrubbingOptions.h"
#import "RollbarServerConfig.h"
#import "RollbarPerson.h"
#import "RollbarModule.h"
#import "RollbarTelemetryOptions.h"
#import "RollbarLoggingOptions.h"
#import "RollbarCaptureIpType.h"
#import "RollbarLevel.h"

#import "objc/runtime.h"

@import RollbarCommon;

#pragma mark - Constants

static NSString * const CONFIGURATION_FILENAME = @"rollbar.config";

static NSString *configurationFilePath = nil;

#pragma mark - Private part of the RollbarConfiguration interface

@interface RollbarConfiguration () {
    BOOL _isRootConfiguration;
    RollbarConfig *_configData;
}
@end

#pragma mark - Implementation

@implementation RollbarConfiguration

- (RollbarConfig *)asRollbarConfig {
    return self->_configData;
}

#pragma mark - Factory methods

+ (RollbarConfiguration*)configuration {
    return [[RollbarConfiguration alloc] init];
}

#pragma mark - Initializers

- (id)init {
    if (!configurationFilePath) {
        NSString *cachesDirectory = [RollbarCachesDirectory directory];
        configurationFilePath = [cachesDirectory stringByAppendingPathComponent:CONFIGURATION_FILENAME];
    }

    if (self = [super init]) {
        _configData = [[RollbarConfig alloc] init];
        [self save];
    }

    return self;
}

- (id)initWithLoadedConfiguration {
    self = [self init];

    NSData *data = [NSData dataWithContentsOfFile:configurationFilePath];
    if (data) {
        NSDictionary *config = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:nil];

        if (!config) {
            return self;
        }

        for (NSString *propertyName in config.allKeys) {
            id value = [config objectForKey:propertyName];
            [self setValue:value forKey:propertyName];
        }
    }

    return self;
}

#pragma mark - Custom data

- (NSDictionary *)customData {
    return [NSDictionary dictionaryWithDictionary:self->_configData.customData];
}

#pragma mark - Rollbar project destination/endpoint

- (NSString *)accessToken {
    return self->_configData.destination.accessToken;
}

- (void)setAccessToken:(NSString *)value {
    self->_configData.destination.accessToken = value;
}
- (NSString *)environment {
    return self->_configData.destination.environment;
}

- (void)setEnvironment:(NSString *)value {
    self->_configData.destination.environment = value;
}
- (NSString *)endpoint {
    return self->_configData.destination.endpoint;
}

- (void)setEndpoint:(NSString *)value {
    self->_configData.destination.endpoint = value;
}

#pragma mark - Developer options

- (BOOL)enabled {
    return self->_configData.developerOptions.enabled;
}

- (void)setEnabled:(BOOL)enabled {
    self->_configData.developerOptions.enabled = enabled;
}

- (BOOL)transmit {
    return self->_configData.developerOptions.transmit;
}

- (void)setTransmit:(BOOL)transmit {
    self->_configData.developerOptions.transmit = transmit;
}

- (BOOL)logPayload {
    return self->_configData.developerOptions.logPayload;
}

- (void)setLogPayload:(BOOL)logPayload {
    self->_configData.developerOptions.logPayload = logPayload;
}

- (NSString *)logPayloadFile {
    return self->_configData.developerOptions.payloadLogFile;
}

- (void)setLogPayloadFile:(NSString *)logPayloadFile {
    self->_configData.developerOptions.payloadLogFile = logPayloadFile;
}

#pragma mark - HTTP proxy

- (BOOL)httpProxyEnabled {
    return self->_configData.httpProxy.enabled;
}

- (void)setHttpProxyEnabled:(BOOL)httpProxyEnabled {
    self->_configData.httpProxy.enabled = httpProxyEnabled;
}

- (NSString *)httpProxy {
    return self->_configData.httpProxy.proxyUrl;
}

- (void)setHttpProxy:(NSString *)proxy {
    self->_configData.httpProxy.proxyUrl = proxy;
}

- (NSNumber *)httpProxyPort {
    return [NSNumber numberWithUnsignedInteger: self->_configData.httpProxy.proxyPort];
}

- (void)setHttpProxyPort:(NSNumber *)port {
    self->_configData.httpProxy.proxyPort = port.unsignedIntegerValue;
}

#pragma mark - HTTPS proxy

- (BOOL)httpsProxyEnabled {
    return self->_configData.httpsProxy.enabled;
}

- (void)setHttpsProxyEnabled:(BOOL)httpsProxyEnabled {
    self->_configData.httpsProxy.enabled = httpsProxyEnabled;
}

- (NSString *)httpsProxy {
    return self->_configData.httpsProxy.proxyUrl;
}

- (void)setHttpsProxy:(NSString *)proxy {
    self->_configData.httpsProxy.proxyUrl = proxy;
}

- (NSNumber *)httpsProxyPort {
    return [NSNumber numberWithUnsignedInteger:self->_configData.httpsProxy.proxyPort];
}

- (void)setHttpsProxyPort:(NSNumber *)port {
    self->_configData.httpsProxy.proxyPort = port.unsignedIntegerValue;
}

#pragma mark - Logging options

- (RollbarLevel)rollbarCrashLevel {
    return self->_configData.loggingOptions.crashLevel;
}

- (void)setRollbarCrashLevel:(RollbarLevel)value {
    self->_configData.loggingOptions.crashLevel = value;
}

- (RollbarLevel)rollbarLogLevel {
    return self->_configData.loggingOptions.logLevel;
}

- (void)setRollbarLogLevel:(RollbarLevel)value {
    self->_configData.loggingOptions.logLevel = value;
}

- (NSUInteger)maximumReportsPerMinute {
    return self->_configData.loggingOptions.maximumReportsPerMinute;
}

- (void)setMaximumReportsPerMinute:(NSUInteger)maximumReportsPerMinute {
    self->_configData.loggingOptions.maximumReportsPerMinute = maximumReportsPerMinute;
}

- (RollbarCaptureIpType)captureIpType:(RollbarCaptureIpType)captureIp {
    return self->_configData.loggingOptions.captureIp ;
}

- (void)setCaptureIpType:(RollbarCaptureIpType)captureIp {
    self->_configData.loggingOptions.captureIp = captureIp;
}

- (NSString *)codeVersion {
    return self->_configData.loggingOptions.codeVersion;
}

- (void)setCodeVersion:(NSString *)codeVersion {
    self->_configData.loggingOptions.codeVersion = codeVersion;
}

- (NSString *)framework {
    return self->_configData.loggingOptions.framework;
}

- (void)setFramework:(NSString *)framework {
    self->_configData.loggingOptions.framework = framework;// ? framework : OPERATING_SYSTEM;
}

- (NSString *)requestId {
    return self->_configData.loggingOptions.requestId;
}

- (void)setRequestId:(NSString *)requestId {
    self->_configData.loggingOptions.requestId = requestId;
}

#pragma mark - Payload scrubbing options

- (NSSet *)scrubFields {
    NSArray *fields = self->_configData.dataScrubber.scrubFields;
    return [NSSet setWithArray:fields];
}

- (void)addScrubField:(NSString *)field {
    self->_configData.dataScrubber.scrubFields =
    [self->_configData.dataScrubber.scrubFields arrayByAddingObject:field];
}

- (void)removeScrubField:(NSString *)field {
    NSMutableArray *mutableCopy = self->_configData.dataScrubber.scrubFields.mutableCopy;
    [mutableCopy removeObject:field];
    self->_configData.dataScrubber.scrubFields = mutableCopy.copy;
}

- (NSSet *)scrubSafeListFields {
    NSArray *fields = self->_configData.dataScrubber.safeListFields;
    return [NSSet setWithArray:fields];
}

- (void)addScrubSafeListField:(NSString *)field {
    self->_configData.dataScrubber.safeListFields =
    [self->_configData.dataScrubber.safeListFields arrayByAddingObject:field];
}

- (void)removeScrubSafeListField:(NSString *)field {
    NSMutableArray *mutableCopy = self->_configData.dataScrubber.safeListFields.mutableCopy;
    [mutableCopy removeObject:field];
    self->_configData.dataScrubber.safeListFields = mutableCopy.copy;
}

#pragma mark - Server

- (NSString *)serverHost {
    return self->_configData.server.host;
}

- (void)setServerHost:(NSString *)value {
    self->_configData.server.host = value;
}

- (NSString *)serverRoot {
    return self->_configData.server.root;
}

- (void)setServerRoot:(NSString *)value {
    self->_configData.server.root = value;
}

- (NSString *)serverBranch {
    return self->_configData.server.branch;
}

- (void)setServerBranch:(NSString *)value {
    self->_configData.server.branch = value;
}

- (NSString *)serverCodeVersion {
    return self->_configData.server.codeVersion;
}

- (void)setServerCodeVersion:(NSString *)value {
    self->_configData.server.codeVersion = value;
}

#pragma mark - Person/user tracking

- (NSString *)personId {
    return self->_configData.person.ID;
}

- (void)setPersonId:(NSString *)value {
    self->_configData.person.ID = value;
}

- (NSString *)personUsername {
    return self->_configData.person.username;
}

- (void)setPersonUsername:(NSString *)value {
    self->_configData.person.username = value;
}

- (NSString *)personEmail {
    return self->_configData.person.email;
}

- (void)setPersonEmail:(NSString *)value {
    self->_configData.person.email = value;
}

#pragma mark - Notifier

- (NSString *)notifierName {
    return self->_configData.notifier.name;
}

- (void)setNotifierName:(NSString *)value {
    self->_configData.notifier.name = value;
}

- (NSString *)notifierVersion {
    return self->_configData.notifier.version;
}

- (void)setNotifierVersion:(NSString *)value {
    self->_configData.notifier.version = value;
}

#pragma mark - Telemetry:
 
- (BOOL)telemetryEnabled {
    return self->_configData.telemetry.enabled;
}

- (void)setTelemetryEnabled:(BOOL)telemetryEnabled {
    [RollbarTelemetry sharedInstance].enabled = telemetryEnabled;
    self->_configData.telemetry.enabled = telemetryEnabled;
}

- (NSInteger)maximumTelemetryEvents {
    return self->_configData.telemetry.maximumTelemetryData;
}

- (void)setMaximumTelemetryEvents:(NSInteger)maximumTelemetryEvents {
    [[RollbarTelemetry sharedInstance] setDataLimit:maximumTelemetryEvents];
    self->_configData.telemetry.maximumTelemetryData = maximumTelemetryEvents;
}

- (BOOL)captureLogAsTelemetryEvents {
    return self->_configData.telemetry.captureLog;
}

- (void)setCaptureLogAsTelemetryEvents:(BOOL)captureLog {
    [[RollbarTelemetry sharedInstance] setCaptureLog:captureLog];
    self->_configData.telemetry.captureLog = captureLog;
}

- (BOOL)shouldCaptureConnectivity {
    return self->_configData.telemetry.captureConnectivity;
}

- (void)setShouldCaptureConnectivity:(BOOL)captureConnectivity {
    self->_configData.telemetry.captureConnectivity = captureConnectivity;
}

- (BOOL)scrubViewInputsTelemetry {
    return self->_configData.telemetry.viewInputsScrubber.enabled;
}

- (void)setScrubViewInputsTelemetry:(BOOL)scrubViewInputsTelemetry {
    [RollbarTelemetry sharedInstance].scrubViewInputs = scrubViewInputsTelemetry;
    self->_configData.telemetry.viewInputsScrubber.enabled = scrubViewInputsTelemetry;
}

- (void)addTelemetryViewInputToScrub:(NSString *)input {
    [[RollbarTelemetry sharedInstance].viewInputsToScrub addObject:input];
    
    self->_configData.telemetry.viewInputsScrubber.scrubFields =
    [self->_configData.telemetry.viewInputsScrubber.scrubFields arrayByAddingObject:input];
}

- (void)removeTelemetryViewInputToScrub:(NSString *)input {
    [[RollbarTelemetry sharedInstance].viewInputsToScrub removeObject:input];

    NSMutableArray *mutableCopy = self->_configData.telemetry.viewInputsScrubber.scrubFields.mutableCopy;
    [mutableCopy removeObject:input];
    self->_configData.telemetry.viewInputsScrubber.scrubFields = mutableCopy.copy;
}

#pragma mark - Convenience Methods

- (void)setPersonId:(NSString *)personId
           username:(NSString *)username
              email:(NSString *)email {
    self->_configData.person.ID = personId;
    self->_configData.person.username = username;
    self->_configData.person.email = email;
}

- (void)setServerHost:(NSString *)host
                 root:(NSString*)root
               branch:(NSString*)branch
          codeVersion:(NSString*)codeVersion {
    
    self->_configData.server.host = host;
    self->_configData.server.root = root ?
        [root stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]
        : root;
    self->_configData.server.branch = branch;
    self->_configData.server.codeVersion = codeVersion;
}

- (void)setNotifierName:(NSString *)name
                version:(NSString *)version {
    
    self->_configData.notifier.name = name;// ? name : NOTIFIER_NAME;
    self->_configData.notifier.version = version;// ? version : NOTIFIER_VERSION;
}

#pragma mark - Configuration rendering

- (NSString *)description {
    NSString *result = [self renderAsRollbarConfiguration];
    result = [result stringByAppendingString:@"\nOR as DTO:\n"];
    result = [result stringByAppendingString:[self renderAsDTO]];
    return result;
}

- (NSString *)renderAsDTO {
    return [self->_configData serializeToJSONString];
}

- (NSString *)renderAsRollbarConfiguration {
    NSMutableDictionary *config = [NSMutableDictionary dictionary];
    
    for (NSString *propertyName in [self getProperties]) {
        id value = [self valueForKey:propertyName];
        if (value) {
            [config setObject:value
                       forKey:propertyName];
        }
    }

    NSData *configJson = [NSJSONSerialization rollbar_dataWithJSONObject:config
                                                         options:NSJSONWritingPrettyPrinted
                                                           error:nil
                                                            safe:true];
    NSString *result = [[NSString alloc] initWithData:configJson encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark - Persistence

// Add a key value observer for all properties so that this object
// is saved to disk every time a property is updated
- (void)_setRoot {
    _isRootConfiguration = YES;
    
    for (NSString *propertyName in [self getProperties]) {
        if ([propertyName rangeOfString:@"person"].location == NSNotFound) {
            [self addObserver:self
                   forKeyPath:propertyName
                      options:NSKeyValueObservingOptionNew
                      context:nil];
        }
    }
}

// Convert this object's properties into json and save it to disk only if
// this is the root level configuration
- (void)save {
    if (_isRootConfiguration) {
        NSMutableDictionary *config = [NSMutableDictionary dictionary];
        
        for (NSString *propertyName in [self getProperties]) {
            id value = [self valueForKey:propertyName];
            if (value) {
                [config setObject:value
                           forKey:propertyName];
            }
        }

        NSData *configJson = [NSJSONSerialization rollbar_dataWithJSONObject:config
                                                             options:0
                                                               error:nil
                                                                safe:true];
        [configJson writeToFile:configurationFilePath
                     atomically:YES];
    }
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    [self save];
}

- (NSArray*)getProperties {
    NSMutableArray *result = [NSMutableArray array];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for(i = 0; i < outCount; ++i) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];            
            [result addObject:propertyName];
        }
    }
    
    free(properties);
    
    [result addObjectsFromArray:self->_configData.customData.allKeys];
    
    return result;
}

#pragma mark - DEPRECATED

- (NSString *)crashLevel {
    return [RollbarLevelUtil RollbarLevelToString:self->_configData.loggingOptions.crashLevel];
}

- (void)setCrashLevel:(NSString *)value {
    self->_configData.loggingOptions.crashLevel = [RollbarLevelUtil RollbarLevelFromString:value];
}

- (NSString *)logLevel {
    return [RollbarLevelUtil RollbarLevelToString:self->_configData.loggingOptions.logLevel];
}

- (void)setLogLevel:(NSString *)value {
    self->_configData.loggingOptions.logLevel = [RollbarLevelUtil RollbarLevelFromString:value];
}

- (void)setPayloadModificationBlock:(void (^)(NSMutableDictionary*))payloadModificationBlock {
    _payloadModification = payloadModificationBlock;
}

- (void)setCheckIgnoreBlock:(BOOL (^)(NSDictionary *))checkIgnoreBlock {
    _checkIgnore = checkIgnoreBlock;
}

- (void)setReportingRate:(NSUInteger)maximumReportsPerMinute {
    self->_configData.loggingOptions.maximumReportsPerMinute = maximumReportsPerMinute;
}

- (RollbarLevel)getRollbarLevel {
    return self->_configData.loggingOptions.logLevel;
}

- (void)setRollbarLevel:(RollbarLevel)level {
    self->_configData.loggingOptions.logLevel = level;
}

- (void)setCodeFramework:(NSString *)framework {
    self->_configData.loggingOptions.framework = framework;// ? framework : OPERATING_SYSTEM;
}

- (void)setCaptureConnectivityAsTelemetryData:(BOOL)captureConnectivity {
    self->_configData.telemetry.captureConnectivity = captureConnectivity;
}

- (void)setCaptureLogAsTelemetryData:(BOOL)captureLog {
    [[RollbarTelemetry sharedInstance] setCaptureLog:captureLog];
    self->_configData.telemetry.captureLog = captureLog;
}

- (void)setMaximumTelemetryData:(NSInteger)maximumTelemetryData {
    [[RollbarTelemetry sharedInstance] setDataLimit:maximumTelemetryData];
    self->_configData.telemetry.maximumTelemetryData = maximumTelemetryData;
}



//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    if (value) {
//        _customData[key] = value;
//    } else {
//        [_customData removeObjectForKey:key];
//    }
//
//    [self save];
//}
//
//- (id)valueForUndefinedKey:(NSString *)key {
//    return _customData[key];
//}

@end
