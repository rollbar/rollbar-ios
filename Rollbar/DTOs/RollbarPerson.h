//
//  RollbarPerson.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-25.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarPerson : DataTransferObject

#pragma mark - properties

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *email;

#pragma mark - initializers

- (id)initWithID:(NSString *)ID
        username:(NSString *)username
           email:(NSString *)email;
- (id)initWithID:(NSString *)ID
        username:(NSString *)username;
- (id)initWithID:(NSString *)ID
           email:(NSString *)email;
- (id)initWithID:(NSString *)ID;

@end

NS_ASSUME_NONNULL_END
