//
//  RollbarConfig.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-11.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "CaptureIpType.h"
#import "RollbarLevel.h"

@class RollbarDestination;
@class RollbarDeveloperOptions;
@class RollbarProxy;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarConfig : DataTransferObject
#pragma mark - properties
@property (nonatomic, strong) RollbarDestination *destination;
@property (nonatomic, strong) RollbarDeveloperOptions *developerOptions;
@property (nonatomic, strong) RollbarProxy *httpProxy;
@property (nonatomic, strong) RollbarProxy *httpsProxy;

#pragma mark - Developer Options
#pragma mark - HTTP Proxy Settings
#pragma mark - HTTPS Proxy Settings

#pragma mark - Logging Options
@property (nonatomic, copy) NSString *crashLevel;
@property (nonatomic) RollbarLevel logLevel;
@property (nonatomic) NSUInteger maximumReportsPerMinute;
@property (nonatomic) BOOL shouldCaptureConnectivity;

#pragma mark - Payload Content Related
// Payload content related:
// ========================
// Decides whether or not to send payload. Returns true to ignore, false to send
//@property (nonatomic, copy) BOOL (^checkIgnore)(NSDictionary *payload);
// Modify payload
//@property (nonatomic, copy) void (^payloadModification)(NSMutableDictionary *payload);
// Fields to scrub from the payload
@property (nonatomic, strong) NSSet *scrubFields;
// Fields to not scrub from the payload even if they mention among scrubFields:
@property (nonatomic, strong) NSSet *scrubWhitelistFields;
@property (nonatomic) CaptureIpType captureIp;

#pragma mark - Telemetry
@property (nonatomic) BOOL telemetryEnabled;
@property (nonatomic) BOOL captureLogAsTelemetryData;
@property (nonatomic) BOOL captureConnectivityAsTelemetryData;
@property (nonatomic) BOOL scrubViewInputsTelemetry;
@property (nonatomic, strong) NSSet *telemetryViewInputsToScrub;

#pragma mark - Code version
@property (nonatomic, copy) NSString *codeVersion;

#pragma mark - Server
@property (nonatomic, copy) NSString *serverHost;
@property (nonatomic, copy) NSString *serverRoot;
@property (nonatomic, copy) NSString *serverBranch;
@property (nonatomic, copy) NSString *serverCodeVersion;

#pragma mark - Notifier
@property (nonatomic, copy) NSString *notifierName;
@property (nonatomic, copy) NSString *notifierVersion;
@property (nonatomic, copy) NSString *framework;

#pragma mark - Person
@property (nonatomic, copy) NSString *personId;
@property (nonatomic, copy) NSString *personUsername;
@property (nonatomic, copy) NSString *personEmail;

#pragma mark - Request (an ID to link request between client/server)
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

#pragma mark - Custom data
@property (nonatomic, strong) NSDictionary *customData;

@end

NS_ASSUME_NONNULL_END
