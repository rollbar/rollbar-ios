//
//  NSJSONSerialization+Rollbar.h
//  Rollbar
//
//  Created by Ben Wong on 11/8/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Rollbar)

NS_ASSUME_NONNULL_BEGIN

+ (nullable NSData *)dataWithJSONObject:(id)obj options:(NSJSONWritingOptions)opt error:(NSError **)error safe:(BOOL)safe;
+ (NSDictionary *)safeDataFromJSONObject:(id)obj;

NS_ASSUME_NONNULL_END

@end
