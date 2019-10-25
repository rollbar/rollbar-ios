//
//  RollbarServer.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarServer.h"
#import "DataTransferObject+Protected.h"

#pragma mark - constants

static NSString *const DEFAULT_HOST = @"unknown";
static NSString *const DEFAULT_ROOT = @"/";
static NSString *const DEFAULT_BRANCH = @"unknown";
static NSString *const DEFAULT_CODE_VERSION = @"n.n.n";

#pragma mark - data field keys

static NSString * const DFK_HOST = @"host";
static NSString * const DFK_ROOT = @"root";
static NSString * const DFK_BRANCH = @"branch";
static NSString * const DFK_CODE_VERSION = @"codeVersion";

#pragma mark - class implementation

@implementation RollbarServer

#pragma mark - initializers

- (id)initWithHost:(NSString *)host
              root:(NSString *)root
            branch:(NSString *)branch
       codeVersion:(NSString *)codeVersion {
    
    self = [super init];
    if (self) {
        self.host = host;
        self.root = root;
        self.branch = branch;
        self.codeVersion = codeVersion;
    }
    return self;
}

#pragma mark - property accessors

- (NSString *)host {
    NSString *result = [self safelyGetStringByKey:DFK_HOST];
    return result;
}

- (void)setHost:(NSString *)value {
    [self setString:value forKey:DFK_HOST];
}

- (NSString *)root {
    NSString *result = [self safelyGetStringByKey:DFK_ROOT];
    return result;
}

- (void)setRoot:(NSString *)value {
    [self setString:value forKey:DFK_ROOT];
}

- (NSString *)branch {
    NSString *result = [self safelyGetStringByKey:DFK_BRANCH];
    return result;
}

- (void)setBranch:(NSString *)value {
    [self setString:value forKey:DFK_BRANCH];
}

- (NSString *)codeVersion {
    NSString *result = [self safelyGetStringByKey:DFK_CODE_VERSION];
    return result;
}

- (void)setCodeVersion:(NSString *)value {
    [self setString:value forKey:DFK_CODE_VERSION];
}

@end
