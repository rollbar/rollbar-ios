//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

typedef enum {
    RollbarInfo,
    RollbarDebug,
    RollbarWarning,
    RollbarCritical,
    RollbarError
} RollbarLevel;

NSString* RollbarStringFromLevel(RollbarLevel level);
RollbarLevel RollbarLevelFromString(NSString *levelString);
