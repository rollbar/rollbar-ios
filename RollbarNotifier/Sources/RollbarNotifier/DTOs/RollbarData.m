//
//  RollbarData.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarData.h"
//#import "DataTransferObject.h"
//#import "DataTransferObject+Protected.h"
#import "RollbarBody.h"
#import "RollbarRequest.h"
#import "RollbarPerson.h"
#import "RollbarServer.h"
#import "RollbarClient.h"
#import "RollbarModule.h"
//#import "JSONSupport.h"

#pragma mark - data field keys

static NSString * const DFK_ENVIRONMENT = @"environment";
static NSString * const DFK_BODY = @"body";
static NSString * const DFK_LEVEL = @"level";
static NSString * const DFK_TIMESTAMP = @"timestamp";
static NSString * const DFK_CODE_VERSION = @"code_version";
static NSString * const DFK_PLATFORM = @"platform";
static NSString * const DFK_LANGUAGE = @"language";
static NSString * const DFK_FRAMEWORK = @"framework";
static NSString * const DFK_CONTEXT = @"context";
static NSString * const DFK_REQUEST = @"request";
static NSString * const DFK_PERSON = @"person";
static NSString * const DFK_SERVER = @"server";
static NSString * const DFK_CLIENT = @"client";
static NSString * const DFK_CUSTOM = @"custom";
static NSString * const DFK_FINGERPRINT = @"fingerprint";
static NSString * const DFK_TITLE = @"title";
static NSString * const DFK_UUID = @"uuid";
static NSString * const DFK_NOTIFIER = @"notifier";

@implementation RollbarData

#pragma mark - properties

- (NSString *)environment {
    return [self getDataByKey:DFK_ENVIRONMENT];
}

- (void)setEnvironment:(NSString *)environment {
    [self setData:environment byKey:DFK_ENVIRONMENT];
}

-(nonnull RollbarBody *)body {
    NSDictionary *data = [self getDataByKey:DFK_BODY];
    if (!data) {
        data = [NSMutableDictionary dictionary];
    }
    return [[RollbarBody alloc] initWithDictionary:data];
}

-(void)setBody:(nonnull RollbarBody *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_BODY];
}

-(RollbarLevel)level {
    NSString *result = [self getDataByKey:DFK_LEVEL];
    return [RollbarLevelUtil RollbarLevelFromString:result];
}

-(void)setLevel:(RollbarLevel)value {
    [self setData:[RollbarLevelUtil RollbarLevelToString:value]
            byKey:DFK_LEVEL];
}

-(NSTimeInterval)timestamp {
    NSNumber *dateNumber = [self getDataByKey:DFK_TIMESTAMP];
    if (nil != dateNumber) {
        return (NSTimeInterval)dateNumber.longValue;
    }
    return 0;
}

-(void)setTimestamp:(NSTimeInterval)value {
    [self setData:[NSNumber numberWithDouble:value] byKey:DFK_TIMESTAMP];
}

-(NSString *)codeVersion {
    NSString *result = [self getDataByKey:DFK_CODE_VERSION];
    return result;
}

-(void)setCodeVersion:(NSString *)value {
    [self setData:value byKey:DFK_CODE_VERSION];
}

-(NSString *)platform {
    NSString *result = [self getDataByKey:DFK_PLATFORM];
    return result;
}

-(void)setPlatform:(NSString *)value {
    [self setData:value byKey:DFK_PLATFORM];
}

-(RollbarAppLanguage)language {
    NSString *result = [self getDataByKey:DFK_LANGUAGE];
    return [RollbarAppLanguageUtil RollbarAppLanguageFromString:result];
}

-(void)setLanguage:(RollbarAppLanguage)value {
    [self setData:[RollbarAppLanguageUtil RollbarAppLanguageToString:value]
            byKey:DFK_LANGUAGE];
}

-(NSString *)framework {
    NSString *result = [self getDataByKey:DFK_FRAMEWORK];
    return result;
}

-(void)setFramework:(NSString *)value {
    [self setData:value byKey:DFK_FRAMEWORK];
}

-(NSString *)context {
    NSString *result = [self getDataByKey:DFK_CONTEXT];
    return result;
}

-(void)setContext:(NSString *)value {
    [self setData:value byKey:DFK_CONTEXT];
}

-(NSString *)fingerprint {
    NSString *result = [self getDataByKey:DFK_FINGERPRINT];
    return result;
}

-(void)setFingerprint:(NSString *)value {
    [self setData:value byKey:DFK_FINGERPRINT];
}

-(NSString *)title {
    NSString *result = [self getDataByKey:DFK_TITLE];
    return result;
}

-(void)setTitle:(NSString *)value {
    [self setData:value byKey:DFK_TITLE];
}

-(NSUUID *)uuid {
    NSString *result = [self getDataByKey:DFK_UUID];
    if (result) {
        return [[NSUUID alloc] initWithUUIDString:result];
    }
    return nil;
}

-(void)setUuid:(NSUUID *)value {
    [self setData:value.UUIDString byKey:DFK_UUID];
}

-(nullable RollbarRequest *)request {
    NSDictionary *data = [self getDataByKey:DFK_REQUEST];
    if (data) {
        return [[RollbarRequest alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setRequest:(nullable RollbarRequest *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_REQUEST];
}

-(nullable RollbarPerson *)person {
    NSDictionary *data = [self getDataByKey:DFK_PERSON];
    if (data) {
        return [[RollbarPerson alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setPerson:(nullable RollbarPerson *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_PERSON];
}

-(nullable RollbarServer *)server {
    NSDictionary *data = [self getDataByKey:DFK_SERVER];
    if (data) {
        return [[RollbarServer alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setServer:(nullable RollbarServer *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_SERVER];
}

-(nullable RollbarClient *)client {
    NSDictionary *data = [self getDataByKey:DFK_CLIENT];
    if (data) {
        return [[RollbarClient alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setClient:(nullable RollbarClient *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_CLIENT];
}


-(nullable RollbarModule *)notifier {
    NSDictionary *data = [self getDataByKey:DFK_NOTIFIER];
    if (data) {
        return [[RollbarModule alloc] initWithDictionary:data];
    }
    return nil;
}

-(void)setNotifier:(nullable RollbarModule *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_NOTIFIER];
}

-(nullable NSObject<RollbarJSONSupport> *)custom {
    id data = [self getDataByKey:DFK_CUSTOM];
    if (!data || (data == [NSNull null]) || [data isKindOfClass:[NSNull class]]) {
        return nil;
    }
    else if ([data isKindOfClass:[NSNumber class]] || [data isKindOfClass:[NSString class]]) {
        return [[RollbarDTO alloc] initWithDictionary:@{@"custom_data":data}];
    }
    else if ([data isKindOfClass:[NSArray class]]) {
        return [[RollbarDTO alloc] initWithArray:data];
    }
    else if ([data isKindOfClass:[NSDictionary class]]) {
        return [[RollbarDTO alloc] initWithDictionary:data];
    }
    else {
        return nil;
    }
}

-(void)setCustom:(nullable NSObject<RollbarJSONSupport> *)value {
    [self setData:value.jsonFriendlyData byKey:DFK_CUSTOM];
}

#pragma mark - initialization

-(instancetype)initWithEnvironment:(nonnull NSString *)environment
                              body:(nonnull RollbarBody *)body {
    
    self = [super initWithDictionary:@{
        DFK_ENVIRONMENT:environment.mutableCopy,
        DFK_BODY:body.jsonFriendlyData
    }];
    return self;
}

-(instancetype)initWithArray:(NSArray *)data {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use initWithDictionary: instead."
                                 userInfo:nil];
}

@end
