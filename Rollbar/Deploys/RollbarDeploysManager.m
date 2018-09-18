//
//  RollbarDeploysManager.m
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#import <Foundation/Foundation.h>

#import "RollbarDeploysManager.h"

@interface RollbarDeploysManager()
@property (readwrite, retain) NSString *writeAccessToken;
@property (readwrite, retain) NSString *readAccessToken;
@end

@implementation RollbarDeploysManager

- (id)initWithWriteAccessToken:(NSString *)writeAccessToken
               readAccessToken:(NSString *)readAccessToken {
    self = [super init];
    if (nil != self) {
        self.writeAccessToken = writeAccessToken;
        self.readAccessToken = readAccessToken;
    }
    return self;
}

- (id)init {
    return [self initWithWriteAccessToken:nil readAccessToken:nil];
}

- (void)getDeploymentUsing:(NSString *)deployId {
    //...
}

- (void)getDeploymentsPageForEnvironment:(NSString *)environmentId
                         usingPageNumber:(NSUInteger)pageNumber {
    //...
}

- (void)registerDeployment:(Deployment *)deployment {
    //...
}

@end
