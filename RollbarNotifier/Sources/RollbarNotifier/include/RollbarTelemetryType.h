//  Copyright (c) 2018 Rollbar, Inc. All rights reserved.

@import Foundation;

#pragma mark - RollbarTelemetryType

typedef NS_ENUM(NSUInteger, RollbarTelemetryType) {
    RollbarTelemetryType_Log,
    RollbarTelemetryType_View,
    RollbarTelemetryType_Error,
    RollbarTelemetryType_Navigation,
    RollbarTelemetryType_Network,
    RollbarTelemetryType_Connectivity,
    RollbarTelemetryType_Manual
};


#pragma mark - RollbarLevel utility

NS_ASSUME_NONNULL_BEGIN

/// RollbarTelemetryType utility
@interface RollbarTelemetryTypeUtil : NSObject

/// Converts RollbarTelemetryType enum value to its string equivalent or default string.
/// @param value RollbarTelemetryType enum value
+ (NSString *) RollbarTelemetryTypeToString:(RollbarTelemetryType)value;

/// Converts string value into its  RollbarTelemetryType enum value equivalent or default enum value.
/// @param value input string
+ (RollbarTelemetryType) RollbarTelemetryTypeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END

//#pragma mark - deprecated
//
//NSString* _Nonnull RollbarStringFromTelemetryType(RollbarTelemetryType type)
//DEPRECATED_MSG_ATTRIBUTE("Use [RollbarTelemetryTypeUtil RollbarTelemetryTypeToString:...] methods instead.");

