//
//  Payload.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "PayloadData.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Payload : DataTransferObject

@property (nonatomic, copy) NSMutableString *accessToken;
@property (nonatomic) PayloadData *data;

@end

NS_ASSUME_NONNULL_END
