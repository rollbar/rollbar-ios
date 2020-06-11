//
//  RollbarPayload.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarPayload.h"
//#import "DataTransferObject+Protected.h"
#import "RollbarData.h"

#pragma mark - data field keys

static NSString * const DFK_ACCESSTOKEN = @"access_token";
static NSString * const DFK_DATA = @"data";

@implementation RollbarPayload

#pragma mark - properties

- (NSString *)accessToken {
    return [self safelyGetStringByKey:DFK_ACCESSTOKEN];
}

- (void)setAccessToken:(NSString *)accessToken {
    [self setString:accessToken forKey:DFK_ACCESSTOKEN];
}

- (RollbarData *)data {
    id data = [self safelyGetDictionaryByKey:DFK_DATA];
    RollbarData *payloadData = [[RollbarData alloc] initWithDictionary:data];
    return payloadData;
}

- (void)setData:(RollbarData *)payloadData {
    [self setDictionary:payloadData.jsonFriendlyData forKey:DFK_DATA];
}

#pragma mark - initializers

-(instancetype)initWithAccessToken:(nonnull NSString *)token
                              data:(nonnull RollbarData *)data {
    
    self = [super initWithDictionary:@{
        DFK_ACCESSTOKEN : token,
        DFK_DATA : data.jsonFriendlyData
    }];
    return self;
}

-(instancetype)initWithArray:(NSArray *)data {
    
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use initWithDictionary: instead."
                                 userInfo:nil];
}

@end
