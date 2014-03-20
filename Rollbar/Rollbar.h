//
//  Rollbar.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rollbar : NSObject

+ (void)initWithAccessToken:(NSString*)accessToken environment:(NSString*)environment;

+ (void)logWithLevel:(NSString*)level message:(NSString*)message;
+ (void)logWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception;
+ (void)logWithLevel:(NSString*)level message:(NSString*)message data:(NSDictionary*)data;
+ (void)logWithLevel:(NSString*)level exception:(NSException*)exception;
+ (void)logWithLevel:(NSString*)level exception:(NSException*)exception data:(NSDictionary*)data;
+ (void)logWithLevel:(NSString*)level data:(NSDictionary*)data;
+ (void)logWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

+ (void)debugWithMessage:(NSString*)message;
+ (void)debugWithMessage:(NSString*)message exception:(NSException*)exception;
+ (void)debugWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)debugWithException:(NSException*)exception;
+ (void)debugWithException:(NSException*)exception data:(NSDictionary*)data;
+ (void)debugWithData:(NSDictionary*)data;
+ (void)debug:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

+ (void)infoWithMessage:(NSString*)message;
+ (void)infoWithMessage:(NSString*)message exception:(NSException*)exception;
+ (void)infoWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)infoWithException:(NSException*)exception;
+ (void)infoWithException:(NSException*)exception data:(NSDictionary*)data;
+ (void)infoWithData:(NSDictionary*)data;
+ (void)info:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

+ (void)warningWithMessage:(NSString*)message;
+ (void)warningWithMessage:(NSString*)message exception:(NSException*)exception;
+ (void)warningWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)warningWithException:(NSException*)exception;
+ (void)warningWithException:(NSException*)exception data:(NSDictionary*)data;
+ (void)warningWithData:(NSDictionary*)data;
+ (void)warning:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

+ (void)errorWithMessage:(NSString*)message;
+ (void)errorWithMessage:(NSString*)message exception:(NSException*)exception;
+ (void)errorWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)errorWithException:(NSException*)exception;
+ (void)errorWithException:(NSException*)exception data:(NSDictionary*)data;
+ (void)errorWithData:(NSDictionary*)data;
+ (void)error:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

+ (void)criticalWithMessage:(NSString*)message;
+ (void)criticalWithMessage:(NSString*)message exception:(NSException*)exception;
+ (void)criticalWithMessage:(NSString*)message data:(NSDictionary*)data;
+ (void)criticalWithException:(NSException*)exception;
+ (void)criticalWithException:(NSException*)exception data:(NSDictionary*)data;
+ (void)criticalWithData:(NSDictionary*)data;
+ (void)critical:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

@end
