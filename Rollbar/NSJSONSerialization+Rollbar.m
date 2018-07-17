//
//  NSJSONSerialization+Rollbar.m
//  Rollbar
//
//  Created by Ben Wong on 11/8/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "NSJSONSerialization+Rollbar.h"
#import "Rollbar.h"
#import "RollbarLogger.h"

@implementation NSJSONSerialization (Rollbar)

NS_ASSUME_NONNULL_BEGIN

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
            return [NSJSONSerialization dataWithJSONObject:newArr options:opt error:error];
        } else if ([obj isKindOfClass:[NSMutableDictionary class]]) {
            return [NSJSONSerialization dataWithJSONObject:[[self class] safeDataFromJSONObject:obj] options:opt error:error];
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
            NSMutableDictionary* json = [NSJSONSerialization JSONObjectWithData:obj options:kNilOptions error:&error];

            if (error == nil) {
                [safeData setObject:[[self class] safeDataFromJSONObject:json] forKey:key];
            } else {
                RollbarLog(@"Error serializing NSData: %@", [error localizedDescription]);
            }
        } else {
            RollbarLog(@"Error serializing class '%@' using NSJSONSerialization", NSStringFromClass([obj class]));
        }
    }];
    return safeData;
}

+ (unsigned long)measureJSONDataByteSize:(NSData*)jsonData {
    
    // make sure jsonData was produced using following options:
    //   NSData* jsonData = [NSJSONSerialization dataWithJSONObject:info
    //                                                      options:NSJSONWritingPrettyPrinted
    //                                                        error:&error];
    
    NSString* jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding
                            ];

    // calculate bytesize of the jsonString:
    NSUInteger totalBytes = [jsonString lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    
    return totalBytes;
}

NS_ASSUME_NONNULL_END

@end
