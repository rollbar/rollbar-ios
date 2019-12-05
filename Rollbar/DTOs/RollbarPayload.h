//
//  RollbarPayload.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import <Foundation/Foundation.h>

@class RollbarData;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarPayload : DataTransferObject

// Required: access_token
// An access token with scope "post_server_item" or "post_client_item".
// A post_client_item token must be used if the "platform" is "browser", "android", "ios", "flash", or "client"
// A post_server_item token should be used for other platforms.
@property (nonatomic, copy, nonnull) NSString *accessToken;

// Required: data
@property (nonatomic, nonnull) RollbarData *data;

-(instancetype)initWithAccessToken:(nonnull NSString *)token
                           andData:(nonnull RollbarData *)data;
//NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
