//
//  RollbarDTO+Protected.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#ifndef RollbarDTO_Protected_h
#define RollbarDTO_Protected_h

#import "RollbarDTO.h"
#import "RollbarTriStateFlag.h"

NS_ASSUME_NONNULL_BEGIN

/// Dfines the protected DTO interface
@interface RollbarDTO (Protected)

#pragma mark - Properties

@property (nonatomic, readonly, nullable) NSMutableDictionary *dataDictionary;
@property (nonatomic, readonly, nullable) NSMutableArray *dataArray;

#pragma mark - Core API: transferable data getter/setter by key

/// Gets a transferrable data object (or nil) by its key.
/// @param key the data key
- (nullable id)getDataByKey:(nonnull NSString *)key;
/// Sets transferrable data by its key
/// @param data the transferable data (or nil)
/// @param key the data key
- (void)setData:(nullable id)data byKey:(nonnull NSString *)key;

/// Merges given data dictionary into the underlaying data dictioanry
/// @param data data dictionary to append
- (void)mergeDataDictionary:(nonnull NSDictionary *)data;

#pragma mark - Core API: safe data getters by key

- (RollbarDTO *)safelyGetDataTransferObjectByKey:(NSString *)key;
- (NSMutableDictionary *)safelyGetDictionaryByKey:(NSString *)key;
- (NSMutableArray *)safelyGetArrayByKey:(NSString *)key;
- (NSMutableString *)safelyGetStringByKey:(NSString *)key;
- (NSNumber *)safelyGetNumberByKey:(NSString *)key;

#pragma mark - Core API: data setters by key

- (void)setDataTransferObject:(RollbarDTO *)data forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)data forKey:(NSString *)key;
- (void)setArray:(NSArray *)data forKey:(NSString *)key;
- (void)setString:(NSString *)data forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)data forKey:(NSString *)key;

#pragma mark - Convenience API

- (RollbarTriStateFlag)safelyGetTriStateFlagByKey:(NSString *)key;
- (void)setTriStateFlag:(RollbarTriStateFlag)data forKey:(NSString *)key;

- (BOOL)safelyGetBoolByKey:(NSString *)key;
- (void)setBool:(BOOL)data forKey:(NSString *)key;

- (NSUInteger)safelyGetUIntegerByKey:(NSString *)key;
- (void)setUInteger:(NSUInteger)data forKey:(NSString *)key;

- (NSInteger)safelyGetIntegerByKey:(NSString *)key;
- (void)setInteger:(NSInteger)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

#endif //RollbarDTO_Protected_h
