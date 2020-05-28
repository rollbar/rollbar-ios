//
//  RollbarServer.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarServerConfig.h"
//#import "DataTransferObject+Protected.h"

#pragma mark - constants

static NSString *const DEFAULT_HOST = @"unknown";
static NSString *const DEFAULT_ROOT = @"/";
static NSString *const DEFAULT_BRANCH = @"unknown";
static NSString *const DEFAULT_CODE_VERSION = @"n.n.n";

#pragma mark - data field keys

static NSString * const DFK_HOST = @"host";
static NSString * const DFK_ROOT = @"root";
static NSString * const DFK_BRANCH = @"branch";
static NSString * const DFK_CODE_VERSION = @"code_version";

#pragma mark - class implementation

@implementation RollbarServerConfig

#pragma mark - initializers

- (instancetype)initWithHost:(nullable NSString *)host
                        root:(nullable NSString *)root
                      branch:(nullable NSString *)branch
                 codeVersion:(nullable NSString *)codeVersion {
    self = [super initWithDictionary:@{
        DFK_HOST: host ? host : [NSNull null],
        DFK_ROOT: root ? root : [NSNull null],
        DFK_BRANCH: branch ? branch : [NSNull null],
        DFK_CODE_VERSION: codeVersion ? codeVersion : [NSNull null]
    }];
    return self;
}

#pragma mark - property accessors

- (nullable NSString *)host {
    return [self getDataByKey:DFK_HOST];
}

- (void)setHost:(nullable NSString *)value {
    [self setData:value byKey:DFK_HOST];
}

- (nullable NSString *)root {
    return [self getDataByKey:DFK_ROOT];
}

- (void)setRoot:(nullable NSString *)value {
    [self setData:value byKey:DFK_ROOT];
}

- (nullable NSString *)branch {
    return [self getDataByKey:DFK_BRANCH];
}

- (void)setBranch:(nullable NSString *)value {
    [self setData:value byKey:DFK_BRANCH];
}

- (nullable NSString *)codeVersion {
    return [self getDataByKey:DFK_CODE_VERSION];
}

- (void)setCodeVersion:(nullable NSString *)value {
    [self setData:value byKey:DFK_CODE_VERSION];
}

@end
