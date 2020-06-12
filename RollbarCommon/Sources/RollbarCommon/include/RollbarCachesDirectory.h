//
//  NSString+CachesDirectory.h
//  Rollbar
//
//  Created by Danny Nguyen on 3/12/19.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#ifndef RollbarCachesDirectory_h
#define RollbarCachesDirectory_h

@import Foundation;

@interface RollbarCachesDirectory : NSObject

+ (NSString *)directory;

#pragma mark - Initializers

- (instancetype) init
NS_UNAVAILABLE;

@end

#endif // RollbarCachesDirectory_h
