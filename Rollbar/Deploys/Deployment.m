//  Copyright © 2018 Rollbar. All rights reserved.

#import "Deployment.h"
#import "DataTransferObject+Protected.h"

@implementation Deployment

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
        DFK_ENVIRONMENT:environment,
        DFK_COMMENT:comment,
        DFK_REVISION:revision,
        DFK_LOCAL_USERNAME:localUserName,
        DFK_ROLLBAR_USERNAME:rollbarUserName,
    }];
    return self;
}

- (instancetype)initWithJSONData:(NSDictionary *)jsonData {
    return [self initWithEnvironment:jsonData[@"environment"]
                             comment:jsonData[@"environment"]
                            revision:jsonData[@"revision"]
                       localUserName:jsonData[@"local_username"]
                     rollbarUserName:jsonData[@"user_id"]
            ];
}

- (instancetype)init {
    return [self initWithEnvironment:nil
                             comment:nil
                            revision:nil
                       localUserName:nil
                     rollbarUserName:nil];
}
@end
