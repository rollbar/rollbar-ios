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

@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic) RollbarData *data;

@end

NS_ASSUME_NONNULL_END
