//
//  RollbarConfig.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-11.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarCaptureIpType.h"
#import "RollbarLevel.h"

@import RollbarCommon;

@class RollbarDestination;
@class RollbarDeveloperOptions;
@class RollbarProxy;
@class RollbarScrubbingOptions;
@class RollbarServerConfig;
@class RollbarPerson;
@class RollbarModule;
@class RollbarTelemetryOptions;
@class RollbarLoggingOptions;
@class RollbarData;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarConfig : RollbarDTO {
    BOOL _isRootConfiguration;
}

#pragma mark - properties
@property (nonnull, nonatomic, strong) RollbarDestination *destination;
@property (nonnull, nonatomic, strong) RollbarDeveloperOptions *developerOptions;
@property (nonnull, nonatomic, strong) RollbarLoggingOptions *loggingOptions;
@property (nonnull, nonatomic, strong) RollbarProxy *httpProxy;
@property (nonnull, nonatomic, strong) RollbarProxy *httpsProxy;
@property (nonnull, nonatomic, strong) RollbarScrubbingOptions *dataScrubber;
@property (nonnull, nonatomic, strong) RollbarServerConfig *server;
@property (nonnull, nonatomic, strong) RollbarPerson *person;
@property (nonnull, nonatomic, strong) RollbarModule *notifier;
@property (nonnull, nonatomic, strong) RollbarTelemetryOptions *telemetry;

#pragma mark - Custom data
@property (nonatomic, strong) NSDictionary<NSString *, id> *customData;


#pragma mark - Payload Content Related
// Decides whether or not to send provided payload data. Returns true to ignore, false to send
@property (nullable, nonatomic, copy) BOOL (^checkIgnoreRollbarData)(RollbarData *rollbarData);
// Modify payload data
@property (nullable, nonatomic, copy) RollbarData *(^modifyRollbarData)(RollbarData *rollbarData);


#pragma mark - Convenience Methods
- (void)setPersonId:(NSString *)personId
           username:(NSString *)username
              email:(NSString *)email;
- (void)setServerHost:(NSString *)host
                 root:(NSString *)root
               branch:(NSString *)branch
          codeVersion:(NSString *)codeVersion;
- (void)setNotifierName:(NSString *)name
                version:(NSString *)version;


@end

NS_ASSUME_NONNULL_END
