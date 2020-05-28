//
//  RollbarPerson.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarPerson.h"
//#import "DataTransferObject+Protected.h"

#pragma mark - constants

static NSString *const DEFAULT_USERNAME = nil;
static NSString *const DEFAULT_EMAIL = nil;

#pragma mark - data field keys

static NSString * const DFK_ID = @"id";
static NSString * const DFK_USERNAME = @"username";
static NSString * const DFK_EMAIL = @"email";

#pragma mark - class implementation

@implementation RollbarPerson

#pragma mark - initializers

- (instancetype)initWithID:(nonnull NSString *)ID
        username:(nullable NSString *)username
           email:(nullable NSString *)email {
    
    self = [super initWithDictionary:@{
        DFK_ID:ID ? ID : [NSNull null],
        DFK_USERNAME:username ? username : [NSNull null],
        DFK_EMAIL:email ? email : [NSNull null]
    }];
    return self;
}

- (instancetype)initWithID:(nonnull NSString *)ID
        username:(NSString *)username {
    
    return [self initWithID:ID
                   username:username
                      email:DEFAULT_EMAIL
            ];
}

- (instancetype)initWithID:(nonnull NSString *)ID
           email:(NSString *)email {
    
    return [self initWithID:ID
                   username:DEFAULT_USERNAME
                      email:email
            ];
}

- (instancetype)initWithID:(nonnull NSString *)ID {
    
    return [self initWithID:ID
                   username:DEFAULT_USERNAME
                      email:DEFAULT_EMAIL
            ];
}

#pragma mark - property accessors

- (NSString *)ID {
    return [self getDataByKey:DFK_ID];
}

- (void)setID:(NSString *)value {
    [self setData:value byKey:DFK_ID];
}

- (NSString *)username {
    return [self getDataByKey:DFK_USERNAME];
}

- (void)setUsername:(NSString *)value {
    [self setData:value byKey:DFK_USERNAME];
}

- (NSString *)email {
    return [self getDataByKey:DFK_EMAIL];
}

- (void)setEmail:(NSString *)value {
    [self setData:value byKey:DFK_EMAIL];
}

@end
