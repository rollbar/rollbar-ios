//
//  Header.h
//  Rollbar
//
//  Created by Andrey Kornich (Wide Spectrum Computing LLC) on 2018-09-17.
//  Copyright © 2018 Rollbar. All rights reserved.
//

//#ifndef Header_h
//#define Header_h

#import <Foundation/Foundation.h>

@protocol RollbarJSONFriendlyProtocol
@required
// Designated Initializer:
- (id)initWithJSONData:(NSDictionary *)jsonData;
- (NSDictionary *)asJSONData;
@optional
@end

//#endif /* Header_h */
