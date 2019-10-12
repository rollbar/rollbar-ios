//
//  DataTransferObject+Protected.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface DataTransferObject (Protected)

- (id)initWithDictionary: (NSMutableDictionary *)data;

- (NSMutableDictionary *)saflyGetDictionaryByKey:(NSString *)key;
- (NSMutableArray *)saflyGetArrayByKey:(NSString *)key;
- (NSMutableString *)saflyGetStringByKey:(NSString *)key;
- (NSNumber *)saflyGetNumberByKey:(NSString *)key;

- (void)setDictionary:(NSMutableDictionary *)data forKey:(NSString *)key;
- (void)setArray:(NSMutableArray *)data forKey:(NSString *)key;
- (void)setString:(NSMutableString *)data forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
