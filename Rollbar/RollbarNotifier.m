//
//  RollbarNotifier.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "RollbarNotifier.h"
#import <UIKit/UIKit.h>
#include <sys/utsname.h>


@interface RollbarNotifier()

@end

@implementation RollbarNotifier

static NSString *NOTIFIER_VERSION = @"0.0.2";

- (id)initWithAccessToken:(NSString*)accessToken configuration:(RollbarConfiguration*)configuration {
    
    if((self = [super init])) {
        if (configuration) {
            self.configuration = configuration;
        } else {
            self.configuration = [RollbarConfiguration configuration];
        }
        
        self.configuration.accessToken = accessToken;
    }
    
    return self;
}

- (void)logCrashReport:(NSString*)crashReport {
    NSDictionary *payload = [self buildPayloadWithLevel:self.configuration.crashLevel message:nil exception:nil extra:nil crashReport:crashReport];
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    [self sendPayload:jsonPayload];
}

- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    NSDictionary *payload = [self buildPayloadWithLevel:level message:message exception:exception extra:data crashReport:nil];
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    [self sendPayload:jsonPayload];
}

- (NSDictionary*)buildPersonData {
    NSMutableDictionary *personData = [NSMutableDictionary dictionary];
    
    if (self.configuration.personId) {
        personData[@"id"] = self.configuration.personId;
    }
    if (self.configuration.personUsername) {
        personData[@"username"] = self.configuration.personUsername;
    }
    if (self.configuration.personEmail) {
        personData[@"email"] = self.configuration.personEmail;
    }
    
    if ([[personData allKeys] count]) {
        return personData;
    }
    
    return nil;
}

- (NSDictionary*)buildClientData {
    NSNumber *timestamp = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
    ;
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceCode = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *iosData = [@{@"ios_version": [[UIDevice currentDevice] systemVersion],
                                      @"device_code": deviceCode,
                                      @"code_version": build,
                                      @"version_name": bundleName} mutableCopy];
    
    NSDictionary *data = @{@"timestamp": timestamp,
                           @"ios": iosData};
    
    return data;
}

- (NSDictionary*)buildPayloadWithLevel:(NSString*)level message:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra crashReport:(NSString*)crashReport {
    
    NSDictionary *clientData = [self buildClientData];
    NSDictionary *notifierData = @{@"name": @"rollbar-ios",
                                   @"version": NOTIFIER_VERSION};
    
    NSDictionary *body = [self buildPayloadBodyWithMessage:message exception:exception extra:extra crashReport:crashReport];
    
    NSMutableDictionary *data = [@{@"environment": self.configuration.environment,
                                   @"level": level,
                                   @"language": @"objective-c",
                                   @"framework": @"ios",
                                   @"platform": @"ios",
                                   @"uuid": [self generateUUID],
                                   @"client": clientData,
                                   @"notifier": notifierData,
                                   @"body": body} mutableCopy];
    
    NSDictionary *personData = [self buildPersonData];
    
    if (personData) {
        data[@"person"] = personData;
    }
    
    return @{@"access_token": self.configuration.accessToken,
             @"data": @[data]};
}

- (NSDictionary*)buildPayloadBodyWithCrashReport:(NSString*)crashReport {
    return @{@"crash_report": @{@"raw": crashReport}};
}

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message extra:(NSDictionary*)extra {
    NSMutableDictionary *result = [@{@"body": message} mutableCopy];
    
    if (extra) {
        result[@"extra"] = extra;
    }
    
    return @{@"message": result};
}

- (NSDictionary*)buildPayloadBodyWithMessage:(NSString*)message exception:(NSException*)exception extra:(NSDictionary*)extra crashReport:(NSString*)crashReport {
    if (crashReport) {
        return [self buildPayloadBodyWithCrashReport:crashReport];
    } else {
        return [self buildPayloadBodyWithMessage:message extra:extra];
    }
}

- (void)sendPayload:(NSData*)payload {
    NSURL *url = [NSURL URLWithString:self.configuration.endpoint];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:self.configuration.accessToken forHTTPHeaderField:@"X-Rollbar-Access-Token"];
    [request setHTTPBody:payload];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            NSLog(@"[Rollbar] Error %@; %@", error, [error localizedDescription]);
        } else {
            NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
            if ([httpResponse statusCode] == 200) {
                NSLog(@"[Rollbar] Success");
            } else {
                NSLog(@"[Rollbar] There was a problem reporting to Rollbar");
                NSLog(@"[Rollbar] Response: %@", [NSJSONSerialization JSONObjectWithData:data options:0 error:nil]);
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
