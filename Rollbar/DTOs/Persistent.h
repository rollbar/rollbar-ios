//
//  Persistent.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-09.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Persistent <NSObject>

- (BOOL)saveToFile:(NSString *)filePath;
- (BOOL)loadFromFile:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
