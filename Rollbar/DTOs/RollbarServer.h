//
//  RollbarServer.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RollbarServerConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarServer : RollbarServerConfig
// Can contain any arbitrary keys. Rollbar understands the following:

// Optional: cpu
// A string up to 255 characters
@property (nonatomic, copy, nullable) NSString *cpu;

// (Deprecated) sha: Git SHA of the running code revision. Use the full sha.
@property (nonatomic, copy, nullable) NSString *sha;

-(instancetype)initWithConfig:(nonnull RollbarServerConfig *)serverConfig NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
