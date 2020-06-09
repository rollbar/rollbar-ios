//
//  RollbarHttpMethod.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import Foundation;

#pragma mark - RollbarHttpMethod enum

typedef NS_ENUM(NSUInteger, RollbarHttpMethod) {
    RollbarHttpMethod_Head,
    RollbarHttpMethod_Get,
    RollbarHttpMethod_Post,
    RollbarHttpMethod_Put,
    RollbarHttpMethod_Patch,
    RollbarHttpMethod_Delete,
    RollbarHttpMethod_Connect,
    RollbarHttpMethod_Options,
    RollbarHttpMethod_Trace,
};

#pragma mark - RollbarHttpMethodUtil

NS_ASSUME_NONNULL_BEGIN

@interface RollbarHttpMethodUtil : NSObject

/// Convert RollbarHttpMethod to a string
/// @param value RollbarHttpMethod value
+ (NSString *) HttpMethodToString:(RollbarHttpMethod)value;

/// Convert RollbarHttpMethod value from a string
/// @param value string representation of a RollbarHttpMethod value
+ (RollbarHttpMethod) HttpMethodFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
