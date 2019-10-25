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
@class RollbarScrubbingOptions;
@class RollbarServer;
@class RollbarPerson;
@class RollbarModule;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarConfig : DataTransferObject
#pragma mark - properties
@property (nonatomic, strong) RollbarDestination *destination;
@property (nonatomic, strong) RollbarDeveloperOptions *developerOptions;
@property (nonatomic, strong) RollbarProxy *httpProxy;
@property (nonatomic, strong) RollbarProxy *httpsProxy;
@property (nonatomic, strong) RollbarScrubbingOptions *dataScrubber;
@property (nonatomic, strong) RollbarServer *server;
@property (nonatomic, strong) RollbarPerson *person;
@property (nonatomic, strong) RollbarModule *notifier;

#pragma mark - Developer Options
#pragma mark - HTTP Proxy Settings
#pragma mark - HTTPS Proxy Settings
#pragma mark - Server
#pragma mark - Person
#pragma mark - Notifier

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
//@property (nonatomic, strong) NSSet *scrubFields;
// Fields to not scrub from the payload even if they mention among scrubFields:
//@property (nonatomic, strong) NSSet *scrubWhitelistFields;
@property (nonatomic) CaptureIpType captureIp;

#pragma mark - Telemetry
@property (nonatomic) BOOL telemetryEnabled;
@property (nonatomic) BOOL captureLogAsTelemetryData;
@property (nonatomic) BOOL captureConnectivityAsTelemetryData;
@property (nonatomic) BOOL scrubViewInputsTelemetry;
@property (nonatomic, strong) NSArray *telemetryViewInputsToScrub;

#pragma mark - Code version
@property (nonatomic, copy) NSString *codeVersion;

@property (nonatomic, copy) NSString *framework;


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
