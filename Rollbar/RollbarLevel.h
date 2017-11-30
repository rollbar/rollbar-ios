//
//  RollbarLevel.h
//  Rollbar
//
//  Created by Ben Wong on 11/25/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    RollbarInfo,
    RollbarDebug,
    RollbarWarning,
    RollbarCritical,
    RollbarError
} RollbarLevel;

NSString* RollbarStringFromLevel(RollbarLevel level);
