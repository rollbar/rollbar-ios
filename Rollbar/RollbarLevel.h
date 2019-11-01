//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#pragma mark - RollbarLevel

typedef NS_ENUM(NSUInteger, RollbarLevel) {
    RollbarInfo,
    RollbarDebug,
    RollbarWarning,
    RollbarCritical,
    RollbarError
};

#pragma mark - RollbarLevel utility

NS_ASSUME_NONNULL_BEGIN

/// RollbarLevel utility
@interface RollbarLevelUtil : NSObject

+ (NSString *) RollbarLevelToString:(RollbarLevel)value;
+ (RollbarLevel) RollbarLevelFromString:(NSString *)value;

@end

#pragma mark - deprecated

NSString* RollbarStringFromLevel(RollbarLevel level);
RollbarLevel RollbarLevelFromString(NSString *levelString);

NS_ASSUME_NONNULL_END

