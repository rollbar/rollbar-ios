//
//  OptionalBool.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "OptionalBool.h"

@implementation OptionalBool {
@protected NSNumber *value;
}

- (BOOL) hasValue {
    return (self->value != nil);
}

- (void) removeValue {
    self->value = nil;
}

@property (nonatomic) BOOL yesNo;

- (instancetype)init {
    self = [super init];
    return self;
}

- (instancetype)initWithValue:(BOOL)yesNo {
    self = [self init];
    self->value = [NSNumber numberWithBool:yesNo];
    return self;
}

@end
