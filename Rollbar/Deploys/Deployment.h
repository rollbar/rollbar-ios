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

@property (readonly) NSString *environment;
@property (readonly) NSString *comment;
@property (readonly) NSString *revision;
@property (readonly) NSString *localUsername;
@property (readonly) NSString *rollbarUsername;

@end

//#endif /* Deployment_h */
