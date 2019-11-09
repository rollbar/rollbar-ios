//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"
#import "DataTransferObject+Protected.h"

@implementation DeploymentDetails

#pragma mark - data field keys
static NSString * const DFK_DEPLOY_ID = @"id";
static NSString * const DFK_PROJECT_ID = @"project_id";
static NSString * const DFK_START_TIME = @"start_time";
static NSString * const DFK_END_TIME = @"finish_time";
static NSString * const DFK_STATUS = @"status";

#pragma mark - properties

-(NSString *)deployId {
    return [self safelyGetStringByKey:DFK_DEPLOY_ID] ;
}
-(NSString *)projectId {
    return [self safelyGetStringByKey:DFK_PROJECT_ID] ;
}
-(NSString *)startTime {
    return [self safelyGetStringByKey:DFK_START_TIME] ;
}
-(NSString *)endTime {
    return [self safelyGetStringByKey:DFK_END_TIME] ;
}
-(NSString *)status {
    return [self safelyGetStringByKey:DFK_STATUS] ;
}

#pragma mark - initializers

- (id)initWithJSONData:(NSDictionary *)jsonData {
    self = [super initWithJSONData:jsonData];
    if (nil != self) {
        NSNumber *deploy_id = jsonData[DFK_DEPLOY_ID];
        NSNumber *project_id = jsonData[DFK_PROJECT_ID];
        NSNumber *start_time = jsonData[DFK_START_TIME];
        NSNumber *finish_time = jsonData[DFK_END_TIME];
        NSString *status = jsonData[DFK_STATUS];
        
        [self setString:[deploy_id stringValue] forKey:DFK_DEPLOY_ID];
        [self setString:[project_id stringValue] forKey:DFK_PROJECT_ID];
        [self setString:status forKey:DFK_STATUS];
        [self setString:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)start_time.doubleValue].description
                                forKey:DFK_START_TIME];
        [self setString:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)finish_time.doubleValue].description
                                forKey:DFK_END_TIME];
    }
    return self;
}
- (id)init {
    return [self initWithEnvironment:nil
                             comment:nil
                            revision:nil
                       localUserName:nil
                     rollbarUserName:nil];
}
@end
