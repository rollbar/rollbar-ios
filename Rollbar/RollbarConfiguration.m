//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarConfiguration.h"
#import "objc/runtime.h"
#import "NSJSONSerialization+Rollbar.h"
#import "RollbarTelemetry.h"
#import "RollbarCachesDirectory.h"
#import "RollbarConfig.h"
#import "RollbarDestination.h"
#import "RollbarDeveloperOptions.h"
#import "RollbarProxy.h"
#import "RollbarScrubbingOptions.h"
#import "RollbarServer.h"
#import "RollbarPerson.h"
#import "RollbarModule.h"
#import "RollbarTelemetryOptions.h"
#import "RollbarLoggingOptions.h"
#import "CaptureIpType.h"
#import "RollbarLevel.h"

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
static NSString * const DEFAULT_ENDPOINT = @"https://api.rollbar.com/api/1/item/";

static NSString *configurationFilePath = nil;

@interface RollbarConfiguration () {
//    NSMutableDictionary *_customData;
    BOOL _isRootConfiguration;
    RollbarConfig *_configData;
}

@end

@implementation RollbarConfiguration

+ (RollbarConfiguration*)configuration {
    return [[RollbarConfiguration alloc] init];
}

- (id)init {
    if (!configurationFilePath) {
        NSString *cachesDirectory = [RollbarCachesDirectory directory];
        configurationFilePath = [cachesDirectory stringByAppendingPathComponent:CONFIGURATION_FILENAME];
    }

    if (self = [super init]) {
        _configData = [[RollbarConfig alloc] init];
//        _customData = [NSMutableDictionary dictionaryWithCapacity:10];
//        _endpoint = DEFAULT_ENDPOINT;

//        #ifdef DEBUG
//        _environment = @"development";
//        #else
//        _environment = @"unspecified";
//        #endif
//
//        _crashLevel = @"error";
//        _scrubFields = [NSMutableSet new];
//        _scrubWhitelistFields = [NSMutableSet new];
//        self.telemetryViewInputsToScrub = [NSMutableSet new];
//
//        _notifierName = NOTIFIER_NAME;
//        _notifierVersion = NOTIFIER_VERSION;
//        _framework = OPERATING_SYSTEM;
//        _captureIp = CaptureIpFull;
//
//        _logLevel = @"info";
//
//        _enabled = YES;
//        _transmit = YES;
//        _logPayload = NO;
//        _logPayloadFile = @"rollbar.payloads";
//
//        self.telemetryEnabled = NO;
//        _maximumReportsPerMinute = 60;
//        [self setCaptureLogAsTelemetryData:NO];
//
//        _httpProxyEnabled = NO;
//        _httpProxy = @"";
//        _httpProxyPort = [NSNumber numberWithInteger:0];
//
//        _httpsProxyEnabled = NO;
//        _httpsProxy = @"";
//        _httpsProxyPort = [NSNumber numberWithInteger:0];

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

- (void)setEnabled:(BOOL)enabled {
    self->_configData.developerOptions.enabled = enabled;
    [self save];
}

- (void)setTransmit:(BOOL)transmit {
    self->_configData.developerOptions.transmit = transmit;
    [self save];
}

- (void)setLogPayload:(BOOL)logPayload {
    self->_configData.developerOptions.logPayload = logPayload;
    [self save];
}

- (void)setLogPayloadFile:(NSString *)logPayloadFile {
    self->_configData.developerOptions.payloadLogFile = logPayloadFile;
    [self save];
}

- (void)setHttpProxyEnabled:(BOOL)httpProxyEnabled {
    self->_configData.httpProxy.enabled = httpProxyEnabled;
    [self save];
}

- (void)setHttpProxy:(NSString *)proxy {
    self->_configData.httpProxy.proxyUrl = proxy;
    [self save];
}

- (void)setHttpProxyPort:(NSNumber *)port {
    self->_configData.httpProxy.proxyPort = port;
    [self save];
}

- (void)setHttpsProxyEnabled:(BOOL)httpsProxyEnabled {
    self->_configData.httpsProxy.enabled = httpsProxyEnabled;
    [self save];
}

- (void)setHttpsProxy:(NSString *)proxy {
    self->_configData.httpsProxy.proxyUrl = proxy;
    [self save];
}

- (void)setHttpsProxyPort:(NSNumber *)port {
    self->_configData.httpsProxy.proxyPort = port;
    [self save];
}

- (void)setTelemetryEnabled:(BOOL)telemetryEnabled {
    [RollbarTelemetry sharedInstance].enabled = telemetryEnabled;
    self->_configData.telemetry.enabled = telemetryEnabled;
    [self save];
}

- (BOOL)telemetryEnabled {
    //return self->_configData.telemetry.enabled;
    return [RollbarTelemetry sharedInstance].enabled;
}

- (void)setScrubViewInputsTelemetry:(BOOL)scrubViewInputsTelemetry {
    [RollbarTelemetry sharedInstance].scrubViewInputs = scrubViewInputsTelemetry;
    self->_configData.telemetry.viewInputsScrubber.enabled = scrubViewInputsTelemetry;
    [self save];
}

- (BOOL)scrubViewInputsTelemetry {
    return self->_configData.telemetry.viewInputsScrubber.enabled;
}

- (void)addTelemetryViewInputToScrub:(NSString *)input {
    [[RollbarTelemetry sharedInstance].viewInputsToScrub addObject:input];
    
    self->_configData.telemetry.viewInputsScrubber.scrubFields =
    [self->_configData.telemetry.viewInputsScrubber.scrubFields arrayByAddingObject:input];
    
    [self save];
}

- (void)removeTelemetryViewInputToScrub:(NSString *)input {
    [[RollbarTelemetry sharedInstance].viewInputsToScrub removeObject:input];

    NSMutableArray *mutableCopy = self->_configData.telemetry.viewInputsScrubber.scrubFields.mutableCopy;
    [mutableCopy removeObject:input];
    self->_configData.telemetry.viewInputsScrubber.scrubFields = mutableCopy.copy;

    [self save];
}

- (void)setRollbarLevel:(RollbarLevel)level {
    self->_configData.loggingOptions.logLevel = level;
    [self save];
}

- (RollbarLevel)getRollbarLevel {
    return self->_configData.loggingOptions.logLevel;
}

- (void)setReportingRate:(NSUInteger)maximumReportsPerMinute {
    self->_configData.loggingOptions.maximumReportsPerMinute = maximumReportsPerMinute;
    [self save];
}

- (void)setMaximumTelemetryData:(NSInteger)maximumTelemetryData {
    [[RollbarTelemetry sharedInstance] setDataLimit:maximumTelemetryData];
    self->_configData.telemetry.maximumTelemetryData = maximumTelemetryData;
}

- (void)setPersonId:(NSString *)personId
           username:(NSString *)username
              email:(NSString *)email {
    self->_configData.person.ID = personId;
    self->_configData.person.username = username;
    self->_configData.person.email = email;
    [self save];
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
    [self save];
}

- (void)setNotifierName:(NSString *)name
                version:(NSString *)version {
    
    self->_configData.notifier.name = name ? name : NOTIFIER_NAME;
    self->_configData.notifier.version = version ? version : NOTIFIER_VERSION;
    [self save];
}

- (void)setCodeFramework:(NSString *)framework {
    self->_configData.loggingOptions.framework = framework ? framework : OPERATING_SYSTEM;
    [self save];
}

- (void)setRequestId:(NSString *)requestId {
    self->_configData.loggingOptions.requestId = requestId;
    [self save];
}

- (void)setCodeVersion:(NSString *)codeVersion {
    self->_configData.loggingOptions.codeVersion = codeVersion;
    [self save];
}

- (void)setCaptureIpType:(CaptureIpType)captureIp {
    self->_configData.loggingOptions.captureIp = captureIp;
}

- (void)setCaptureLogAsTelemetryData:(BOOL)captureLog {
    [[RollbarTelemetry sharedInstance] setCaptureLog:captureLog];
    self->_configData.telemetry.captureLog = captureLog;
}

- (void)setCaptureConnectivityAsTelemetryData:(BOOL)captureConnectivity {
    self->_configData.telemetry.captureConnectivity = captureConnectivity;
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

- (void)addScrubWhitelistField:(NSString *)field {
    self->_configData.dataScrubber.whitelistFields =
    [self->_configData.dataScrubber.whitelistFields arrayByAddingObject:field];
}

- (void)removeScrubWhitelistField:(NSString *)field {
    NSMutableArray *mutableCopy = self->_configData.dataScrubber.whitelistFields.mutableCopy;
    [mutableCopy removeObject:field];
    self->_configData.dataScrubber.whitelistFields = mutableCopy.copy;
}

- (NSDictionary *)customData {
    return [NSDictionary dictionaryWithDictionary:self->_configData.customData];
}







- (void)setPayloadModificationBlock:(void (^)(NSMutableDictionary*))payloadModificationBlock {
    _payloadModification = payloadModificationBlock;
}

- (void)setCheckIgnoreBlock:(BOOL (^)(NSDictionary *))checkIgnoreBlock {
    _checkIgnore = checkIgnoreBlock;
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

        NSData *configJson = [NSJSONSerialization dataWithJSONObject:config
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

@end
