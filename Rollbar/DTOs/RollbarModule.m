//
//  RollbarModule.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarModule.h"
#import "DataTransferObject+Protected.h"

#pragma mark - constants

static NSString *const DEFAULT_VERSION = nil;

#pragma mark - data field keys

static NSString * const DFK_NAME = @"name";
static NSString * const DFK_VERSION = @"version";

#pragma mark - class implementation

@implementation RollbarModule

#pragma mark - initializers

- (id)initWithName:(NSString *)name
        version:(NSString *)version {
    
    self = [super init];
    if (self) {
        self.name = name;
        self.version = version;
    }
    return self;
}

- (id)initWithName:(NSString *)name {
    
    return [self initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                     name, DFK_NAME,
                                     DEFAULT_VERSION, DFK_VERSION,
                                     nil]
            ];
}

#pragma mark - property accessors

- (NSString *)name {
    NSString *result = [self safelyGetStringByKey:DFK_NAME];
    return result;
}

- (void)setName:(NSString *)value {
    [self setString:value forKey:DFK_NAME];
}

- (NSString *)version {
    NSString *result = [self safelyGetStringByKey:DFK_VERSION];
    return result;
}

- (void)setVersion:(NSString *)value {
    [self setString:value forKey:DFK_VERSION];
}

@end
