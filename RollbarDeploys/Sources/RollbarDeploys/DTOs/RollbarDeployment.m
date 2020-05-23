//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarDeployment.h"

@import RollbarCommon;

@implementation RollbarDeployment

#pragma mark - data field keys
static NSString * const DFK_ENVIRONMENT = @"environment";
static NSString * const DFK_COMMENT = @"comment";
static NSString * const DFK_REVISION = @"revision";
static NSString * const DFK_LOCAL_USERNAME = @"local_username";
static NSString * const DFK_ROLLBAR_USERNAME = @"rollbar_username";

#pragma mark - properties
-(NSString *)environment {
    return [self safelyGetStringByKey:DFK_ENVIRONMENT] ;
}
-(NSString *)comment {
    return [self safelyGetStringByKey:DFK_COMMENT] ;
}
-(NSString *)revision {
    return [self safelyGetStringByKey:DFK_REVISION] ;
}
-(NSString *)localUsername {
    return [self safelyGetStringByKey:DFK_LOCAL_USERNAME] ;
}
-(NSString *)rollbarUsername {
    return [self safelyGetStringByKey:DFK_ROLLBAR_USERNAME] ;
}

#pragma mark - initializers

- (instancetype)initWithEnvironment:(NSString *)environment
                            comment:(NSString *)comment
                           revision:(NSString *)revision
                      localUserName:(NSString *)localUserName
                    rollbarUserName:(NSString *)rollbarUserName {
    self = [super initWithDictionary:@{
        DFK_ENVIRONMENT:environment ? environment : [NSNull null],
        DFK_COMMENT:comment ? comment : [NSNull null],
        DFK_REVISION:revision ? revision : [NSNull null],
        DFK_LOCAL_USERNAME:localUserName ? localUserName : [NSNull null],
        DFK_ROLLBAR_USERNAME:rollbarUserName ? rollbarUserName : [NSNull null],
    }];
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)data {
//    return [self initWithEnvironment:data[@"environment"]
//                             comment:data[@"environment"]
//                            revision:data[@"revision"]
//                       localUserName:data[@"local_username"]
//                     rollbarUserName:data[@"user_id"]
//            ];
    return [super initWithDictionary:data];
}

@end
