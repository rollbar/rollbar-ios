//
//  RollbarTelemetryNetworkBody.m
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#import "RollbarTelemetryNetworkBody.h"
//#import "DataTransferObject+Protected.h"

#pragma mark - constants

#pragma mark - data field keys

static NSString * const DFK_METHOD = @"method";
static NSString * const DFK_URL = @"url";
static NSString * const DFK_STATUS_CODE = @"status_code";

#pragma mark - class implementation

@implementation RollbarTelemetryNetworkBody

#pragma mark - initializers

-(instancetype)initWithMethod:(RollbarHttpMethod)method
                          url:(nonnull NSString *)url
                   statusCode:(nonnull NSString *)statusCode
                    extraData:(nullable NSDictionary *)extraData {

    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }
    [data setObject:[RollbarHttpMethodUtil HttpMethodToString:method] forKey:DFK_METHOD];
    [data setObject:url forKey:DFK_URL];
    [data setObject:statusCode forKey:DFK_STATUS_CODE];
    self = [super initWithDictionary:data];
    return self;
}

-(instancetype)initWithMethod:(RollbarHttpMethod)method
                          url:(nonnull NSString *)url
                   statusCode:(nonnull NSString *)statusCode {
    return [self initWithMethod:method
                            url:url
                     statusCode:statusCode
                      extraData:nil];
}

- (instancetype)initWithArray:(NSArray *)data {

    return [super initWithArray:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)data {

    return [super initWithDictionary:data];
}

#pragma mark - property accessors

-(RollbarHttpMethod)method {
    NSString *result = [self getDataByKey:DFK_METHOD];
    return [RollbarHttpMethodUtil HttpMethodFromString:result];
}

-(void)setMethod:(RollbarHttpMethod)value {
    [self setData:[RollbarHttpMethodUtil HttpMethodToString:value]
            byKey:DFK_METHOD];
}

- (NSString *)url {
    NSString *result = [self safelyGetStringByKey:DFK_URL];
    return result;
}

- (void)setUrl:(NSString *)value {
    [self setString:value forKey:DFK_URL];
}

- (NSString *)statusCode {
    NSString *result = [self safelyGetStringByKey:DFK_STATUS_CODE];
    return result;
}

- (void)setStatusCode:(NSString *)value {
    [self setString:value forKey:DFK_STATUS_CODE];
}

@end
