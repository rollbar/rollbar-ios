//  Copyright © 2018 Rollbar. All rights reserved.

#import <Foundation/Foundation.h>

@protocol RollbarJSONFriendlyProtocol
@required
- (NSDictionary *)asJSONData;

- (id)initWithJSONData:(NSDictionary *)jsonData;
@optional
@end
