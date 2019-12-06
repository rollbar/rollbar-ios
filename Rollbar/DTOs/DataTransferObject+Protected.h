//
//  DataTransferObject+Protected.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "TriStateFlag.h"

NS_ASSUME_NONNULL_BEGIN

/// Dfines the protected DTO interface
@interface DataTransferObject (Protected)

#pragma mark - Initializers

- (instancetype)initWithJSONData:(NSData *)data;
- (instancetype)initWithDictionary:(NSDictionary *)data;
- (instancetype)initWithArray:(NSArray *)data;

#pragma mark - Core API: data getters by key

- (id)getDataByKey:(NSString *)key;

#pragma mark - Core API: safe data getters by key

- (DataTransferObject *)safelyGetDataTransferObjectByKey:(NSString *)key;
- (NSMutableDictionary *)safelyGetDictionaryByKey:(NSString *)key;
- (NSMutableArray *)safelyGetArrayByKey:(NSString *)key;
- (NSMutableString *)safelyGetStringByKey:(NSString *)key;
- (NSNumber *)safelyGetNumberByKey:(NSString *)key;

#pragma mark - Core API: data setters by key

- (void)setDataTransferObject:(DataTransferObject *)data forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)data forKey:(NSString *)key;
- (void)setArray:(NSArray *)data forKey:(NSString *)key;
- (void)setString:(NSString *)data forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)data forKey:(NSString *)key;

#pragma mark - Convenience API

- (TriStateFlag)safelyGetTriStateFlagByKey:(NSString *)key;
- (void)setTriStateFlag:(TriStateFlag)data forKey:(NSString *)key;

- (BOOL)safelyGetBoolByKey:(NSString *)key;
- (void)setBool:(BOOL)data forKey:(NSString *)key;

- (NSUInteger)safelyGetUIntegerByKey:(NSString *)key;
- (void)setUInteger:(NSUInteger)data forKey:(NSString *)key;

- (NSInteger)safelyGetIntegerByKey:(NSString *)key;
- (void)setInteger:(NSInteger)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
