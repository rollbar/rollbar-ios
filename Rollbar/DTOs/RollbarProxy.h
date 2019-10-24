//
//  RollbarProxy.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarProxy : DataTransferObject

#pragma mark - properties
@property (nonatomic) BOOL enabled;
@property (nonatomic, copy) NSString *proxyUrl;
@property (nonatomic) NSNumber *proxyPort;

#pragma mark - initializers
- (id)initWithEnabled:(BOOL)enabled
             proxyUrl:(NSString *)proxyUrl
            proxyPort:(NSNumber *)proxyPort;

@end

NS_ASSUME_NONNULL_END
