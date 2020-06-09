//
//  RollbarCaptureIpType.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-15.
//  Copyright © 2019 Rollbar. All rights reserved.
//

@import Foundation;

#pragma mark - RollbarCaptureIpType enum

typedef NS_ENUM(NSUInteger, RollbarCaptureIpType) {
    RollbarCaptureIpType_Full,
    RollbarCaptureIpType_Anonymize,
    RollbarCaptureIpType_None
};

#pragma mark - CaptureIpTypeUtil

NS_ASSUME_NONNULL_BEGIN

/// Utility class aiding with CaptureIpType conversions
@interface RollbarCaptureIpTypeUtil : NSObject

/// Convert CaptureIpType to a string
/// @param value RollbarCaptureIpType value
+ (NSString *) CaptureIpTypeToString:(RollbarCaptureIpType)value;

/// Convert CaptureIpType value from a string
/// @param value string representation of a RollbarCaptureIpType value
+ (RollbarCaptureIpType) CaptureIpTypeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
