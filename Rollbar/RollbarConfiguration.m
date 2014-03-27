//
//  RollbarConfiguration.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/21/14.
//  Copyright (c) 2014 Rollbar. All rights reserved.
//

#import "RollbarConfiguration.h"

@implementation RollbarConfiguration

+ (RollbarConfiguration*)configuration {
    return [[RollbarConfiguration alloc] init];
}

- (id)init {
    if((self = [super init])) {
        self.endpoint = DEFAULT_ENDPOINT;
        
        #ifdef DEBUG
        self.environment = @"development";
        #else
        self.environment = @"unspecified";
        #endif
    }
    
    return self;
}

@end
