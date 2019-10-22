//
//  RollbarConfig.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-11.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "CaptureIpType.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarConfig : DataTransferObject

//- (NSDictionary *)customData;

// Developer options:
@property (nonatomic) BOOL enabled;
@property (nonatomic) BOOL transmit;
@property (nonatomic) BOOL logPayload;
@property (nonatomic, copy) NSMutableString *logPayloadFile;

// Rollbar project endpoint/destination:
@property (nonatomic, copy) NSMutableString *accessToken;
@property (nonatomic, copy) NSMutableString *environment;
@property (nonatomic, copy) NSMutableString *endpoint;

// HTTP proxy:
@property (nonatomic) BOOL httpProxyEnabled;
@property (nonatomic, copy) NSMutableString *httpProxy;
@property (nonatomic) NSNumber *httpProxyPort;

// HTTPS proxy:
@property (nonatomic) BOOL httpsProxyEnabled;
@property (nonatomic, copy) NSMutableString *httpsProxy;
@property (nonatomic) NSNumber *httpsProxyPort;

// Logging options:
@property (nonatomic, copy) NSMutableString *crashLevel;
@property (nonatomic, copy) NSMutableString *logLevel;
@property (nonatomic) NSUInteger maximumReportsPerMinute;
@property (nonatomic) BOOL shouldCaptureConnectivity;

// Payload content related:
// ========================
// Decides whether or not to send payload. Returns true to ignore, false to send
//@property (nonatomic, copy) BOOL (^checkIgnore)(NSDictionary *payload);
// Modify payload
//@property (nonatomic, copy) void (^payloadModification)(NSMutableDictionary *payload);
// Fields to scrub from the payload
@property (nonatomic, strong) NSMutableSet *scrubFields;
// Fields to not scrub from the payload even if they mention among scrubFields:
@property (nonatomic, strong) NSMutableSet *scrubWhitelistFields;
@property (nonatomic) CaptureIpType captureIp;

// Telemetry:
@property (nonatomic) BOOL telemetryEnabled;
@property (nonatomic) BOOL scrubViewInputsTelemetry;
@property (nonatomic, strong) NSMutableSet *telemetryViewInputsToScrub;

@property (nonatomic, copy) NSString *codeVersion;

@property (nonatomic, copy) NSString *serverHost;
@property (nonatomic, copy) NSString *serverRoot;
@property (nonatomic, copy) NSString *serverBranch;
@property (nonatomic, copy) NSString *serverCodeVersion;

@property (nonatomic, copy) NSString *notifierName;
@property (nonatomic, copy) NSString *notifierVersion;
@property (nonatomic, copy) NSString *framework;

// Person/user tracking:
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personUsername;
@property (nonatomic, copy) NSString *personEmail;

// ID to link request between client/server
@property (nonatomic, copy) NSString *requestId;

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

@end

NS_ASSUME_NONNULL_END
