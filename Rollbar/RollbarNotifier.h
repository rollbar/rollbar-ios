//
//  RollbarNotifier.h
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RollbarConfiguration.h"

@interface RollbarNotifier : NSObject

@property (atomic, strong) RollbarConfiguration *configuration;

- (id)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration;

- (void)logCrashReport:(NSString*)crashReport;
- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data;

@end
