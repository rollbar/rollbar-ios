//
//  RollbarTelemetry.h
//  Rollbar
//
//  Created by Ben Wong on 11/21/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rollbar.h"

#define NSLog(args...) [RollbarTelemetry NSLogReplacement:args];

@interface RollbarTelemetry : NSObject {
    NSMutableArray *telemetryData;
}

+ (instancetype)sharedInstance;
+ (void)NSLogReplacement:(NSString *)format, ...;

- (void)recordEventForLevel:(RollbarLevel)level type:(RollbarTelemetryType)type data:(NSDictionary *)data;

- (void)recordDomEventForLevel:(RollbarLevel)level element:(NSString *)element;
- (void)recordDomEventForLevel:(RollbarLevel)level element:(NSString *)element extraData:(NSDictionary *)extraData;
- (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode;
- (void)recordNetworkEventForLevel:(RollbarLevel)level method:(NSString *)method url:(NSString *)url statusCode:(NSString *)statusCode extraData:(NSDictionary *)extraData;
- (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status;
- (void)recordConnectivityEventForLevel:(RollbarLevel)level status:(NSString *)status extraData:(NSDictionary *)extraData;
- (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message;
- (void)recordErrorEventForLevel:(RollbarLevel)level exception:(NSException *)exception;
- (void)recordErrorEventForLevel:(RollbarLevel)level message:(NSString *)message extraData:(NSDictionary *)extraData;
- (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to;
- (void)recordNavigationEventForLevel:(RollbarLevel)level from:(NSString *)from to:(NSString *)to extraData:(NSDictionary *)extraData;
- (void)recordManualEventForLevel:(RollbarLevel)level withData:(NSDictionary *)extraData;

@end
