//
//  RollbarData.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarData.h"
#import "DataTransferObject+Protected.h"

static NSString * const DATAFIELD_ENVIRONMENT = @"environment";
static NSString * const DATAFIELD_BODY = @"body";

@implementation RollbarData

- (NSMutableString *)environment {
    return [self safelyGetStringByKey:DATAFIELD_ENVIRONMENT];
}

- (void)setEnvironment:(NSMutableString *)accessToken {
    [self setString:accessToken forKey:DATAFIELD_ENVIRONMENT];
}

@end
