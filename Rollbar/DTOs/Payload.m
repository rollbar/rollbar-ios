//
//  Payload.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "Payload.h"
#import "DataTransferObject+Protected.h"
#import "PayloadData.h"

static NSString * const DATAFIELD_ACCESSTOKEN = @"accessToken";
static NSString * const DATAFIELD_DATA = @"data";

@implementation Payload

- (NSMutableString *)accessToken {
    return [self saflyGetStringByKey:DATAFIELD_ACCESSTOKEN];
}

- (void)setAccessToken:(NSMutableString *)accessToken {
    [self setString:accessToken forKey:DATAFIELD_ACCESSTOKEN];
}

- (PayloadData *)data {
    id data = [self saflyGetDictionaryByKey:DATAFIELD_DATA];
    PayloadData *payloadData = [[PayloadData alloc] initWithDictionary:data];
    return payloadData;
}

- (void)setData:(PayloadData *)payloadData {
    [self setDictionary:payloadData.jsonFriendlyData forKey:DATAFIELD_DATA];
}

@end
