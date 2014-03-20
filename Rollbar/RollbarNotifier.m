//
//  RollbarNotifier.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import "RollbarNotifier.h"


@interface RollbarNotifier()

@end

@implementation RollbarNotifier

static NSString *NOTIFIER_VERSION = @"0.0.1";
static NSString *DEFAULT_ENDPOINT = @"https://api.rollbar.com/api/1/items/";

- (id)initWithAccessToken:(NSString*)accessToken environment:(NSString*)environment {
    if((self = [super init])) {
        self.accessToken = accessToken;
        self.environment = environment;
        
        self.endpoint = DEFAULT_ENDPOINT;
    }
    
    return self;
}

- (void)uncaughtException:(NSException *)exception {
    [self log:@"error" message:nil exception:exception data:nil];
}

- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    NSDictionary *payload = [self buildPayloadWithLevel:level message:message exception:exception extra:data];
    
    
    NSLog(@"%@", payload);
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    [self sendPayload:jsonPayload];
}

- (NSDictionary*)buildNotifierData {
    NSNumber *timestamp = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]];
    
    NSDictionary *data = @{@"timestamp": timestamp};
    
    return data;
}

- (NSDictionary*)buildPayloadWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra {
    
    NSDictionary *clientData = [self buildNotifierData];
    NSDictionary *notifierData = @{@"name": @"rollbar-ios",
                                   @"version": NOTIFIER_VERSION};
    
    NSDictionary *body = [self buildPayloadBodyWithMessage:message exception:exception extra:extra];
    
    NSDictionary *data = [@{@"environment": self.environment,
                           @"level": level,
                           @"language": @"Objective-C",
                           @"framework": @"ios",
                           @"platform": @"ios",
                           @"uuid": [self generateUUID],
                           @"client": clientData,
                           @"notifier": notifierData,
                           @"body": body} mutableCopy];
    
    
    return @{@"access_token": self.accessToken,
             @"data": @[data]};
}

- (NSDictionary*)buildPayloadBodyWithException:(NSException*)exception description:(NSString*)description extra:(NSDictionary*)extra {
    return @{};
}

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message extra:(NSDictionary*)extra {
    NSMutableDictionary *result = [@{@"body": message} mutableCopy];
    
    if (extra) {
        result[@"extra"] = extra;
    }
    
    return @{@"message": result};
}

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra {
    if (exception) {
        return [self buildPayloadBodyWithException:exception description:message extra:extra];
    } else {
        return [self buildPayloadBodyWithMessage:message extra:extra];
    }
}

- (void)sendPayload:(NSData*)payload {
    NSURL *url = [NSURL URLWithString:self.endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.accessToken forHTTPHeaderField:@"X-Rollbar-Access-Token"];
    [request setHTTPBody:payload];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"Error %@; %@", error, [error localizedDescription]);
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 200) {
                NSLog(@"Success");
            } else {
                NSLog(@"There was a problem reporting to Rollbar");
                NSLog(@"Response: %@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
            }
        }
    }];
}

- (NSString*)generateUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    return (__bridge NSString *)string;
}

@end
