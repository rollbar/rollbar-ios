//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarLevel.h"
#import "CaptureIpType.h"

@class RollbarConfig;

@interface RollbarConfiguration : NSObject

+ (RollbarConfiguration*)configuration;

- (id)initWithLoadedConfiguration;

- (RollbarConfig *)asRollbarConfig;

#pragma mark - Persistence
- (void)_setRoot;
- (void)save;

#pragma mark - Custom data
- (NSDictionary *)customData;

#pragma mark - Rollbar project destination/endpoint
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *environment;
@property (nonatomic, copy) NSString *endpoint;

#pragma mark - Developer options
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL transmit;
@property (nonatomic) BOOL logPayload;
@property (nonatomic, copy) NSString *logPayloadFile;

#pragma mark - HTTP proxy
@property (nonatomic) BOOL httpProxyEnabled;
@property (nonatomic, copy) NSString *httpProxy;
@property (nonatomic) NSNumber *httpProxyPort;

#pragma mark - HTTPS proxy
@property (nonatomic) BOOL httpsProxyEnabled;
@property (nonatomic, copy) NSString *httpsProxy;
@property (nonatomic) NSNumber *httpsProxyPort;

#pragma mark - Logging options
@property (nonatomic, copy) NSString *crashLevel;
@property (nonatomic, copy) NSString *logLevel;
@property (nonatomic) NSUInteger maximumReportsPerMinute;
@property (nonatomic) CaptureIpType captureIp;
@property (nonatomic, copy) NSString *codeVersion;
@property (nonatomic, copy) NSString *framework;
// ID to link request between client/server
@property (nonatomic, copy) NSString *requestId;

#pragma mark - Payload scrubbing options
// Fields to scrub from the payload
@property (readonly, nonatomic, strong) NSSet *scrubFields;
- (void)addScrubField:(NSString *)field;
- (void)removeScrubField:(NSString *)field;
// Fields to not scrub from the payload even if they mention among scrubFields:
@property (readonly, nonatomic, strong) NSSet *scrubWhitelistFields;
- (void)addScrubWhitelistField:(NSString *)field;
- (void)removeScrubWhitelistField:(NSString *)field;

#pragma mark - Server
@property (nonatomic, copy) NSString *serverHost;
@property (nonatomic, copy) NSString *serverRoot;
@property (nonatomic, copy) NSString *serverBranch;
@property (nonatomic, copy) NSString *serverCodeVersion;

#pragma mark - Person/user tracking
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personUsername;
@property (nonatomic, copy) NSString *personEmail;

#pragma mark - Notifier
@property (nonatomic, copy) NSString *notifierName;
@property (nonatomic, copy) NSString *notifierVersion;

#pragma mark - Telemetry:
@property (nonatomic) BOOL telemetryEnabled;
@property (nonatomic) NSInteger maximumTelemetryData;
@property (nonatomic) BOOL captureLogAsTelemetryData;
@property (nonatomic) BOOL shouldCaptureConnectivity;
@property (nonatomic) BOOL scrubViewInputsTelemetry;
@property (nonatomic, strong) NSMutableSet *telemetryViewInputsToScrub;
- (void)addTelemetryViewInputToScrub:(NSString *)input;
- (void)removeTelemetryViewInputToScrub:(NSString *)input;


#pragma mark - Payload processing callbacks
// Decides whether or not to send payload. Returns true to ignore, false to send
@property (readonly, nonatomic, copy) BOOL (^checkIgnore)(NSDictionary *payload);
- (void)setCheckIgnoreBlock:(BOOL (^)(NSDictionary*))checkIgnoreBlock;
// Modify payload
@property (readonly, nonatomic, copy) void (^payloadModification)(NSMutableDictionary *payload);
- (void)setPayloadModificationBlock:(void (^)(NSMutableDictionary*))payloadModificationBlock;

#pragma mark - Convenience Methods

- (void)setPersonId:(NSString*)personId
           username:(NSString*)username
              email:(NSString*)email;

- (void)setServerHost:(NSString *)host
                 root:(NSString*)root
               branch:(NSString*)branch
          codeVersion:(NSString*)codeVersion;

- (void)setNotifierName:(NSString *)name
                version:(NSString *)version;

#pragma mark - Deprecated

/// START Deprecated
- (void)setRollbarLevel:(RollbarLevel)level;
- (RollbarLevel)getRollbarLevel;

- (void)setReportingRate:(NSUInteger)maximumReportsPerMinute;
- (void)setCodeFramework:(NSString *)framework;
- (void)setCodeVersion:(NSString *)codeVersion;
- (void)setRequestId:(NSString*)requestId;
- (void)setCaptureIpType:(CaptureIpType)captureIp;
- (void)setMaximumTelemetryData:(NSInteger)maximumTelemetryData;
- (void)setCaptureLogAsTelemetryData:(BOOL)captureLog;
- (void)setCaptureConnectivityAsTelemetryData:(BOOL)captureConnectivity;
/// END Deprecated


@end
