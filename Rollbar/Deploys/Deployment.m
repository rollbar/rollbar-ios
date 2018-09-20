//
//  Deployment.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import "Deployment.h"

//@interface Deployment()
//// redeclare the properties as read-write:
//@property (readwrite, retain) NSString *environment;
//@property (readwrite, retain) NSString *comment;
//@property (readwrite, retain) NSString *revision;
//@property (readwrite, retain) NSString *localUsername;
//@property (readwrite, retain) NSString *rollbarUsername;
//@end

@implementation Deployment
//@synthesize environment;
//@synthesize comment;
//@synthesize revision;
//@synthesize localUsername;
//@synthesize rollbarUsername;

static NSString * const PROPERTY_environment = @"environment";
static NSString * const PROPERTY_comment = @"comment";
static NSString * const PROPERTY_revision = @"revision";
static NSString * const PROPERTY_localUsername = @"local_username";
static NSString * const PROPERTY_rollbarUsername = @"rollbar_username";

-(NSString *)environment {
    return [self.dataDictionary objectForKey:PROPERTY_environment] ;
}
-(NSString *)comment {
    return [self.dataDictionary objectForKey:PROPERTY_comment] ;
}
-(NSString *)revision {
    return [self.dataDictionary objectForKey:PROPERTY_revision] ;
}
-(NSString *)localUsername {
    return [self.dataDictionary objectForKey:PROPERTY_localUsername] ;
}
-(NSString *)rollbarUsername {
    return [self.dataDictionary objectForKey:PROPERTY_rollbarUsername] ;
}

- (id)initWithEnvironment:(NSString *)environment
                  comment:(NSString *)comment
                 revision:(NSString *)revision
            localUserName:(NSString *)localUserName
          rollbarUserName:(NSString *)rollbarUserName {
    self = [super init];
    if (nil != self) {
        [self.dataDictionary setObject:environment forKey:PROPERTY_environment];
        [self.dataDictionary setObject:comment forKey:PROPERTY_comment];
        [self.dataDictionary setObject:revision forKey:PROPERTY_revision];
        [self.dataDictionary setObject:localUserName forKey:PROPERTY_localUsername];
        [self.dataDictionary setObject:rollbarUserName forKey:PROPERTY_rollbarUsername];
    }
    return self;
}
- (id)initWithJSONData:(NSDictionary *)jsonData {
    self = [super initWithJSONData:jsonData];
    if (nil != self) {
        NSString *revision = jsonData[@"result"][@"revision"];
        NSString *environment = jsonData[@"result"][@"environment"];
        NSString *user_id = jsonData[@"result"][@"user_id"];
        NSString *local_username = jsonData[@"result"][@"local_username"];
        NSString *comment = jsonData[@"result"][@"comment"];
        
        NSNumber *deploy_id = jsonData[@"result"][@"id"];
        NSNumber *start_time = jsonData[@"result"][@"start_time"];
        NSNumber *finish_time = jsonData[@"result"][@"finish_time"];
        NSNumber *project_id = jsonData[@"result"][@"project_id"];
        NSString *status = jsonData[@"result"][@"status"];

        
        [self.dataDictionary setObject:environment forKey:PROPERTY_environment];
        [self.dataDictionary setObject:comment forKey:PROPERTY_comment];
        [self.dataDictionary setObject:revision forKey:PROPERTY_revision];
        [self.dataDictionary setObject:local_username forKey:PROPERTY_localUsername];
        [self.dataDictionary setObject:user_id forKey:PROPERTY_rollbarUsername];
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
