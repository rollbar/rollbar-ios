//
//  OptionalBool.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - CaptureIpType enum

typedef NS_ENUM(NSUInteger, OptionalBool) {
    Unknown,
    YES,
    NO
};

#pragma mark - CaptureIpTypeUtil

NS_ASSUME_NONNULL_BEGIN

/// Utility class aiding with CaptureIpType conversions
@interface CaptureIpTypeUtil : NSObject

/// Convert CaptureIpType to a string
/// @param value CaptureIpType value
+ (NSString *) CaptureIpTypeToString:(CaptureIpType)value;

/// Convert CaptureIpType value from a string
/// @param value string representation of a CaptureIpType value
+ (CaptureIpType) CaptureIpTypeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
