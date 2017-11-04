//
//  RollbarUtil.m
//  Rollbar
//
//  Created by Freddy Hernandez on 11/3/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import "RollbarUtil.h"
#import "RollbarLogger.h"

@implementation RollbarUtil

+ (NSMutableDictionary*)jsonSafePayloadFromDictionary:(NSDictionary*)dictionary {
    NSMutableDictionary* d = [NSMutableDictionary new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSDictionary class]]) {
            [d setObject:[self jsonSafePayloadFromDictionary:obj] forKey:key];
        } else if ([NSJSONSerialization isValidJSONObject:@{key:obj}]) {
            [d setObject:obj forKey:key];
        } else if ([obj isKindOfClass:[NSDate class]]) {
            [d setObject:[obj description] forKey:key];
        } else if ([obj isKindOfClass:[NSURL class]]) {
            [d setObject:[obj absoluteString] forKey:key];
        } else if ([obj isKindOfClass:[NSError class]]) {
            [d setObject:[self jsonSafePayloadFromDictionary:[obj userInfo]] forKey:key];
        } else if ([obj isKindOfClass:[NSHTTPURLResponse class]]) {
            [d setObject:[obj allHeaderFields] forKey:key];
        } else if ([obj isKindOfClass:[NSData class]]) {
            NSError* error = nil;
            NSDictionary* json = [NSJSONSerialization JSONObjectWithData:obj options:kNilOptions error:&error];
            if (error == nil) {
                [d setObject:[self jsonSafePayloadFromDictionary:json] forKey:key];
            } else {
                RollbarLog(@"There was an error serializing NSData in payload to Rollbar");
                RollbarLog(@"Error: %@", [error localizedDescription]);
            }
        } else {
            // oops we didn't queue the whole payload
            RollbarLog(@"There was an error serializing values in payload to Rollbar");
            RollbarLog(@"Error: %@ can not be serialized by NSJSONSerialization", NSStringFromClass([obj class]));
        }
    }];
    return d;
}

@end
