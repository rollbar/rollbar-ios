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

- (id)initWithEnabled:(BOOL)enabled
          scrubFields:(NSArray *)scrubFields
      whitelistFields:(NSArray *)whitelistFields {
    
    self = [super init];
    if (self) {
        self.enabled = enabled;
        self.scrubFields = scrubFields;
        self.whitelistFields = whitelistFields;
    }
    return self;
}

- (id)initWithScrubFields:(NSArray *)scrubFields
          whitelistFields:(NSArray *)whitelistFields {
    return [self initWithEnabled:DEFAULT_ENABLED_FLAG
                     scrubFields:scrubFields
                 whitelistFields:whitelistFields
            ];
}
- (id)initWithScrubFields:(NSArray *)scrubFields {
    return [self initWithScrubFields:scrubFields whitelistFields:@[]];
}

- (id)init {
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
