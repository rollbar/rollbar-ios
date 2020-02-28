//
//  RollbarScrubbingOptions.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarScrubbingOptions.h"
#import "DataTransferObject+Protected.h"

#pragma mark - constants

static BOOL const DEFAULT_ENABLED_FLAG = YES;

#pragma mark - data field keys

static NSString * const DFK_ENABLED = @"enabled";
static NSString * const DFK_SCRUB_FIELDS = @"scrubFields";
static NSString * const DFK_WHITELIST_FIELDS = @"whitelistFields";

#pragma mark - class implementation

@implementation RollbarScrubbingOptions

#pragma mark - initializers

- (instancetype)initWithEnabled:(BOOL)enabled
                    scrubFields:(NSArray *)scrubFields
                whitelistFields:(NSArray *)whitelistFields {

    self = [super initWithDictionary:@{
        DFK_ENABLED:[NSNumber numberWithBool:enabled],
        DFK_SCRUB_FIELDS:scrubFields,
        DFK_WHITELIST_FIELDS:whitelistFields
    }];
    return self;

}

- (instancetype)initWithScrubFields:(NSArray *)scrubFields
                    whitelistFields:(NSArray *)whitelistFields {

    return [self initWithEnabled:DEFAULT_ENABLED_FLAG
                     scrubFields:scrubFields
                 whitelistFields:whitelistFields
            ];
}

- (instancetype)initWithScrubFields:(NSArray *)scrubFields {
    
    return [self initWithScrubFields:scrubFields whitelistFields:@[]];
}

- (instancetype)init {

    return [self initWithScrubFields:@[]];
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

- (NSArray *)whitelistFields {
    NSArray *result = [self safelyGetArrayByKey:DFK_WHITELIST_FIELDS];
    return result;
}

- (void)setWhitelistFields:(NSArray *)whitelistFields {
    [self setArray:whitelistFields forKey:DFK_WHITELIST_FIELDS];
}

@end
