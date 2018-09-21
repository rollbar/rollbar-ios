//
//  Header.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RollbarJSONFriendlyProtocol
@required
- (NSDictionary *)asJSONData;
// Designated Initializer:
- (id)initWithJSONData:(NSDictionary *)jsonData;
@optional
@end
