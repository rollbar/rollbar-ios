//
//  DataTransferObject.m
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-08.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import "DataTransferObject.h"
#import "RollbarLogger.h"

#import <Foundation/NSObjCRuntime.h>

@implementation DataTransferObject {

}

#pragma mark JSON processing routines

+ (BOOL)isTransferableObject:(id)obj {
    BOOL result = [NSJSONSerialization isValidJSONObject:obj];
    return result;
}

+ (nullable NSData *)dataWithJSONObject:(id)obj
                                options:(NSJSONWritingOptions)opt
                                  error:(NSError **)error
                                   safe:(BOOL)safe {
    if (safe) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSMutableArray *newArr = [NSMutableArray array];
            for (id item in obj) {
                if ([item isKindOfClass:[NSDictionary class]]) {
                    [newArr addObject:[[self class] safeDataFromJSONObject:item]];
                } else {
                    [newArr addObject:item];
                }
            }
            return [NSJSONSerialization dataWithJSONObject:newArr
                                                   options:opt
                                                     error:error];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            return [NSJSONSerialization dataWithJSONObject:[[self class] safeDataFromJSONObject:obj]
                                                   options:opt
                                                     error:error];
        }
    }
    return [NSJSONSerialization dataWithJSONObject:obj options:opt error:error];
}

+ (NSMutableDictionary *)safeDataFromJSONObject:(id)obj {
    NSMutableDictionary *safeData = [NSMutableDictionary new];
    [obj enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [safeData setObject:[[self class] safeDataFromJSONObject:obj] forKey:key];
        } else if ([NSJSONSerialization isValidJSONObject:@{key:obj}]) {
            [safeData setObject:obj forKey:key];
        } else if ([obj isKindOfClass:[NSDate class]]) {
            [safeData setObject:[obj description] forKey:key];
        } else if ([obj isKindOfClass:[NSURL class]]) {
            [safeData setObject:[obj absoluteString] forKey:key];
        } else if ([obj isKindOfClass:[NSError class]]) {
            [safeData setObject:[[self class] safeDataFromJSONObject:[obj userInfo]] forKey:key];
        } else if ([obj isKindOfClass:[NSHTTPURLResponse class]]) {
            [safeData setObject:[obj allHeaderFields] forKey:key];
        } else if ([obj isKindOfClass:[NSSet class]]) {
            [safeData setObject:[[obj allObjects] componentsJoinedByString:@","] forKey:key];
        } else if ([obj isKindOfClass:[NSData class]]) {
            NSError* error = nil;
            NSMutableDictionary* json =
                [NSJSONSerialization JSONObjectWithData:obj
                                                options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)
                                                  error:&error];

            if (error == nil) {
                [safeData setObject:[[self class] safeDataFromJSONObject:json] forKey:key];
            } else {
                RollbarLog(@"Error serializing NSData: %@", [error localizedDescription]);
            }
        } else {
            RollbarLog(@"Error serializing class '%@' using NSJSONSerialization",
                       NSStringFromClass([obj class]));
        }
    }];
    return safeData;
}

+ (unsigned long)measureJSONDataByteSize:(NSData*)jsonData {
    
    return jsonData.length;
}

#pragma mark de/serialization methods of JSONSupport protocol

- (NSDictionary *)jsonFriendlyData {
    return self->_data;
}

- (NSData *)serializeToJSONData {
    NSData *jsonData = [DataTransferObject dataWithJSONObject:self->_data
                                                      options:0
                                                        error:nil
                                                         safe:true];
    return jsonData;
}

- (nonnull NSString *)serializeToJSONString {
    NSData *jsonData = [self serializeToJSONData];
    NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return result;
}

- (BOOL)deserializeFromJSONData:(NSData *)jsonData {
    if (!jsonData) {
        self->_data = [[NSMutableDictionary alloc] initWithCapacity:10];
        return NO;
    }
    NSError *error;
    self->_data =
    [NSJSONSerialization JSONObjectWithData:jsonData
                                    options:(NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves)
                                      error:&error];
    if (!self->_data) {
        self->_data = [[NSMutableDictionary alloc] initWithCapacity:10];
        RollbarLog(@"Error restoring data from JSON NSData instance: %@", jsonData);
        RollbarLog(@"Error details: %@", error);
        return NO;
    }
    return YES;
}

- (BOOL)deserializeFromJSONString:(NSString *)jsonString {
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) {
        RollbarLog(@"Error converting an NSString instance to NSData: %@", jsonString);
        return NO;
    }
    return [self deserializeFromJSONData:jsonData];
}

#pragma mark initialization methods

- (id)initWithJSONString: (NSString *)jsonString {
    self = [super init];
    if (self) {
        [self deserializeFromJSONString:jsonString];
    }
    return self;
}

- (id)initWithJSONData: (NSData *)jsonData {
    self = [super init];
    if (self) {
        [self deserializeFromJSONData:jsonData];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self->_data = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    return self;
}

@end
