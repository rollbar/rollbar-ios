//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSJSONSerialization (Rollbar)

NS_ASSUME_NONNULL_BEGIN

+ (nullable NSData *)dataWithJSONObject:(id)obj
                                options:(NSJSONWritingOptions)opt
                                  error:(NSError **)error
                                   safe:(BOOL)safe;

+ (NSDictionary *)safeDataFromJSONObject:(id)obj;

+ (unsigned long)measureJSONDataByteSize:(NSData *)jsonData;

NS_ASSUME_NONNULL_END

@end
