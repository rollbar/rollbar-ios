//
//  RollbarData.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarData : DataTransferObject

@property (nonatomic, copy) NSMutableString *environment;

@end

NS_ASSUME_NONNULL_END
