//
//  CaptureIpType.h
//  Rollbar
//
//  Created by Andrey Kornich on 2019-10-15.
//  Copyright © 2019 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, CaptureIpType) {
    CaptureIpFull,
    CaptureIpAnonymize,
    CaptureIpNone
};

NS_ASSUME_NONNULL_BEGIN

@interface CaptureIpTypeUtil : NSObject

+ (NSString *) CaptureIpTypeToString:(CaptureIpType)value;
+ (CaptureIpType) CaptureIpTypeFromString:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
