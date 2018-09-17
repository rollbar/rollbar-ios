//
//  Deployment.m
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import "Deployment.h"

@interface Deployment()
// redeclare the properties as read-write:
@property (readwrite, retain) NSString *environment;
@property (readwrite, retain) NSString *comment;
@property (readwrite, retain) NSString *revision;
@property (readwrite, retain) NSString *localUsername;
@property (readwrite, retain) NSString *rollbarUsername;
@end

@implementation Deployment
@synthesize environment;
@synthesize comment;
@synthesize revision;
@synthesize localUsername;
@synthesize rollbarUsername;
- (id)initWithEnvironment:(NSString *)environment
                  comment:(NSString *)comment
                 revision:(NSString *)revision
            localUserName:(NSString *)lovalUserName
          rollbarUserName:(NSString *)rollbarUserName {
    self = [super init];
    if (nil != self) {
        self.environment = environment;
        self.comment = comment;
        self.revision = revision;
        self.localUsername = localUsername;
        self.rollbarUsername = rollbarUsername;
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
