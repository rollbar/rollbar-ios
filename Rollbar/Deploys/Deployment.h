//
//  Deployment.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../RollbarJSONFriendlyObject.h"

@interface Deployment : RollbarJSONFriendlyObject
@property (readonly, retain) NSString *environment;
@property (readonly, retain) NSString *comment;
@property (readonly, retain) NSString *revision;
@property (readonly, retain) NSString *localUsername;
@property (readonly, retain) NSString *rollbarUsername;
// Designated Initializer:
- (id)initWithEnvironment:(NSString *)environment
                  comment:(NSString *)comment
                 revision:(NSString *)revision
            localUserName:(NSString *)localUserName
          rollbarUserName:(NSString *)rollbarUserName;
@end
