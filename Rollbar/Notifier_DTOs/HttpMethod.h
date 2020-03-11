//
//  HttpMethod.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - HttpMethod enum

typedef NS_ENUM(NSUInteger, HttpMethod) {
    Head,
    Get,
    Post,
    Put,
    Patch,
    Delete,
    Connect,
    Options,
    Trace,
};

#pragma mark - CaptureIpTypeUtil

NS_ASSUME_NONNULL_BEGIN

@interface HttpMethodUtil : NSObject

/// Convert HttpMethod to a string
/// @param value CaptureIpType value
+ (NSString *) HttpMethodToString:(HttpMethod)value;

/// Convert HttpMethod value from a string
/// @param value string representation of a CaptureIpType value
+ (HttpMethod) HttpMethodFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
