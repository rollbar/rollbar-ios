//
//  RollbarDestination.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-23.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarDestination : DataTransferObject

#pragma mark - properties
@property (nonatomic, copy) NSString *endpoint;
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *environment;

#pragma mark - initializers
- (id)initWithEndpoint:(NSString *)endpoint
           accessToken:(NSString *)accessToken
           environment:(NSString *)environment;
- (id)initWithAccessToken:(NSString *)accessToken
              environment:(NSString *)environment;
- (id)initWithAccessToken:(NSString *)accessToken;

@end

NS_ASSUME_NONNULL_END
