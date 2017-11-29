//
//  Rollbar.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RollbarConfiguration.h"
#import "RollbarNotifier.h"

typedef enum {
    RollbarInfo,
    RollbarDebug,
    RollbarWarning,
    RollbarCritical,
    RollbarError
} RollbarLevel;

@interface Rollbar : NSObject

+ (void)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration
        enableCrashReporter:(BOOL)enable;
+ (void)initWithAccessToken:(NSString*)accessToken;
+ (void)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration;

+ (RollbarConfiguration*)currentConfiguration;
+ (RollbarNotifier*)currentNotifier;

+ (NSString*)stringFromLevel:(RollbarLevel)level;

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

@end
