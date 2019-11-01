//
//  RollbarServer.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-24.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface RollbarServer : DataTransferObject

#pragma mark - properties

@property (nonatomic, copy) NSString *host;
@property (nonatomic, copy) NSString *root;
@property (nonatomic, copy) NSString *branch;
@property (nonatomic, copy) NSString *codeVersion;

#pragma mark - initializers

- (id)initWithHost:(NSString *)host
              root:(NSString *)root
            branch:(NSString *)branch
       codeVersion:(NSString *)codeVersion;

@end

NS_ASSUME_NONNULL_END
