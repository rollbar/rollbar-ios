//
//  RollbarJSONFriendlyObject.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef RollbarJSONFriendlyObject_h
//#define RollbarJSONFriendlyObject_h

#import <Foundation/Foundation.h>

#import "RollbarJSONFriendlyProtocol.h"

@interface RollbarJSONFriendlyObject : NSObject<RollbarJSONFriendlyProtocol>
@property (readonly) NSMutableDictionary *dataDictionary;
- (id)initWithJSONData:(NSDictionary *)jsonData;
@end

//#endif /* RollbarJSONFriendlyObject_h */
