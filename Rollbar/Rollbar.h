//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

#import <Foundation/Foundation.h>
#import "RollbarConfiguration.h"
#import "RollbarNotifier.h"
#import "RollbarLevel.h"
#import "RollbarTelemetry.h"
#import "RollbarTelemetryType.h"

@interface Rollbar : NSObject

+ (void)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration
        enableCrashReporter:(BOOL)enable;
+ (void)initWithAccessToken:(NSString*)accessToken;
+ (void)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration;

+ (RollbarConfiguration*)currentConfiguration;
+ (RollbarNotifier*)currentNotifier;

+ (void)updateConfiguration:(RollbarConfiguration*)configuration isRoot:(BOOL)isRoot;

// Old logging methods, for backward compatibility

+ (void)logWithLevel:(NSString*)level message:(NSString*)message;
+ (void)logWithLevel:(NSString*)level message:(NSString*)message data:(NSDictionary*)data;
+ (void)logWithLevel:(NSString*)level message:(NSString*)message data:(NSDictionary*)data context:(NSString*)context;
+ (void)logWithLevel:(NSString*)level data:(NSDictionary*)data;

+ (void)debugWithMessage:(NSString*)message;
+ (void)debugWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)debugWithData:(NSDictionary*)data;

+ (void)infoWithMessage:(NSString*)message;
+ (void)infoWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)infoWithData:(NSDictionary*)data;

+ (void)warningWithMessage:(NSString*)message;
+ (void)warningWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)warningWithData:(NSDictionary*)data;

+ (void)errorWithMessage:(NSString*)message;
+ (void)errorWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)errorWithData:(NSDictionary*)data;

+ (void)criticalWithMessage:(NSString*)message;
+ (void)criticalWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)criticalWithData:(NSDictionary*)data;

// New logging methods

+ (void)log:(RollbarLevel)level message:(NSString*)message;
+ (void)log:(RollbarLevel)level message:(NSString*)message exception:(NSException*)exception;
+ (void)log:(RollbarLevel)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)log:(RollbarLevel)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;

+ (void)debug:(NSString*)message;
+ (void)debug:(NSString*)message exception:(NSException*)exception;
+ (void)debug:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)debug:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;

+ (void)info:(NSString*)message;
+ (void)info:(NSString*)message exception:(NSException*)exception;
+ (void)info:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)info:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;

+ (void)warning:(NSString*)message;
+ (void)warning:(NSString*)message exception:(NSException*)exception;
+ (void)warning:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)warning:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;

+ (void)error:(NSString*)message;
+ (void)error:(NSString*)message exception:(NSException*)exception;
+ (void)error:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)error:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;

+ (void)critical:(NSString*)message;
+ (void)critical:(NSString*)message exception:(NSException*)exception;
+ (void)critical:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)critical:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data context:(NSString*)context;

+ (void)logCrashReport:(NSString*)crashReport;

// Send JSON payload

+ (void)sendJsonPayload:(NSData*)payload;

// Telemetry logging

+ (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element;
+ (void)recordViewEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData;
+ (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode;
+ (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode extraData:(NSDictionary *)extraData;
+ (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status;
+ (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status extraData:(NSDictionary *)extraData;
+ (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message;
+ (void)recordErrorEventForLevel:(RollbarLevel)level exception:(NSException *)exception;
+ (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData;
+ (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to;
+ (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to extraData:(NSDictionary *)extraData;
+ (void)recordManualEventForLevel:(RollbarLevel)level withData:(NSDictionary *)extraData;

@end
