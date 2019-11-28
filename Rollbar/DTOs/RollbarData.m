//
//  RollbarData.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarData.h"
#import "DataTransferObject+Protected.h"

static NSString * const DFK_ENVIRONMENT = @"environment";
static NSString * const DFK_BODY = @"body";
static NSString * const DFK_LEVEL = @"level";
static NSString * const DFK_TIMESTAMP = @"timestamp";
static NSString * const DFK_CODE_VERSION = @"code_version";
static NSString * const DFK_PLATFORM = @"platform";
static NSString * const DFK_LANGUAGE = @"language";
static NSString * const DFK_FRAMEWORK = @"framework";
static NSString * const DFK_CONTEXT = @"context";
static NSString * const DFK_REQUEST = @"request";
static NSString * const DFK_PERSON = @"person";
static NSString * const DFK_SERVER = @"server";
static NSString * const DFK_CLIENT = @"client";
static NSString * const DFK_CUSTOM = @"custom";
static NSString * const DFK_FINGERPRINT = @"fingerprint";
static NSString * const DFK_TITLE = @"title";
static NSString * const DFK_UUID = @"uuid";
static NSString * const DFK_NOTIFIER = @"notifier";

@implementation RollbarData

- (NSMutableString *)environment {
    return [self safelyGetStringByKey:DFK_ENVIRONMENT];
}

- (void)setEnvironment:(NSMutableString *)accessToken {
    [self setString:accessToken forKey:DFK_ENVIRONMENT];
}

@end
