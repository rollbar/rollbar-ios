//
//  DataTransferObject+Protected.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-10.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject+Protected.h"

@implementation DataTransferObject (Protected)

- (id)initWithDictionary: (NSMutableDictionary *)data {
    self = [super init];
    if (self) {
        if (!data) {
            return self;
        }
        else if (![DataTransferObject isTransferableObject:data]) {
            return self;
        }
        else {
            self->_data = data;
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

- (NSMutableDictionary *)saflyGetDictionaryByKey:(NSString *)key {
    NSMutableDictionary *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSMutableDictionary alloc] initWithCapacity:5];
        [self->_data setObject:result forKey:key];
    }
    return result;
}

- (NSMutableArray *)saflyGetArrayByKey:(NSString *)key {
    NSMutableArray *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSMutableArray alloc] initWithCapacity:5];
        [self->_data setObject:result forKey:key];
    }
    return result;
}

- (NSMutableString *)saflyGetStringByKey:(NSString *)key {
    NSMutableString *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSMutableString alloc] initWithCapacity:5];
        [self->_data setObject:result forKey:key];
    }
    return result;
}

- (NSNumber *)saflyGetNumberByKey:(NSString *)key {
    NSNumber *result = [self->_data objectForKey:key];
    if (nil == result) {
        result = [[NSNumber alloc] init];
        [self->_data setObject:result forKey:key];
    }
    return result;
}


- (void)setDictionary:(NSMutableDictionary *)data forKey:(NSString *)key {
    [self->_data setObject:data forKey:key];
}

- (void)setArray:(NSMutableArray *)data forKey:(NSString *)key {
    [self->_data setObject:data forKey:key];
}

- (void)setString:(NSMutableString *)data forKey:(NSString *)key {
    [self->_data setObject:data forKey:key];
}

- (void)setNumber:(NSNumber *)data forKey:(NSString *)key {
    [self->_data setObject:data forKey:key];
}

@end
