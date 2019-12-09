//
//  DataTransferObject+Protected.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject+Protected.h"

@implementation DataTransferObject (Protected)

#pragma mark - Initializers

- (instancetype)initWithJSONData: (NSData *)data {
    self = [super init];
    if (self) {
        [self deserializeFromJSONData:data];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)data;  {
    
        self = [super init];
        if (self) {
            if (!data) {
                return self;
            }
            else if (![DataTransferObject isTransferableObject:data]) {
                return self;
            }
            else {
                if ([data isKindOfClass:[NSMutableDictionary class]]) {
                    self->_data = (NSMutableDictionary *)data;
                }
                else {
                    self->_data = data.mutableCopy;
                }
                    
            }
    //        else if ([data isKindOfClass:[NSMutableDictionary class]]) {
    //            self->_data = (NSMutableDictionary *) data;
    //        }
    //        else if ([data isKindOfClass:[NSDictionary class]]) {
    //            self->_data = [data mutableCopy];
    //        }
        }
        return self;
}

- (instancetype)initWithArray:(NSArray *)data {
    //TODO: implement...
    return nil;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:@"Must use one of initWith...: instead."
                                 userInfo:nil];
}

#pragma mark - Property overrides

- (NSString *)description {
    return [self serializeToJSONString];
}

#pragma mark - Core API: transferable data getter/setter by key

- (nullable id)getDataByKey:(nonnull NSString *)key {
    id result = [self->_data objectForKey:key];
    if (result == [NSNull null]) {
        return nil;
    }
    return result;
}

- (void)setData:(nullable id)data byKey:(nonnull NSString *)key {
    if (!data) {
        // setting nil data is equivalent to removing its KV-pair (if any):
        [self->_data removeObjectForKey:key];
        return;
    }
    if ([DataTransferObject isTransferableDataValue:data]) {
        [self->_data setObject:data forKey:key];
    }
    else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"An attempt to set non-transferable data to self->_data!"
                                     userInfo:nil];
    }
}

- (void)mergeDataDictionary:(nonnull NSDictionary *)data {
    if (data) {
        [self->_data addEntriesFromDictionary:data];
    }
}

#pragma mark - safe data getters by key

- (DataTransferObject *)safelyGetDataTransferObjectByKey:(NSString *)key {
//    DataTransferObject *result = [self->_data objectForKey:key];
//    if (nil == result) {
//        result = [[DataTransferObject alloc] initWi];
//        [self->_data setObject:result forKey:key];
//    }
    DataTransferObject *result = [[DataTransferObject alloc] initWithDictionary:[self->_data objectForKey:key]];

    return result;
}

- (NSMutableDictionary *)safelyGetDictionaryByKey:(NSString *)key {
    NSMutableDictionary *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSMutableDictionary alloc] initWithCapacity:5];
        [self->_data setObject:result forKey:key];
    }
    return result;
}

- (NSMutableArray *)safelyGetArrayByKey:(NSString *)key {
    NSMutableArray *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSMutableArray alloc] initWithCapacity:5];
        [self->_data setObject:result forKey:key];
    }
    return result;
}

- (NSMutableString *)safelyGetStringByKey:(NSString *)key {
    NSMutableString *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSMutableString alloc] initWithCapacity:5];
        [self->_data setObject:result forKey:key];
    }
    return result;
}

- (NSNumber *)safelyGetNumberByKey:(NSString *)key {
    NSNumber *result = [self->_data objectForKey:key];
//    if (nil == result) {
//        result = [[NSNumber alloc] init];
//        [self->_data setObject:result forKey:key];
//    }
    return result;
}

#pragma mark - data setters by key

- (void)setDataTransferObject:(DataTransferObject *)data forKey:(NSString *)key {
    [self->_data setObject:(data->_data) forKey:key];
}

- (void)setDictionary:(NSDictionary *)data forKey:(NSString *)key {
    [self->_data setObject:data.mutableCopy forKey:key];
}

- (void)setArray:(NSArray *)data forKey:(NSString *)key {
    [self->_data setObject:data.mutableCopy forKey:key];
}

- (void)setString:(NSString *)data forKey:(NSString *)key {
    [self->_data setObject:data.mutableCopy forKey:key];
}

- (void)setNumber:(NSNumber *)data forKey:(NSString *)key {
    [self->_data setObject:data forKey:key];
}

#pragma mark - Convenience API

- (TriStateFlag)safelyGetTriStateFlagByKey:(NSString *)key {
    NSString *result = [self->_data objectForKey:key];
    if (result == nil) {
        return None;
    }
    else {
        return [TriStateFlagUtil TriStateFlagFromString:result];
    }
}
- (void)setTriStateFlag:(TriStateFlag)data forKey:(NSString *)key{
    if (data == None) {
        [self->_data removeObjectForKey:key];
    }
    else {
        [self->_data setObject:[TriStateFlagUtil TriStateFlagToString:data].mutableCopy
                        forKey:key];
    }
}

- (BOOL)safelyGetBoolByKey:(NSString *)key {
    NSNumber *number = [self safelyGetNumberByKey:key];
    return number.boolValue;
}
- (void)setBool:(BOOL)data forKey:(NSString *)key {
    NSNumber *number = [NSNumber numberWithBool:data];
    [self setNumber:number forKey:key];
}

- (NSUInteger)safelyGetUIntegerByKey:(NSString *)key {
    NSNumber *value = [self safelyGetNumberByKey:key];
    return value.unsignedIntegerValue;
}

- (void)setUInteger:(NSUInteger)data forKey:(NSString *)key {
    NSNumber *number = @(data);
    [self setNumber:number forKey:key];
}

- (NSInteger)safelyGetIntegerByKey:(NSString *)key {
    NSNumber *value = [self safelyGetNumberByKey:key];
    return value.integerValue;
}

- (void)setInteger:(NSInteger)data forKey:(NSString *)key {
    NSNumber *number = @(data);
    [self setNumber:number forKey:key];
}

@end
