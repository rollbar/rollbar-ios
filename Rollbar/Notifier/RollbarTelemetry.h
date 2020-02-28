//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarLevel.h"
#import "RollbarTelemetryType.h"

#define NSLog(args...) [RollbarTelemetry NSLogReplacement:args];

/// RollbarTelemetry application wide "service" component
@interface RollbarTelemetry : NSObject

/// Shared service instance/singleton
+ (instancetype)sharedInstance;

/// NSLog replacement
/// @param format NSLog entry format
+ (void)NSLogReplacement:(NSString *)format, ...;

#pragma mark - Config options

/// Telemetry collection enable/disable switch
@property (readwrite, atomic) BOOL enabled;

/// Enable/disable switch for scrubbing View inputs
@property (readwrite, atomic) BOOL scrubViewInputs;

/// Set of View inputs to scrub
@property (atomic, retain) NSMutableSet *viewInputsToScrub;

/// Sets whether or not to use replacement log.
/// @param shouldCapture YES/NO flag for the log capture
- (void)setCaptureLog:(BOOL)shouldCapture;

/// Sets max number of telemetry events to capture.
/// @param dataLimit the max total events limit
- (void)setDataLimit:(NSInteger)dataLimit;

#pragma mark - Telemetry data/event recording methods

/// Records/captures a telemetry event
/// @param level relevant Rollbar log level
/// @param type telemetry event type
/// @param data event data
- (void)recordEventForLevel:(RollbarLevel)level
                       type:(RollbarTelemetryType)type
                       data:(NSDictionary *)data;

/// Records/captures a telemetry View event
/// @param level relevant Rollbar log level
/// @param element view element
/// @param extraData event data
- (void)recordViewEventForLevel:(RollbarLevel)level
                        element:(NSString *)element
                      extraData:(NSDictionary *)extraData;

/// Records/captures a telemetry Network event
/// @param level relevant Rollbar log level
/// @param method call method
/// @param url call URL
/// @param statusCode call status code
/// @param extraData event data
- (void)recordNetworkEventForLevel:(RollbarLevel)level
                            method:(NSString *)method
                               url:(NSString *)url
                        statusCode:(NSString *)statusCode
                         extraData:(NSDictionary *)extraData;

/// Records/captures a telemetry Connectivity event
/// @param level relevant Rollbar log level
/// @param status connectivity status
/// @param extraData event data
- (void)recordConnectivityEventForLevel:(RollbarLevel)level
                                 status:(NSString *)status
                              extraData:(NSDictionary *)extraData;

/// Records/captures a telemetry Error event
/// @param level relevant Rollbar log level
/// @param message error message
/// @param extraData event data
- (void)recordErrorEventForLevel:(RollbarLevel)level
                         message:(NSString *)message
                       extraData:(NSDictionary *)extraData;

/// Records/captures a telemetry Error event
/// @param level relevant Rollbar log level
/// @param from navigation starting point
/// @param to navigation end point
/// @param extraData event data
- (void)recordNavigationEventForLevel:(RollbarLevel)level
                                 from:(NSString *)from
                                   to:(NSString *)to
                            extraData:(NSDictionary *)extraData;

/// Records/captures a telemetry Manual/Custom event
/// @param level relevant Rollbar log level
/// @param extraData event data
- (void)recordManualEventForLevel:(RollbarLevel)level
                         withData:(NSDictionary *)extraData;

/// Records/captures a telemetry Log event
/// @param level relevant Rollbar log level
/// @param message log message
/// @param extraData event data
- (void)recordLogEventForLevel:(RollbarLevel)level
                       message:(NSString *)message
                     extraData:(NSDictionary *)extraData;

#pragma mark - Tlemetry cache access methods

/// Gets all the currently captured telemetry data/events
- (NSArray *)getAllData;

/// Clears all the currently captured telemetry data/events
- (void)clearAllData;


@end
