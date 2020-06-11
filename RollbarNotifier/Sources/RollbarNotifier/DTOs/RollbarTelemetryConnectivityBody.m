//
//  RollbarTelemetryConnectivityBody.m
//  Rollbar
//
//  Created by Andrey Kornich on 2020-02-28.
//  Copyright © 2020 Rollbar. All rights reserved.
//

#import "RollbarTelemetryConnectivityBody.h"
//#import "DataTransferObject+Protected.h"

#pragma mark - constants

#pragma mark - data field keys

static NSString * const DFK_STATUS = @"change";

#pragma mark - class implementation

@implementation RollbarTelemetryConnectivityBody

#pragma mark - initializers

-(instancetype)initWithStatus:(nonnull NSString *)status
                    extraData:(nullable NSDictionary *)extraData {
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    if (extraData) {
        [data addEntriesFromDictionary:extraData];
    }
    [data setObject:status forKey:DFK_STATUS];
    self = [super initWithDictionary:data];
    return self;
}

-(instancetype)initWithStatus:(nonnull NSString *)status {
    return [self initWithStatus:status extraData:nil];
}

- (instancetype)initWithArray:(NSArray *)data {

    return [super initWithArray:data];
}

- (instancetype)initWithDictionary:(NSDictionary *)data {

    return [super initWithDictionary:data];
}

#pragma mark - property accessors

- (NSString *)status {
    NSString *result = [self safelyGetStringByKey:DFK_STATUS];
    return result;
}

- (void)setStatus:(NSString *)value {
    [self setString:value forKey:DFK_STATUS];
}

@end
