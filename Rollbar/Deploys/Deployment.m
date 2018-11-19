//  Copyright © 2018 Rollbar. All rights reserved.

#import "Deployment.h"

@implementation Deployment

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
        NSString *revision = jsonData[@"revision"];
        NSString *environment = jsonData[@"environment"];
        NSString *user_id = jsonData[@"user_id"];
        NSString *local_username = jsonData[@"local_username"];
        NSString *comment = jsonData[@"comment"];
        
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
