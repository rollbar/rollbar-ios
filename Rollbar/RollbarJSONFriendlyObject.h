//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

#import "RollbarJSONFriendlyProtocol.h"

@interface RollbarJSONFriendlyObject : NSObject<RollbarJSONFriendlyProtocol>
@property (readonly) NSMutableDictionary *dataDictionary;
- (id)initWithJSONData:(NSDictionary *)jsonData;
@end
