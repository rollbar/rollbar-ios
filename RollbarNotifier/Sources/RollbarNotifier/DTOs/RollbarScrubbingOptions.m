//
//  RollbarScrubbingOptions.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarScrubbingOptions.h"
//#import "DataTransferObject+Protected.h"

#pragma mark - constants

static BOOL const DEFAULT_ENABLED_FLAG = YES;

#pragma mark - data field keys

static NSString * const DFK_ENABLED = @"enabled";
static NSString * const DFK_SCRUB_FIELDS = @"scrubFields";       // scrab these
static NSString * const DFK_SAFELIST_FIELDS = @"safeListFields"; // do not scrub these

#pragma mark - class implementation

@implementation RollbarScrubbingOptions

#pragma mark - initializers

- (instancetype)initWithEnabled:(BOOL)enabled
                    scrubFields:(NSArray *)scrubFields
                 safeListFields:(NSArray *)safeListFields {

    self = [super initWithDictionary:@{
        DFK_ENABLED:[NSNumber numberWithBool:enabled],
        DFK_SCRUB_FIELDS:scrubFields,
        DFK_SAFELIST_FIELDS:safeListFields
    }];
    return self;

}

- (instancetype)initWithScrubFields:(NSArray *)scrubFields
                    safeListFields:(NSArray *)safeListFields {

    return [self initWithEnabled:DEFAULT_ENABLED_FLAG
                     scrubFields:scrubFields
                  safeListFields:safeListFields
            ];
}

- (instancetype)initWithScrubFields:(NSArray *)scrubFields {
    
    return [self initWithScrubFields:scrubFields safeListFields:@[]];
}

- (instancetype)init {

    // init with the default set of scrub-fields:
    return [self initWithScrubFields:@[
        @"Password",
        @"passwd",
        @"confirm_password",
        @"password_confirmation",
        @"accessToken",
        @"auth_token",
        @"authentication",
        @"secret",
    ]];
}

#pragma mark - property accessors

- (BOOL)enabled {
    NSNumber *result = [self safelyGetNumberByKey:DFK_ENABLED];
    return [result boolValue];
}

- (void)setEnabled:(BOOL)value {
    [self setNumber:[[NSNumber alloc] initWithBool:value] forKey:DFK_ENABLED];
}

- (NSArray *)scrubFields {
    NSArray *result = [self safelyGetArrayByKey:DFK_SCRUB_FIELDS];
    return result;
}

- (void)setScrubFields:(NSArray *)scrubFields {
    [self setArray:scrubFields forKey:DFK_SCRUB_FIELDS];
}

- (NSArray *)safeListFields {
    NSArray *result = [self safelyGetArrayByKey:DFK_SAFELIST_FIELDS];
    return result;
}

- (void)setSafeListFields:(NSArray *)whitelistFields {
    [self setArray:whitelistFields forKey:DFK_SAFELIST_FIELDS];
}

@end
