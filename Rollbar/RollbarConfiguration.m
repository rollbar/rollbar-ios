//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import "RollbarConfiguration.h"
#import "objc/runtime.h"
#import "NSJSONSerialization+Rollbar.h"
#import "RollbarTelemetry.h"

static NSString *NOTIFIER_NAME = @"rollbar-ios";
static NSString *NOTIFIER_VERSION = @"1.4.2";
static NSString *FRAMEWORK = @"ios";
static NSString *CONFIGURATION_FILENAME = @"rollbar.config";
static NSString *DEFAULT_ENDPOINT = @"https://api.rollbar.com/api/1/items/";

static NSString *configurationFilePath = nil;

@interface RollbarConfiguration () {
    NSMutableDictionary *_customData;
    BOOL _isRootConfiguration;
}

@end

@implementation RollbarConfiguration

+ (RollbarConfiguration*)configuration {
    return [[RollbarConfiguration alloc] init];
}

- (id)init {
    if (!configurationFilePath) {
        NSArray *paths =
            NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDirectory =
            [paths objectAtIndex:0];
        configurationFilePath =
            [cachesDirectory stringByAppendingPathComponent:CONFIGURATION_FILENAME];
    }

    if (self = [super init]) {
        _customData = [NSMutableDictionary dictionaryWithCapacity:10];
        _endpoint = DEFAULT_ENDPOINT;

        #ifdef DEBUG
        _environment = @"development";
        #else
        _environment = @"unspecified";
        #endif

        _crashLevel = @"error";
        _scrubFields = [NSMutableSet new];
        _scrubWhitelistFields = [NSMutableSet new];
        self.telemetryViewInputsToScrub = [NSMutableSet new];

        _notifierName = NOTIFIER_NAME;
        _notifierVersion = NOTIFIER_VERSION;
        _framework = FRAMEWORK;
        _captureIp = CaptureIpFull;
        
        _logLevel = @"info";

        _enabled = true;
        self.telemetryEnabled = false;
        _maximumReportsPerMinute = 60;
        [self setCaptureLogAsTelemetryData:false];
        
        _httpProxyEnabled = NO;
        _httpProxy = @"";
        _httpProxyPort = [NSNumber numberWithInteger:0];

        _httpsProxyEnabled = NO;
        _httpsProxy = @"";
        _httpsProxyPort = [NSNumber numberWithInteger:0];

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
    _enabled = enabled;
    [self save];
}

- (void)setHttpProxyEnabled:(BOOL)httpProxyEnabled {
    _httpProxyEnabled = httpProxyEnabled;
    [self save];
}

- (void)setHttpProxy:(NSString *)proxy {
    _httpProxy = proxy;
    [self save];
}

- (void)setHttpProxyPort:(NSNumber *)port {
    _httpProxyPort = port;
    [self save];
}

- (void)setHttpsProxyEnabled:(BOOL)httpsProxyEnabled {
    _httpsProxyEnabled = httpsProxyEnabled;
    [self save];
}

- (void)setHttpsProxy:(NSString *)proxy {
    _httpsProxy = proxy;
    [self save];
}

- (void)setHttpsProxyPort:(NSNumber *)port {
    _httpsProxyPort = port;
    [self save];
}

- (void)setTelemetryEnabled:(BOOL)telemetryEnabled {
    [RollbarTelemetry sharedInstance].enabled = telemetryEnabled;
    [self save];
}

- (BOOL)telemetryEnabled {
    return [RollbarTelemetry sharedInstance].enabled;
}

- (void)setScrubViewInputsTelemetry:(BOOL)scrubViewInputsTelemetry {
    [RollbarTelemetry sharedInstance].scrubViewInputs = scrubViewInputsTelemetry;
    [self save];
}

- (BOOL)scrubViewInputsTelemetry {
    return [RollbarTelemetry sharedInstance].scrubViewInputs;
}

- (void)addTelemetryViewInputToScrub:(NSString *)input {
    [[RollbarTelemetry sharedInstance].viewInputsToScrub addObject:input];
    [self save];
}

- (void)removeTelemetryViewInputToScrub:(NSString *)input {
    [[RollbarTelemetry sharedInstance].viewInputsToScrub removeObject:input];
    [self save];
}

- (void)setRollbarLevel:(RollbarLevel)level {
    _logLevel = RollbarStringFromLevel(level);
    [self save];
}

- (RollbarLevel)getRollbarLevel {
    return RollbarLevelFromString(_logLevel);
}

- (void)setReportingRate:(NSUInteger)maximumReportsPerMinute {
    _maximumReportsPerMinute = maximumReportsPerMinute;
    [self save];
}

- (void)setMaximumTelemetryData:(NSInteger)maximumTelemetryData {
    [[RollbarTelemetry sharedInstance] setDataLimit:maximumTelemetryData];
}

- (void)setPersonId:(NSString *)personId
           username:(NSString *)username
              email:(NSString *)email {
    _personId = personId;
    _personUsername = username;
    _personEmail = email;
    [self save];
}

- (void)setServerHost:(NSString *)host
                 root:(NSString*)root
               branch:(NSString*)branch
          codeVersion:(NSString*)codeVersion {
    
    _serverHost = host;
    _serverRoot = root ?
        [root stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]]
        : root;
    _serverBranch = branch;
    _serverCodeVersion = codeVersion;
    [self save];
}

- (void)setNotifierName:(NSString *)name
                version:(NSString *)version {
    
    _notifierName = name ? name : NOTIFIER_NAME;
    _notifierVersion = version ? version : NOTIFIER_VERSION;
    [self save];
}

- (void)setCodeFramework:(NSString *)framework {
    _framework = framework ? framework : FRAMEWORK;
    [self save];
}

- (void)setRequestId:(NSString *)requestId {
    _requestId = requestId;
    [self save];
}

- (void)setPayloadModificationBlock:(void (^)(NSMutableDictionary*))payloadModificationBlock {
    _payloadModification = payloadModificationBlock;
}

- (void)setCheckIgnoreBlock:(BOOL (^)(NSDictionary *))checkIgnoreBlock {
    _checkIgnore = checkIgnoreBlock;
}

- (void)addScrubField:(NSString *)field {
    [_scrubFields addObject:field];
}

- (void)removeScrubField:(NSString *)field {
    [_scrubFields removeObject:field];
}

- (void)addScrubWhitelistField:(NSString *)field {
    [_scrubWhitelistFields addObject:field];
}

- (void)removeScrubWhitelistField:(NSString *)field {
    [_scrubWhitelistFields removeObject:field];
}

- (void)setCaptureLogAsTelemetryData:(BOOL)captureLog {
    [[RollbarTelemetry sharedInstance] setCaptureLog:captureLog];
}

- (void)setCaptureConnectivityAsTelemetryData:(BOOL)captureConnectivity {
    _shouldCaptureConnectivity = captureConnectivity;
}

- (void)setCaptureIpType:(CaptureIpType)captureIp {
    _captureIp = captureIp;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    if (value) {
        _customData[key] = value;
    } else {
        [_customData removeObjectForKey:key];
    }
    
    [self save];
}

- (id)valueForUndefinedKey:(NSString *)key {
    return _customData[key];
}

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
    
    [result addObjectsFromArray:_customData.allKeys];
    
    return result;
}

- (NSDictionary *)customData {
    return [NSDictionary dictionaryWithDictionary:_customData];
}

@end
