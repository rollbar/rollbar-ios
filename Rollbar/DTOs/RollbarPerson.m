//
//  RollbarPerson.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarPerson.h"
#import "DataTransferObject+Protected.h"

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

- (id)initWithID:(NSString *)ID
        username:(NSString *)username
           email:(NSString *)email {
    
    self = [super init];
    if (self) {
        self.ID = ID;
        self.username = username;
        self.email = email;
    }
    return self;
}

- (id)initWithID:(NSString *)ID
        username:(NSString *)username {
    
    return [self initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                     ID, DFK_ID,
                                     username, DFK_USERNAME,
                                     DEFAULT_EMAIL, DFK_EMAIL,
                                     nil]
            ];
}

- (id)initWithID:(NSString *)ID
           email:(NSString *)email {
    
    return [self initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                     ID, DFK_ID,
                                     DEFAULT_USERNAME, DFK_USERNAME,
                                     email, DFK_EMAIL,
                                     nil]
            ];
}

- (id)initWithID:(NSString *)ID {
    
    return [self initWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:
                                     ID, DFK_ID,
                                     DEFAULT_USERNAME, DFK_USERNAME,
                                     DEFAULT_EMAIL, DFK_EMAIL,
                                     nil]
            ];
}

#pragma mark - property accessors

- (NSString *)ID {
    NSString *result = [self safelyGetStringByKey:DFK_ID];
    return result;
}

- (void)setID:(NSString *)value {
    [self setString:value forKey:DFK_ID];
}

- (NSString *)username {
    NSString *result = [self safelyGetStringByKey:DFK_USERNAME];
    return result;
}

- (void)setUsername:(NSString *)value {
    [self setString:value forKey:DFK_USERNAME];
}

- (NSString *)email {
    NSString *result = [self safelyGetStringByKey:DFK_EMAIL];
    return result;
}

- (void)setEmail:(NSString *)value {
    [self setString:value forKey:DFK_EMAIL];
}

@end
