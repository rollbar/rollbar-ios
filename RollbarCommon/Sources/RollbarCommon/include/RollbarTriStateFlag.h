//
//  RollbarTriStateFlag.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#ifndef RollbarTriStateFlag_h
#define RollbarTriStateFlag_h

@import Foundation;

#pragma mark - RollbarTriStateFlag enum

typedef NS_ENUM(NSUInteger, RollbarTriStateFlag) {
    RollbarTriStateFlag_None,
    RollbarTriStateFlag_On,
    RollbarTriStateFlag_Off
};

#pragma mark - RollbarTriStateFlagUtil

NS_ASSUME_NONNULL_BEGIN

/// Utility class aiding with TriStateFlag conversions
@interface RollbarTriStateFlagUtil : NSObject

/// Convert TriStateFlag to a string
/// @param value TriStateFlag value
+ (NSString *) TriStateFlagToString:(RollbarTriStateFlag)value;

/// Convert TriStateFlag value from a string
/// @param value string representation of a TriStateFlag value
+ (RollbarTriStateFlag) TriStateFlagFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END

#endif //RollbarTriStateFlag_h
