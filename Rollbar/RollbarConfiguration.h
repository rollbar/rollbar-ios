//
//  RollbarConfiguration.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/21/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *DEFAULT_ENDPOINT = @"https://api.rollbar.com/api/1/items/";

@interface RollbarConfiguration : NSObject

+ (RollbarConfiguration*)configuration;

- (void)setPersonId:(NSString*)personId username:(NSString*)username email:(NSString*)email;

@property (atomic, copy) NSString *accessToken;
@property (atomic, copy) NSString *environment;
@property (atomic, copy) NSString *endpoint;
@property (atomic, copy) NSString *crashLevel;
@property (readonly, atomic, copy) NSString *personId;
@property (readonly, atomic, copy) NSString *personUsername;
@property (readonly, atomic, copy) NSString *personEmail;

@end
