//
//  RollbarModule.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarModule : DataTransferObject

#pragma mark - properties

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *version;

#pragma mark - initializers

- (id)initWithName:(NSString *)name
           version:(NSString *)version;
- (id)initWithName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
