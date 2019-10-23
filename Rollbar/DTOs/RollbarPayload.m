//
//  RollbarPayload.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarPayload.h"
#import "DataTransferObject+Protected.h"
#import "RollbarData.h"

static NSString * const DATAFIELD_ACCESSTOKEN = @"accessToken";
static NSString * const DATAFIELD_DATA = @"data";

@implementation RollbarPayload

- (NSString *)accessToken {
    return [self safelyGetStringByKey:DATAFIELD_ACCESSTOKEN];
}

- (void)setAccessToken:(NSString *)accessToken {
    [self setString:accessToken forKey:DATAFIELD_ACCESSTOKEN];
}

- (RollbarData *)data {
    id data = [self safelyGetDictionaryByKey:DATAFIELD_DATA];
    RollbarData *payloadData = [[RollbarData alloc] initWithDictionary:data];
    return payloadData;
}

- (void)setData:(RollbarData *)payloadData {
    [self setDictionary:payloadData.jsonFriendlyData forKey:DATAFIELD_DATA];
}

@end
