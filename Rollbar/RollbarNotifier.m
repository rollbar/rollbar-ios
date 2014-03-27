//
//  RollbarNotifier.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/18/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import "RollbarNotifier.h"
#import <UIKit/UIKit.h>
#include <sys/utsname.h>


@interface RollbarNotifier()

@end

@implementation RollbarNotifier

static NSString *NOTIFIER_VERSION = @"0.0.1";

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

- (void)uncaughtException:(NSException *)exception {
    [self log:@"error" message:nil exception:exception data:nil];
}

- (void)logCrashReport:(NSString*)crashReport {
    NSDictionary *payload = [self buildPayloadWithLevel:@"error" message:nil exception:nil extra:nil crashReport:crashReport];
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    [self sendPayload:jsonPayload];
}

- (void)log:(NSString*)level message:(NSString*)message exception:(NSException*)exception data:(NSDictionary*)data {
    NSDictionary *payload = [self buildPayloadWithLevel:level message:message exception:exception extra:data crashReport:nil];
    
    NSData *jsonPayload = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    [self sendPayload:jsonPayload];
}

- (NSDictionary*)buildClientData {
    NSNumber *timestamp = [NSNumber numberWithInteger:[[NSDate date] timeIntervalSince1970]]
    ;
    NSDictionary *infoDictionary = [[NSBundle mainBundle]infoDictionary];
    
    NSString *build = infoDictionary[(NSString*)kCFBundleVersionKey];
    NSString *bundleName = infoDictionary[(NSString *)kCFBundleNameKey];
    
    NSMutableDictionary *iosData = [@{@"ios_version": [[UIDevice currentDevice] systemVersion],
                                      @"device_name": [self getDeviceName],
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
    
    NSDictionary *data = [@{@"environment": self.configuration.environment,
                           @"level": level,
                           @"language": @"objective-c",
                           @"framework": @"ios",
                           @"platform": @"ios",
                           @"uuid": [self generateUUID],
                           @"client": clientData,
                           @"notifier": notifierData,
                           @"body": body} mutableCopy];
    
    
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

// Adapted from http://stackoverflow.com/a/20062141/1138191
- (NSString*)getDeviceName {
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    static NSDictionary* deviceNamesByCode = nil;
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"i386": @"iOS Simulator",
                              @"x86_64": @"iOS Simulator",
                              @"iPod1,1": @"iPod Touch (Original)",
                              @"iPod2,1": @"iPod Touch (Second Generation)",
                              @"iPod3,1": @"iPod Touch (Third Generation)",
                              @"iPod4,1": @"iPod Touch (Fourth Generation)",
                              @"iPhone1,1": @"iPhone (Original)",
                              @"iPhone1,2": @"iPhone (3G)",
                              @"iPhone2,1": @"iPhone (3GS)",
                              @"iPad1,1": @"iPad (Original)",
                              @"iPad2,1": @"iPad 2",
                              @"iPad3,1": @"iPad (3rd Generation)",
                              @"iPhone3,1": @"iPhone 4",
                              @"iPhone4,1": @"iPhone 4S",
                              @"iPhone5,1": @"iPhone 5",
                              @"iPhone5,2": @"iPhone 5",
                              @"iPad3,4": @"iPad (4th Generation)",
                              @"iPad2,5": @"iPad Mini",
                              @"iPhone5,3": @"iPhone 5c",
                              @"iPhone5,4": @"iPhone 5c",
                              @"iPhone6,1": @"iPhone 5s",
                              @"iPhone6,2": @"iPhone 5s",
                              @"iPad4,1": @"iPad Air",
                              @"iPad4,2": @"iPad Air",
                              @"iPad4,4": @"iPad Mini",
                              @"iPad4,5": @"iPad Mini"};
    }
    
    NSString* deviceName = [deviceNamesByCode objectForKey:code];
    if (!deviceName) {
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        } else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        } else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        } else {
            deviceName = code;
        }
    }
    
    return deviceName;
}
        
@end
