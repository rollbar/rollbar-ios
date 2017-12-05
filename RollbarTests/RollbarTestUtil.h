//
//  RollbarTestUtil.h
//  RollbarTests
//
//  Created by Ben Wong on 12/1/17.
//  Copyright © 2017 Rollbar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RollbarTestUtil : NSObject

void RollbarClearLogFile();
NSArray* RollbarReadLogItemFromFile();

@end
