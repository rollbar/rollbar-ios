//
//  RollbarNotifier.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollbarNotifier : NSObject

@property (atomic, copy) NSString *accessToken;
@property (atomic, copy) NSString *environment;
@property (atomic, copy) NSString *endpoint;

- (id)initWithAccessToken:(NSString*)accessToken environment:(NSString*)environment;
- (void)uncaughtException:(NSException*)exception;

- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

- (NSDictionary*)buildPayloadWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra;

@end
