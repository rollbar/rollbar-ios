//
//  DataTransferObject+Protected.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"

NS_ASSUME_NONNULL_BEGIN

/// Dfines the protected DTO interface
@interface DataTransferObject (Protected)

#pragma mark - Initializers

/// Initializes a DTO with data from a dictionary
/// @param data the dictionary
- (id)initWithDictionary: (NSDictionary *)data;

#pragma mark - safe data getters by key

- (DataTransferObject *)safelyGetDataTransferObjectByKey:(NSString *)key;
- (NSMutableDictionary *)safelyGetDictionaryByKey:(NSString *)key;
- (NSMutableSet *)safelyGetSetByKey:(NSString *)key;
- (NSMutableArray *)safelyGetArrayByKey:(NSString *)key;
- (NSMutableString *)safelyGetStringByKey:(NSString *)key;
- (NSNumber *)safelyGetNumberByKey:(NSString *)key;

#pragma mark - data setters by key

- (void)setDataTransferObject:(DataTransferObject *)data forKey:(NSString *)key;
- (void)setDictionary:(NSDictionary *)data forKey:(NSString *)key;
- (void)setSet:(NSSet *)data forKey:(NSString *)key;
- (void)setArray:(NSArray *)data forKey:(NSString *)key;
- (void)setString:(NSString *)data forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)data forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
