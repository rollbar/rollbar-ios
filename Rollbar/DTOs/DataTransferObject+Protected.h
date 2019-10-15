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

- (DataTransferObject *)safelyGetDataTransferObjectByKey:(NSString *)key;
- (NSMutableDictionary *)safelyGetDictionaryByKey:(NSString *)key;
- (NSMutableArray *)safelyGetArrayByKey:(NSString *)key;
- (NSMutableString *)safelyGetStringByKey:(NSString *)key;
- (NSNumber *)safelyGetNumberByKey:(NSString *)key;

- (void)setDataTransferObject:(DataTransferObject *)data forKey:(NSString *)key;
- (void)setDictionary:(NSMutableDictionary *)data forKey:(NSString *)key;
- (void)setArray:(NSMutableArray *)data forKey:(NSString *)key;
- (void)setString:(NSMutableString *)data forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
