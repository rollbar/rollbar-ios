//  Copyright © 2018 Rollbar. All rights reserved.

#import "RollbarDeploymentDetails.h"

@import RollbarCommon;

@implementation RollbarDeploymentDetails

#pragma mark - data field keys
static NSString * const DFK_DEPLOY_ID = @"id";
static NSString * const DFK_PROJECT_ID = @"project_id";
static NSString * const DFK_START_TIME = @"start_time";
static NSString * const DFK_END_TIME = @"finish_time";
static NSString * const DFK_STATUS = @"status";

#pragma mark - properties

-(NSString *)deployId {
    return [self safelyGetNumberByKey:DFK_DEPLOY_ID].description;
}
-(NSString *)projectId {
    return [self safelyGetNumberByKey:DFK_PROJECT_ID].description;
}

-(NSDate *)startTime {
    NSNumber *dateNumber = [self safelyGetNumberByKey:DFK_START_TIME];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)dateNumber.doubleValue];
    return date;
}

-(NSDate *)endTime {
    NSNumber *dateNumber = [self safelyGetNumberByKey:DFK_END_TIME];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)dateNumber.doubleValue];
    return date;
}

-(NSString *)status {
    return [self safelyGetStringByKey:DFK_STATUS] ;
}

#pragma mark - initializers

- (instancetype)initWithDictionary:(NSDictionary *)data {
    return [super initWithDictionary:data];
}

@end
