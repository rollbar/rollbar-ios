//  Copyright © 2018 Rollbar. All rights reserved.

@import Foundation;

#pragma mark - RollbarLevel

typedef NS_ENUM(NSUInteger, RollbarLevel) {
    RollbarLevel_Info,
    RollbarLevel_Debug,
    RollbarLevel_Warning,
    RollbarLevel_Critical,
    RollbarLevel_Error
};

#pragma mark - RollbarLevel utility

NS_ASSUME_NONNULL_BEGIN

/// RollbarLevel utility
@interface RollbarLevelUtil : NSObject

/// Converts RollbarLevel enum value to its string equivalent or default string.
/// @param value RollbarLevel enum value
+ (NSString *) RollbarLevelToString:(RollbarLevel)value;

/// Converts string value into its  RollbarLevel enum value equivalent or default enum value.
/// @param value input string
+ (RollbarLevel) RollbarLevelFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
