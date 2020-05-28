//
//  RollbarRequest.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarRequest.h"
//#import "DataTransferObject+Protected.h"

static NSString * const DFK_URL = @"url";
static NSString * const DFK_METHOD = @"method";
static NSString * const DFK_HEADERS = @"headers";
static NSString * const DFK_PARAMS = @"params";
static NSString * const DFK_GET_PARAMS = @"GET";
static NSString * const DFK_QUERY_STRING = @"query_string";
static NSString * const DFK_POST_PARAMS = @"POST";
static NSString * const DFK_POST_BODY = @"body";
static NSString * const DFK_USER_IP = @"user_ip";

@implementation RollbarRequest

#pragma mark - Properties

- (nullable NSString *)url {
    return [self getDataByKey:DFK_URL];
}

- (void)setUrl:(nullable NSString *)url {
    [self setData:url byKey:DFK_URL];
}

- (RollbarHttpMethod)method {
    return [RollbarHttpMethodUtil HttpMethodFromString:[self getDataByKey:DFK_METHOD]];
}

- (void)setMethod:(RollbarHttpMethod)method {
    [self setData:[RollbarHttpMethodUtil HttpMethodToString:method] byKey:DFK_METHOD];
}

- (nullable NSDictionary *)headers {
    return [self getDataByKey:DFK_HEADERS];
}

- (void)setHeaders:(nullable NSDictionary *)headers {
    [self setData:headers byKey:DFK_HEADERS];
}

- (nullable NSDictionary *)params {
    return [self getDataByKey:DFK_PARAMS];
}

- (void)setParams:(nullable NSDictionary *)params {
    [self setData:params byKey:DFK_PARAMS];
}

- (nullable NSDictionary *)getParams {
    return [self getDataByKey:DFK_GET_PARAMS];
}

- (void)setGetParams:(nullable NSDictionary *)getParams {
    [self setData:getParams byKey:DFK_GET_PARAMS];
}

- (nullable NSString *)queryString {
    return [self getDataByKey:DFK_QUERY_STRING];
}

- (void)setQueryString:(nullable NSString *)queryString {
    [self setData:queryString byKey:DFK_QUERY_STRING];
}

- (nullable NSDictionary *)postParams {
    return [self getDataByKey:DFK_POST_PARAMS];
}

- (void)setPostParams:(nullable NSDictionary *)postParams {
    [self setData:postParams byKey:DFK_POST_PARAMS];
}

- (nullable NSString *)postBody {
    return [self getDataByKey:DFK_POST_BODY];
}

- (void)setPostBody:(nullable NSString *)postBody {
    [self setData:postBody byKey:DFK_POST_BODY];
}

- (nullable NSString *)userIP {
    return [self getDataByKey:DFK_USER_IP];
}

- (void)setUserIP:(nullable NSString *)userIP {
    [self setData:userIP byKey:DFK_USER_IP];
}

#pragma mark - Initializers

- (instancetype)initWithHttpMethod:(RollbarHttpMethod)httpMethod
                               url:(nullable NSString *)url
                           headers:(nullable NSDictionary *)headers
                            params:(nullable NSDictionary *)params
                       queryString:(nullable NSString *)queryString
                         getParams:(nullable NSDictionary *)getParams
                        postParams:(nullable NSDictionary *)postParams
                          postBody:(nullable NSString *)postBody
                            userIP:(nullable NSString *)userIP {
    
    self = [super initWithDictionary:@{
        DFK_METHOD: [RollbarHttpMethodUtil HttpMethodToString:httpMethod],
        DFK_URL: url ? url : [NSNull null],
        DFK_HEADERS: headers ? headers : [NSNull null],
        DFK_PARAMS: params ? params : [NSNull null],
        DFK_QUERY_STRING: queryString ? queryString : [NSNull null],
        DFK_GET_PARAMS: getParams ? getParams : [NSNull null],
        DFK_POST_PARAMS: postParams ? postParams : [NSNull null],
        DFK_POST_BODY: postBody ? postBody : [NSNull null],
        DFK_USER_IP: userIP ? userIP : [NSNull null]
    }];
    return self;
}

@end
