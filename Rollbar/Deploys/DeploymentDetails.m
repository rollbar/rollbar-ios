//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "DeploymentDetails.h"

@implementation DeploymentDetails

static NSString * const PROPERTY_deployId = @"id";
static NSString * const PROPERTY_projectId = @"project_id";
static NSString * const PROPERTY_startTime = @"start_time";
static NSString * const PROPERTY_endTime = @"finish_time";
static NSString * const PROPERTY_status = @"status";

-(NSString *)deployId {
    return [self.dataDictionary objectForKey:PROPERTY_deployId] ;
}
-(NSString *)projectId {
    return [self.dataDictionary objectForKey:PROPERTY_projectId] ;
}
-(NSString *)startTime {
    return [self.dataDictionary objectForKey:PROPERTY_startTime] ;
}
-(NSString *)endTime {
    return [self.dataDictionary objectForKey:PROPERTY_endTime] ;
}
-(NSString *)status {
    return [self.dataDictionary objectForKey:PROPERTY_status] ;
}

- (id)initWithJSONData:(NSDictionary *)jsonData {
    self = [super initWithJSONData:jsonData];
    if (nil != self) {
        NSNumber *deploy_id = jsonData[@"id"];
        NSNumber *project_id = jsonData[@"project_id"];
        NSNumber *start_time = jsonData[@"start_time"];
        NSNumber *finish_time = jsonData[@"finish_time"];
        NSString *status = jsonData[@"status"];
        
        [self.dataDictionary setObject:[deploy_id stringValue]
                                forKey:PROPERTY_deployId];
        [self.dataDictionary setObject:[project_id stringValue]
                                forKey:PROPERTY_projectId];
        [self.dataDictionary setObject:status
                                forKey:PROPERTY_status];
        [self.dataDictionary setObject:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)start_time.doubleValue]
                                forKey:PROPERTY_startTime];
        [self.dataDictionary setObject:[NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)finish_time.doubleValue]
                                forKey:PROPERTY_endTime];
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
