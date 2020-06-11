//
//  RollbarDTO+Protected.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "RollbarDTO+Protected.h"

@implementation RollbarDTO (Protected)

#pragma mark - Property overrides

- (NSString *)description {
    return [self serializeToJSONString];
}

#pragma mark - Properties

-(NSMutableDictionary *)dataDictionary {
    if (self->_dataDictionary) {
        return self->_dataDictionary;
    }
    else {
        if (!self->_data || self->_data == [NSNull null]) {
            return self->_dataDictionary;
        }
        if (!self->_dataArray && [self->_data isKindOfClass:[NSDictionary class]]) {
            self->_dataDictionary = (NSMutableDictionary *) self->_data;
        }
        return self->_dataDictionary;
    }
}

-(NSMutableArray *)dataArray {
    if (self->_dataArray) {
        return self->_dataArray;
    }
    else {
        if (!self->_data || self->_data == [NSNull null]) {
            return self->_dataArray;
        }
        if (!self->_dataDictionary && [self->_data isKindOfClass:[NSArray class]]) {
            self->_dataArray = (NSMutableArray *) self->_data;
        }
        return self->_dataArray;
    }
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
    if ([RollbarDTO isTransferableDataValue:data]) {
        [self->_data setObject:data forKey:key];
        //[self->_data setValue:data forKey:key];
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

- (RollbarDTO *)safelyGetDataTransferObjectByKey:(NSString *)key {
//    RollbarDTO *result = [self->_data objectForKey:key];
//    if (nil == result) {
//        result = [[RollbarDTO alloc] initWi];
//        [self->_data setObject:result forKey:key];
//    }
    RollbarDTO *result = [[RollbarDTO alloc] initWithDictionary:[self->_data objectForKey:key]];

    return result;
}

- (NSMutableDictionary *)safelyGetDictionaryByKey:(NSString *)key {
    NSMutableDictionary *result = [self->_dataDictionary objectForKey:key];
    if (!result) {
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

- (void)setDataTransferObject:(RollbarDTO *)data forKey:(NSString *)key {
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

- (RollbarTriStateFlag)safelyGetTriStateFlagByKey:(NSString *)key {
    NSString *result = [self->_data objectForKey:key];
    if (result == nil) {
        return RollbarTriStateFlag_None;
    }
    else {
        return [RollbarTriStateFlagUtil TriStateFlagFromString:result];
    }
}

- (void)setTriStateFlag:(RollbarTriStateFlag)data forKey:(NSString *)key{
    if (data == RollbarTriStateFlag_None) {
        [self->_data removeObjectForKey:key];
    }
    else {
        [self->_data setObject:[RollbarTriStateFlagUtil TriStateFlagToString:data].mutableCopy
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
