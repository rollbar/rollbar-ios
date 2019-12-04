//
//  RollbarClient.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

@class RollbarJavascript;

NS_ASSUME_NONNULL_BEGIN

@interface RollbarClient : DataTransferObject
// Can contain any arbitrary keys. Rollbar understands the following:

// Optional: cpu
// A string up to 255 characters
@property (nonatomic, copy, nullable) NSString *cpu;

@property (nonatomic, strong, nonnull) RollbarJavascript *javaScript;

@end

NS_ASSUME_NONNULL_END
