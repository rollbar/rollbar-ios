//
//  RollbarProxy.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarProxy.h"
#import "DataTransferObject+Protected.h"

#pragma mark - constants

static BOOL const DEFAULT_ENABLED_FLAG = NO;
static NSString *const DEFAULT_PROXY_URL = @"";
static NSUInteger const DEFAULT_PROXY_PORT = 0;

#pragma mark - data field keys

static NSString * const DFK_ENABLED = @"enabled";
static NSString * const DFK_PROXY_URL = @"proxyUrl";
static NSString * const DFK_PROXY_PORT = @"proxyPort";

#pragma mark - class implementation

@implementation RollbarProxy

#pragma mark - initializers

- (id)initWithEnabled:(BOOL)enabled
             proxyUrl:(NSString *)proxyUrl
            proxyPort:(NSUInteger)proxyPort {
    
    self = [super init];
    if (self) {
        self.enabled = enabled;
        self.proxyUrl = proxyUrl;
        self.proxyPort = proxyPort;
    }
    return self;
}

- (id)init {
    return [self initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:DEFAULT_ENABLED_FLAG], DFK_ENABLED,
                                     DEFAULT_PROXY_URL, DFK_PROXY_URL,
                                     DEFAULT_PROXY_PORT, DFK_PROXY_PORT,
                                     nil]
            ];
}

#pragma mark - property accessors

- (BOOL)enabled {
    NSNumber *result = [self safelyGetNumberByKey:DFK_ENABLED];
    return [result boolValue];
}

- (void)setEnabled:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DFK_ENABLED];
}

- (NSString *)proxyUrl {
    NSString *result = [self safelyGetStringByKey:DFK_PROXY_URL];
    return result;
}

- (void)setProxyUrl:(NSString *)value {
    [self setString:value forKey:DFK_PROXY_URL];
}

- (NSUInteger)proxyPort {
    NSUInteger result = [self safelyGetUIntegerByKey:DFK_PROXY_PORT];
    return result;
}

- (void)setProxyPort:(NSUInteger)value {
    [self setUInteger:value forKey:DFK_PROXY_PORT];
}

@end
