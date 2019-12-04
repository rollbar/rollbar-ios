//
//  TriStateFlag.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-12-02.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - TriStateFlag enum

typedef NS_ENUM(NSUInteger, TriStateFlag) {
    None,
    On,
    Off
};

#pragma mark - TriStateFlagUtil

NS_ASSUME_NONNULL_BEGIN

/// Utility class aiding with TriStateFlag conversions
@interface TriStateFlagUtil : NSObject

/// Convert TriStateFlag to a string
/// @param value CaptureIpType value
+ (NSString *) TriStateFlagToString:(TriStateFlag)value;

/// Convert TriStateFlag value from a string
/// @param value string representation of a CaptureIpType value
+ (TriStateFlag) TriStateFlagFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
