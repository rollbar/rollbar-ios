//
//  Deployment.h
//  Rollbar
//
//  Created by Andrey Kornich on 2018-09-12.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef Deployment_h
//#define Deployment_h

#import <Foundation/Foundation.h>

@interface Deployment : NSObject
@property (readonly, retain) NSString *environment;
@property (readonly, retain) NSString *comment;
@property (readonly, retain) NSString *revision;
@property (readonly, retain) NSString *localUsername;
@property (readonly, retain) NSString *rollbarUsername;
// Designated Initializer:
- (id)initWithEnvironment:(NSString *)environment
                  comment:(NSString *)comment
                 revision:(NSString *)revision
            localUserName:(NSString *)lovalUserName
          rollbarUserName:(NSString *)rollbarUserName;
@end

//#endif /* Deployment_h */
