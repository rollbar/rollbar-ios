//
//  RollbarConfiguration.m
//  Rollbar
//
//  Created by Sergei Bezborodko on 3/21/14.
//  Copyright (c) 2014 Rollbar, Inc. All rights reserved.
//

#import "RollbarConfiguration.h"

@interface RollbarConfiguration ()

@property (nonatomic, copy) NSString* personId;
@property (nonatomic, copy) NSString* personUsername;
@property (nonatomic, copy) NSString* personEmail;

@end

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
        
        self.crashLevel = @"error";
    }
    
    return self;
}

- (void)setPersonId:(NSString *)personId username:(NSString *)username email:(NSString *)email {
    self.personId = personId;
    self.personUsername = username;
    self.personEmail = email;
}

@end
