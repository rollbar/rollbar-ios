//
//  RollbarDeploysManager.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef RollbarDeploysManager_h
//#define RollbarDeploysManager_h

#import <Foundation/Foundation.h>

#import "RollbarDeploysProtocol.h"

@interface RollbarDeploysManager : NSObject <RollbarDeploysProtocol> {
    NSMutableData *responseData;
}
// Designated Initializer:
- (id)initWithWriteAccessToken:(NSString *)writeAccessToken
               readAccessToken:(NSString *)readAccessToken;
@end

//#endif /* RollbarDeploysManager_h */
