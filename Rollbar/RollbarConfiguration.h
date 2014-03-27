//
//  RollbarConfiguration.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/21/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DEFAULT_ENDPOINT = @"https://api.rollbar.com/api/1/items/";

@interface RollbarConfiguration : NSObject

+ (RollbarConfiguration*)configuration;

@property (atomic, copy) NSString *accessToken;
@property (atomic, copy) NSString *environment;
@property (atomic, copy) NSString *endpoint;

@end
