//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarLevel.h"
#import "RollbarTelemetryType.h"

#define NSLog(args...) [RollbarTelemetry NSLogReplacement:args];

@interface RollbarTelemetry : NSObject

+ (instancetype)sharedInstance;
+ (void)NSLogReplacement:(NSString *)format, ...;

#pragma mark -

- (void)setCaptureLog:(BOOL)shouldCapture;
- (void)setDataLimit:(NSInteger)dataLimit;

#pragma mark -

- (void)recordEventForLevel:(RollbarLevel)level
                       type:(RollbarTelemetryType)type
                       data:(NSDictionary *)data;

- (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element
                      extraData:(NSDictionary *)extraData;

- (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode
                         extraData:(NSDictionary *)extraData;

- (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status
                              extraData:(NSDictionary *)extraData;

- (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message
                       extraData:(NSDictionary *)extraData;

- (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to
                            extraData:(NSDictionary *)extraData;

- (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(NSDictionary *)extraData;

- (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message
                     extraData:(NSDictionary *)extraData;

#pragma mark -

- (NSArray *)getAllData;
- (void)clearAllData;

@property (readwrite, atomic) BOOL enabled;
@property (readwrite, atomic) BOOL scrubViewInputs;
@property (atomic, retain) NSMutableSet *viewInputsToScrub;

@end
