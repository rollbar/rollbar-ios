//
//  RollbarTelemetryLogBody.m
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#import "RollbarTelemetryLogBody.h"
//#import "DataTransferObject+Protected.h"

#pragma mark - constants

#pragma mark - data field keys

static NSString * const DFK_MESSAGE = @"message";

#pragma mark - class implementation

@implementation RollbarTelemetryLogBody

#pragma mark - initializers

-(instancetype)initWithMessage:(nonnull NSString *)message
                     extraData:(nullable NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }
    [data setObject:message forKey:DFK_MESSAGE];
    self = [super initWithDictionary:data];
    return self;
}

-(instancetype)initWithMessage:(nonnull NSString *)message {
    return [self initWithMessage:message extraData:nil];
}

- (instancetype)initWithArray:(NSArray *)data {

    return [super initWithArray:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)data {

    return [super initWithDictionary:data];
}

#pragma mark - property accessors

- (NSString *)message {
    NSString *result = [self safelyGetStringByKey:DFK_MESSAGE];
    return result;
}

- (void)setMessage:(NSString *)value {
    [self setString:value forKey:DFK_MESSAGE];
}

@end
