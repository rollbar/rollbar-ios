//
//  RollbarModule.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarModule.h"
//@import RollbarCommon;

#pragma mark - constants

static NSString *const DEFAULT_VERSION = nil;

#pragma mark - data field keys

static NSString * const DFK_NAME = @"name";
static NSString * const DFK_VERSION = @"version";

#pragma mark - class implementation

@implementation RollbarModule

#pragma mark - initializers

- (instancetype)initWithName:(nullable NSString *)name
                     version:(nullable NSString *)version {
    
    self = [super initWithDictionary:@{
        DFK_NAME:name ? name : [NSNull null],
        DFK_VERSION:version ? version : [NSNull null]
    }];
    return self;
}

- (instancetype)initWithName:(nullable NSString *)name {
    
    return [self initWithName:name version:DEFAULT_VERSION];
}

#pragma mark - property accessors

- (nullable NSString *)name {
   return [self getDataByKey:DFK_NAME];
}

- (void)setName:(nullable NSString *)value {
    [self setData:value byKey:DFK_NAME];
}

- (nullable NSString *)version {
    return [self getDataByKey:DFK_VERSION];
}

- (void)setVersion:(nullable NSString *)value {
    [self setData:value byKey:DFK_VERSION];
}

@end
