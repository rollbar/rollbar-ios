//
//  RollbarPersistent.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-09.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#ifndef RollbarPersistent_h
#define RollbarPersistent_h

@import Foundation;

NS_ASSUME_NONNULL_BEGIN

/// A protocol adding support for file-persistence
@protocol RollbarPersistent <NSObject>

/// Save to a file
/// @param filePath file path to save to
- (BOOL)saveToFile:(NSString *)filePath;

/// Load object state/data from a file
/// @param filePath file path to load from
- (BOOL)loadFromFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END

#endif //RollbarPersistent_h
